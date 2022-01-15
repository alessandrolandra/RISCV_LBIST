// Copyright 2018 Robert Balas <balasr@student.ethz.ch>
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// Wrapper for a RI5CY testbench, containing RI5CY, Memory and stdout peripheral
// Contributor: Robert Balas <balasr@student.ethz.ch>

module riscv_wrapper
    #(parameter INSTR_RDATA_WIDTH = 128,
      parameter RAM_ADDR_WIDTH = 20,
      parameter BOOT_ADDR = 'h80,
      parameter PULP_SECURE = 1)
    (
	 input logic         clk,
	 input logic         rst,
	 input logic 		 test_mode,
	 output logic        go_nogo,

     input logic         fetch_enable_i,
     output logic        tests_passed_o,
     output logic        tests_failed_o,
     output logic [31:0] exit_value_o,
     output logic        exit_valid_o);
	 
	
	logic 				 clock_en_i;
	logic 				 fregfile_disable_i;
	logic [3:0]		 	 core_id_i;
	logic [5:0]		 	 cluster_id_i;

    // signals connecting core to memory
    logic                         instr_req;
    logic                         instr_gnt;
    logic                         instr_rvalid;
    logic [31:0]                  instr_addr;
    logic [INSTR_RDATA_WIDTH-1:0] instr_rdata;

    logic                         data_req;
    logic                         data_gnt;
    logic                         data_rvalid;
    logic [31:0]                  data_addr;
    logic                         data_we;
    logic [3:0]                   data_be;
    logic [31:0]                  data_rdata;
    logic [31:0]                  data_wdata;

    // signals to debug unit
    logic                         debug_req_i;

    // irq signals (not used)
    logic                         irq;
    logic [0:4]                   irq_id_in;
    logic                         irq_ack;
    logic [0:4]                   irq_id_out;
    logic                         irq_sec;

	logic lfsr_en;
	logic lfsr_ld;
	logic [63:0] lfsr_out;


	assign clock_en_i  = '1;
	assign fregfile_disable_i = 1'b0;
	assign core_id_i = 4'h0;
	assign cluster_id_i = 6'h0;

    // interrupts (only timer for now)
    assign irq_sec     = '0;

    assign debug_req_i = 1'b0;
	assign lfsr_en = 1'b1;
	assign lfsr_ld = 1'b0;

	LFSR lfsri //to generate random input values for the core
		(.CLK		(clk),
		 .RESET		(rst),
		 .EN		(lfsr_en),
		 .LD		(lfsr_ld),
		 .PRN		(lfsr_out));

	assign instr_rdata = lfsr_out[63:0]&lfsr_out[63:0];
	assign data_rdata = lfsr_out[31:0];
	assign irq_id_in = lfsr_out[4:0];
 	assign instr_gnt = lfsr_out[1];
	assign instr_rvalid = lfsr_out[2];
 	assign data_gnt = lfsr_out[3];
 	assign data_rvalid = lfsr_out[4];
	assign irq = lfsr_out[7];

    // instantiate the core bist
    riscv_core_bist
        #(.INSTR_RDATA_WIDTH (INSTR_RDATA_WIDTH),
          .PULP_SECURE(PULP_SECURE),
          .FPU(0))
    riscv_core_bist_i
        (		
         .clk					 ( clk                   ),
		 .rst					 ( rst				     ),
		 .test_mode				 ( test_mode			 ),
		 .go_nogo				 ( go_nogo				 ),

         .clock_en_i             ( clock_en_i            ),

         .boot_addr_i            ( BOOT_ADDR             ),
         .core_id_i              ( core_id_i             ),
         .cluster_id_i           ( cluster_id_i          ),

         .instr_addr_o           ( instr_addr            ),
         .instr_req_o            ( instr_req             ),
         .instr_rdata_i          ( instr_rdata           ),
         .instr_gnt_i            ( instr_gnt             ),
         .instr_rvalid_i         ( instr_rvalid          ),

         .data_addr_o            ( data_addr             ),
         .data_wdata_o           ( data_wdata            ),
         .data_we_o              ( data_we               ),
         .data_req_o             ( data_req              ),
         .data_be_o              ( data_be               ),
         .data_rdata_i           ( data_rdata            ),
         .data_gnt_i             ( data_gnt              ),
         .data_rvalid_i          ( data_rvalid           ),

         .apu_master_req_o       (                       ),
         .apu_master_ready_o     (                       ),
         .apu_master_gnt_i       ( lfsr_out[5]           ),
         .apu_master_operands_o  (                       ),
         .apu_master_op_o        (                       ),
         .apu_master_type_o      (                       ),
         .apu_master_flags_o     (                       ),
         .apu_master_valid_i     ( lfsr_out[6]           ),
         .apu_master_result_i    ( lfsr_out[31:0]        ),
         .apu_master_flags_i     ( lfsr_out[4:0]         ),

         .irq_i                  ( irq                   ),
         .irq_id_i               ( irq_id_in             ),
         .irq_ack_o              ( irq_ack               ),
         .irq_id_o               ( irq_id_out            ),
         .irq_sec_i              ( irq_sec               ),

         .sec_lvl_o              ( sec_lvl_o             ),

         .debug_req_i            ( debug_req_i           ),

         .fetch_enable_i         ( fetch_enable_i        ),
         .core_busy_o            ( core_busy_o           ),

         .ext_perf_counters_i    ( lfsr_out[2:1]         ),
         .fregfile_disable_i     ( fregfile_disable_i    ));
		 

    // this handles read to RAM and memory mapped pseudo peripherals
    mm_ram
        #(.RAM_ADDR_WIDTH (RAM_ADDR_WIDTH),
          .INSTR_RDATA_WIDTH (INSTR_RDATA_WIDTH))
    ram_i
        (.clk_i          ( clk_i                          ),
         .rst_ni         ( rst_ni                         ),

         .instr_req_i    ( instr_req                      ),
         .instr_addr_i   ( instr_addr[RAM_ADDR_WIDTH-1:0] ),
         .instr_rdata_o  ( instr_rdata                    ),
         .instr_rvalid_o ( instr_rvalid                   ),
         .instr_gnt_o    ( instr_gnt                      ),

         .data_req_i     ( data_req                       ),
         .data_addr_i    ( data_addr                      ),
         .data_we_i      ( data_we                        ),
         .data_be_i      ( data_be                        ),
         .data_wdata_i   ( data_wdata                     ),
         .data_rdata_o   ( data_rdata                     ),
         .data_rvalid_o  ( data_rvalid                    ),
         .data_gnt_o     ( data_gnt                       ),

         .irq_id_i       ( irq_id_out                     ),
         .irq_ack_i      ( irq_ack                        ),
         .irq_id_o       ( irq_id_in                      ),
         .irq_o          ( irq                            ),

         .pc_core_id_i   ( riscv_core_bist_i.riscvi.pc_id             ),

         .tests_passed_o ( tests_passed_o                 ),
         .tests_failed_o ( tests_failed_o                 ),
         .exit_valid_o   ( exit_valid_o                   ),
         .exit_value_o   ( exit_value_o                   ));

endmodule // riscv_wrapper
