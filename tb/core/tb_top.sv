// Copyright 2017 Embecosm Limited <www.embecosm.com>
// Copyright 2018 Robert Balas <balasr@student.ethz.ch>
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// Top level wrapper for a RI5CY testbench
// Contributor: Robert Balas <balasr@student.ethz.ch>
//              Jeremy Bennett <jeremy.bennett@embecosm.com>

module tb_top
    #(parameter INSTR_RDATA_WIDTH = 128,
      parameter RAM_ADDR_WIDTH = 22,
      parameter BOOT_ADDR  = 'h80);

    // comment to record execution trace
    `define TRACE_EXECUTION

    const time CLK_PHASE_HI       = 5ns;
    const time CLK_PHASE_LO       = 5ns;
    const time CLK_PERIOD         = CLK_PHASE_HI + CLK_PHASE_LO;
    const time STIM_APPLICATION_DEL = CLK_PERIOD * 0.1;
    const time RESP_ACQUISITION_DEL = CLK_PERIOD * 0.9;
    const time RESET_DEL = STIM_APPLICATION_DEL;
    const int  RESET_WAIT_CYCLES  = 4;


    // clock and reset for tb
    logic                   clk   = 'b1;
    logic                   rst   = 'b1;

    // cycle counter
    int unsigned            cycle_cnt_q;

    // testbench result
    logic                   tests_passed;
    logic                   tests_failed;
    logic                   exit_valid;
    logic [31:0]            exit_value;
	
	logic					go_nogo_i;
	logic					test_mode;

    // signals for ri5cy
    logic                   fetch_enable;

    // make the core start fetching instruction immediately
    assign fetch_enable = '1;

    // allow vcd dump
    initial begin
        if ($test$plusargs("vcd")) begin
            $dumpfile("riscv_tb_top_dumpports.vcd");
            $dumpvars(0, tb_top);
        end
    end

    // we either load the provided firmware or execute a small test program that
    // doesn't do more than an infinite loop with some I/O
    initial begin: load_prog	
        automatic string firmware;
        automatic int prog_size = 6;
		wait (go_nogo_i == 1); //test finished
		#CLK_PERIOD;
		#CLK_PHASE_HI;
		if(go_nogo_i==1) begin
			#CLK_PERIOD;
			if($value$plusargs("firmware=%s", firmware)) begin
				if($test$plusargs("verbose"))
					$display("[TESTBENCH] %t: loading firmware %0s ...",
							$time, firmware);
				$readmemh(firmware, riscv_wrapper_i.ram_i.dp_ram_i.mem);

			end else begin
				$display("No firmware specified");
				$finish;
			end
		end
    end

    // clock generation
    initial begin: clock_gen		
        forever begin
            #CLK_PHASE_HI clk = 1'b0;
            #CLK_PHASE_LO clk = 1'b1;
        end
    end: clock_gen

    // reset generation
    initial begin: reset_gen
        rst          = 0'b0;
		#CLK_PERIOD rst = 1'b0;
		#CLK_PERIOD rst = 0'b0;
		wait (go_nogo_i == 1); //test finished
		#CLK_PERIOD;
		#CLK_PERIOD;
		#CLK_PHASE_HI;

        // wait a few cycles
        repeat (RESET_WAIT_CYCLES) begin
            @(posedge clk); //TODO: was posedge, see below
        end

        // start running
        #RESET_DEL rst = 0'b1;
        if($test$plusargs("verbose"))
            $display("reset deasserted", $time);

    end: reset_gen
	
	// test generation
    initial begin: test_gen
        test_mode    = 0'b0;
		#CLK_PERIOD test_mode = 1'b0;		
		wait (go_nogo_i == 1); //test finished
		#CLK_PERIOD;
		#CLK_PERIOD;
		#CLK_PHASE_HI test_mode    = 0'b0;
    end: test_gen

    // set timing format
    initial begin: timing_format
        $timeformat(-9, 0, "ns", 9);
    end: timing_format

    // check if we succeded
    always_ff @(posedge clk, posedge rst) begin
        if (tests_passed) begin
            $display("ALL TESTS PASSED");
            $finish;
        end
        if (tests_failed) begin
            $display("TEST(S) FAILED!");
            $finish;
        end
        if (exit_valid) begin
            if (exit_value == 0)
                $display("EXIT SUCCESS");
            else
                $display("EXIT FAILURE: %d", exit_value);
            $finish;
        end
    end

    //PoliTo: Memory map check
    always_ff @(posedge clk, posedge rst) begin
	//if (tb_top.riscv_wrapper_i.riscv_core_bist_i.riscvi.load_store_unit_i.data_we_ex_i == 1'h1) begin
	if (tb_top.riscv_wrapper_i.data_req == 1'h1 && tb_top.riscv_wrapper_i.data_we == 1'h1) begin
	  if (tb_top.riscv_wrapper_i.riscv_core_bist_i.riscvi.load_store_unit_i.data_addr_o < 32'h200000 || tb_top.riscv_wrapper_i.riscv_core_bist_i.riscvi.load_store_unit_i.data_addr_o > 32'h240000) begin
		  $display("MEMORY MAP WARNING: Writing OUTSIDE DRAM at address %h, time %t", tb_top.riscv_wrapper_i.riscv_core_bist_i.riscvi.load_store_unit_i.data_addr_o, $realtime); 
	  end 
	end
    end	
	
	//lfsri : LFSR --to generate random input values for the core
		//port map (
			//CLK => clk,
			//RESET => rst,
			//EN => '1',
			//LD => '0',
			//DIN => lfsr_seed,
			//PRN => lfsr_out,
			//ZERO_D => open			
		//);

	//boot_addr_i <= lfsr_out(31 downto 0);
	//core_id_i<= lfsr_out(3 downto 0);
	//cluster_id_i <= lfsr_out(5 downto 0);
	//instr_rdata_i <= lfsr_out(63 downto 0)&lfsr_out(63 downto 0);
	//data_rdata_i <= lfsr_out(31 downto 0);
	//apu_master_result_i <= lfsr_out(31 downto 0);
	//apu_master_flags_i <= lfsr_out(4 downto 0);
	//irq_id_i <= lfsr_out(4 downto 0);
	//ext_perf_counters_i <= lfsr_out(2 downto 1);
 	//clock_en_i <= '1';
 	//fregfile_disable_i <= lfsr_out(0);
 	//instr_gnt_i <= lfsr_out(1);
	//instr_rvalid_i <= lfsr_out(2);
 	//data_gnt_i <= lfsr_out(3);
 	//data_rvalid_i <= lfsr_out(4);
 	//apu_master_gnt_i <= lfsr_out(5);
	//apu_master_valid_i <= lfsr_out(6);
 	//irq_i <= lfsr_out(7);
 	//irq_sec_i <= lfsr_out(8);
 	//debug_req_i <= lfsr_out(9);
 	//fetch_enable_i <= lfsr_out(10);	
	

    // wrapper for riscv, the memory system and stdout peripheral
    riscv_wrapper
        #(.INSTR_RDATA_WIDTH (INSTR_RDATA_WIDTH),
          .RAM_ADDR_WIDTH (RAM_ADDR_WIDTH),
          .BOOT_ADDR (BOOT_ADDR),
          .PULP_SECURE (1))

    riscv_wrapper_i
        (.clk   	     ( clk          ),
         .rst	         ( rst          ),
         .fetch_enable_i ( fetch_enable ),
         .tests_passed_o ( tests_passed ),
         .tests_failed_o ( tests_failed ),
         .exit_valid_o   ( exit_valid   ),
         .exit_value_o   ( exit_value   ),
		 .test_mode      ( test_mode    ),
		 .go_nogo   	 ( go_nogo_i   ));

`ifndef VERILATOR
    initial begin
        assert (INSTR_RDATA_WIDTH == 128 || INSTR_RDATA_WIDTH == 32)
            else $fatal("invalid INSTR_RDATA_WIDTH, choose 32 or 128");
    end
`endif

endmodule // tb_top
