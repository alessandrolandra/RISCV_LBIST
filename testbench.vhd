
library std;
use std.env.all;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity riscv_testbench is
end riscv_testbench;


architecture tb of riscv_testbench is
    module riscv_core
		#(
		  parameter N_EXT_PERF_COUNTERS =  0,
		  parameter INSTR_RDATA_WIDTH   = 32,
		  parameter PULP_SECURE         =  0,
		  parameter N_PMP_ENTRIES       = 16,
		  parameter USE_PMP             =  1, //if PULP_SECURE is 1, you can still not use the PMP
		  parameter PULP_CLUSTER        =  1,
		  parameter FPU                 =  0,
		  parameter Zfinx               =  0,
		  parameter FP_DIVSQRT          =  0,
		  parameter SHARED_FP           =  0,
		  parameter SHARED_DSP_MULT     =  0,
		  parameter SHARED_INT_MULT     =  0,
		  parameter SHARED_INT_DIV      =  0,
		  parameter SHARED_FP_DIVSQRT   =  0,
		  parameter WAPUTYPE            =  0,
		  parameter APU_NARGS_CPU       =  3,
		  parameter APU_WOP_CPU         =  6,
		  parameter APU_NDSFLAGS_CPU    = 15,
		  parameter APU_NUSFLAGS_CPU    =  5,
		  parameter DM_HaltAddress      = 32'h1A110800
		)
		(
		  // Clock and Reset
		  input  logic        clk_i,
		  input  logic        rst_ni,

		  input  logic        clock_en_i,    // enable clock, otherwise it is gated
		  input  logic        test_en_i,     // enable all clock gates for testing

		  input  logic        fregfile_disable_i,  // disable the fp regfile, using int regfile instead

		  // Core ID, Cluster ID and boot address are considered more or less static
		  input  logic [31:0] boot_addr_i,
		  input  logic [ 3:0] core_id_i,
		  input  logic [ 5:0] cluster_id_i,

		  // Instruction memory interface
		  output logic                         instr_req_o,
		  input  logic                         instr_gnt_i,
		  input  logic                         instr_rvalid_i,
		  output logic                  [31:0] instr_addr_o,
		  input  logic [INSTR_RDATA_WIDTH-1:0] instr_rdata_i,

		  // Data memory interface
		  output logic        data_req_o,
		  input  logic        data_gnt_i,
		  input  logic        data_rvalid_i,
		  output logic        data_we_o,
		  output logic [3:0]  data_be_o,
		  output logic [31:0] data_addr_o,
		  output logic [31:0] data_wdata_o,
		  input  logic [31:0] data_rdata_i,

		  // apu-interconnect
		  // handshake signals
		  output logic                           apu_master_req_o,
		  output logic                           apu_master_ready_o,
		  input logic                            apu_master_gnt_i,
		  // request channel
		  output logic [APU_NARGS_CPU-1:0][31:0] apu_master_operands_o,
		  output logic [APU_WOP_CPU-1:0]         apu_master_op_o,
		  output logic [WAPUTYPE-1:0]            apu_master_type_o,
		  output logic [APU_NDSFLAGS_CPU-1:0]    apu_master_flags_o,
		  // response channel
		  input logic                            apu_master_valid_i,
		  input logic [31:0]                     apu_master_result_i,
		  input logic [APU_NUSFLAGS_CPU-1:0]     apu_master_flags_i,

		  // Interrupt inputs
		  input  logic        irq_i,                 // level sensitive IR lines
		  input  logic [4:0]  irq_id_i,
		  output logic        irq_ack_o,
		  output logic [4:0]  irq_id_o,
		  input  logic        irq_sec_i,

		  output logic        sec_lvl_o,

		  // Debug Interface
		  input  logic        debug_req_i,


		  // CPU Control Signals
		  input  logic        fetch_enable_i,
		  output logic        core_busy_o,

		  input  logic [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i
    );

    component lfsr
        generic (N    : integer;
                 SEED : std_logic_vector(N downto 0));
        port (clk   : in std_logic;
              reset : in std_logic;
              q     : out std_logic_vector(N downto 0));
    end component;

	constant clock_t1      : time := 50 ns;
	constant clock_t2      : time := 30 ns;
	constant clock_t3      : time := 20 ns;
	constant apply_offset  : time := 0 ns;
	constant apply_period  : time := 100 ns;
	constant strobe_offset : time := 40 ns;
	constant strobe_period : time := 100 ns;


	signal tester_clock : std_logic := '0';

    signal lfsr_out   : std_logic_vector(16 downto 0);
    signal lfsr_clock : std_logic := '0';
    signal lfsr_reset : std_logic;
    signal dut_clock  : std_logic := '0';
    signal dut_reset  : std_logic;

    -- DUT outputs
    signal cc_mux       : std_logic_vector(2 downto 1);
    signal uscite       : std_logic_vector(2 downto 1);
    signal enable_count : std_logic;
    signal ackout       : std_logic;

begin

    stimuli : lfsr
    generic map (N => 16,
                 SEED => "10101010101010101")
    port map (clk => lfsr_clock,
              reset => lfsr_reset,
              q => lfsr_out);

    dut : b06
    port map (clock    => dut_clock,
              reset    => dut_reset,
              test_si  => '0',
              test_se  => '0',
              eql      => lfsr_out(1),
              cont_eql => lfsr_out(0),
              cc_mux   => cc_mux,
              uscite   => uscite,
              enable_count => enable_count,
              ackout   => ackout);
-- ***** CLOCK/RESET ***********************************

	clock_generation : process
	begin
		loop
			wait for clock_t1; tester_clock <= '1';
			wait for clock_t2; tester_clock <= '0';
			wait for clock_t3;
		end loop;
	end process;

-- dut  ___/----\____ ___/----\____ ___/----\____ ___
-- lfsr /----\____ ___/----\____ ___/----\____ ___/--

    dut_clock <= transport tester_clock after apply_period;
    lfsr_clock <= transport tester_clock after apply_period - clock_t1 + apply_offset;

    dut_reset <= '0', '1' after clock_t1, '0' after clock_t1 + clock_t2;
    lfsr_reset <= '1', '0' after clock_t1 + clock_t2;



-- ***** MONITOR **********

    monitor : process(cc_mux, uscite, enable_count, ackout)
		function vec2str( input : std_logic_vector ) return string is
			variable rline : line;
		begin
			write( rline, input );
			return rline.all;
		end vec2str;
    begin
        std.textio.write(std.textio.output, "cc_mux:" & vec2str(cc_mux) & " uscite:" & vec2str(uscite) & " enable_count:" & std_logic'image(enable_count) & " ackout:" & std_logic'image(ackout) & LF);
    end process;

end tb;

configuration cfg_riscv_testbench of riscv_testbench is
    for tb
    end for;
end cfg_riscv_testbench;
