library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity controller_top is
    generic (
        SCAN_SIZE			: integer:=8; --max length of the scan chains (8 if 12x480 config)
		W_SIZE_LD_UNLD		: integer:=12;--size of the LOAD/UNLOAD memory's word
		W_ADDR_SIZE_LD_UNLD	: integer:=6; --size of the LOAD/UNLOAD memory's address
		M_SIZE_LD_UNLD		: integer:=40; --number of patterns in the LOAD/UNLOAD memory 
		W_SIZE_CAP			: integer:=262;--size of the CAPTURE memory's word
		W_ADDR_SIZE_CAP		: integer:=3; --size of the CAPTURE memory's address
		M_SIZE_CAP			: integer:=5; --number of patterns in the CAPTURE memory
		CORE_FREQ			: integer:=100000000; --core's operating frequency (default: 100 MHz)
		STUCK_AT_FREQ		: integer:=10000000 --stuck at fault test frequency (default: 10 MHz)
    );
    port (
        CORE_CLK			: in std_logic; --core's clock (normal mode clock)
		TEST_START			: in std_logic; --test mode signal (1 means that the core is used in test mode, so is the bist controller that controls the core)
		CORE_RST			: in std_logic;
		GO_NOGO				: out std_logic; --result of the tests	
		TEST_PATTERNS		: out std_logic_vector(W_SIZE_CAP-1 downto 0) --core's inputs driven by bist;
    );
end entity controller_top;

architecture struct of controller_top is


	--###################################################################
	--################## CLOCK DIVISOR ##################################
	--###################################################################

	-- drives all the bist logic 

	component clk_divisor is
	generic (
		N			   : integer:=8; --size of the counter
		SCALING_FACTOR : integer:=10 --generated clock frequency = original_freq/scaling_factor
	);
	port (
		clk : in std_logic; --faster clock
		rst : in std_logic; --reset the counter to 0
		q : out std_logic   --genearated clock (slower)
	);
	end component;

	signal core_clk_g: std_logic;
	signal test_clk_g: std_logic;
	signal test_rst_g: std_logic;

	
	--###################################################################
	--########### LOAD/UNLOAD and CAPTURE PATTERNS ROM ##################
	--###################################################################
    
	--patterns used to load the scan chains during load_unload phase (.spf standard nomenclature)
	--patterns used to load the core's input during capture phase (.spf standard nomenclature)

	component ROM is
	generic (
		W_SIZE			: integer:=12;
		W_ADDR_SIZE		: integer:=4;
		M_SIZE			: integer:=50;
		PATT_PATH		: string:=PATT_PATH_LOAD
	);
	port (
		ADDR: in std_logic_vector(W_ADDR_SIZE-1 downto 0);
		ENABLE: in std_logic;
		RST: in std_logic;
		DOUT:	out std_logic_vector(W_SIZE-1 downto 0)
	);
	end component;

	signal A1: std_logic_vector(W_ADDR_SIZE_LD_UNLD-1 downto 0);
	signal A2: std_logic_vector(W_ADDR_SIZE_CAP-1 downto 0);
	signal dout_1: std_logic_vector(W_SIZE_LD_UNLD-1 downto 0);
	signal dout_2: std_logic_vector(W_SIZE_CAP-1 downto 0);

	--###################################################################
	--########### LOAD/UNLOAD and CAPTURE PATTERNS SWITCH ###############
	--###################################################################
	
	component mux is
	generic (
		N	: integer
	);
	port (
		A : in std_logic_vector (N-1 downto 0);
		B : in std_logic_vector (N-1 downto 0);
		S : in std_logic;
		Y : out std_logic_vector (N-1 downto 0)
	);
	end component;

	signal patterns1_extended: std_logic_vector(W_SIZE_CAP-1 downto 0);
	signal patterns2_extended: std_logic_vector(W_SIZE_CAP-1 downto 0);
	signal patterns_extended: std_logic_vector(W_SIZE_CAP-1 downto 0);
	signal load_capture: std_logic;

	--###################################################################
	--#################### BIST CONTROLLER ##############################
	--###################################################################

	component controller is
    generic (
        TEST_CYCLES		: integer:=45;
		A1_SIZE			: integer:=6;
		A2_SIZE			: integer:=3;
		MAX_SCAN_SIZE	: integer:=8
    );
    port (
        CLOCK			: in std_logic;				
		RESET			: in std_logic;
		TEST_START		: in std_logic;
		RESULT			: out std_logic; --tests result (0==faulty)
		LOAD_CAPTURE	: out std_logic; --signal used to drive multiplexers that switches between LOAD/UNLOAD pattterns and CAPTURE patterns 
		A1				: out std_logic_vector(A1_SIZE -1 downto 0); --address for the LOAD/UNLOAD memory
		A2				: out std_logic_vector(A2_SIZE -1 downto 0) --address for the LOAD/UNLOAD memory
    );
	end component;

	signal go_nogo_i: std_logic;
	
	
begin

	--activate clock only if in test-mode
	--so if TEST_START=0 (core is in normal mode) the entire bist is deactivated (no clock, no reset)
	core_clk_g<=CORE_CLK and TEST_START;
	test_rst_g<='0' when ( ((not CORE_RST) and TEST_START) = '1' ) else '1';
    
	clock_divisor_uut: clk_divisor
	generic map(
		N=>4,
		SCALING_FACTOR=>CORE_FREQ/STUCK_AT_FREQ
	)
	port map (
		clk=>core_clk_g,
		rst=>test_rst_g,
		q=>test_clk_g
	);

	--LOAD/UNLOAD MEMORY CONFIGURATION:
	--# W_SIZE:=12 (12 scan chains) ===>>>>>>> W_SIZE_LD_UNLD
	--#	W_ADDR_SIZE:= 6 (40 patterns needs at least 6 bits for addressing)====>>>>> W_ADDR_SIZE_LD_UNLD
	--# M_SIZE:= 40 (40 is the number of patterns saved) ======>>>> M_SIZE_LD_UNLD
	
    load_unload_pat: ROM
	generic map (
		W_SIZE=>12,
		W_ADDR_SIZE=>6,
		M_SIZE=>40,
		PATT_PATH=>PATT_PATH_LOAD
	)
	port map (
		ADDR=>A1,
		ENABLE=>TEST_START,
		RST=>test_rst_g,
		DOUT=>dout_1
	);


	--CAPTURE MEMORY CONFIGURATION:
	--# W_SIZE:=262 W_SIZE_LD_UNLD
	--#	W_ADDR_SIZE:= 3 (5 patterns needs at least 3 bits for addressing)====>>>>> W_ADDR_SIZE_CAP 
	--# M_SIZE:= 5 ======>>>> M_SIZE_LD_UNLD/SCAN_SIZE
	
    capture_pat: ROM
	generic map (
		W_SIZE=>W_SIZE_CAP,
		W_ADDR_SIZE=>3,
		M_SIZE=>M_SIZE_LD_UNLD/SCAN_SIZE,
		PATT_PATH=>PATT_PATH_CAP
	)
	port map (
		ADDR=>A2,
		ENABLE=>TEST_START,
		RST=>test_rst_g,
		DOUT=>dout_2
	);
	
	--extension on 262 bits for load/unload patterns
	patterns1_extended(261)<='1';
	patterns1_extended(260)<='1';
	patterns1_extended(259)<=test_rst_g;
	patterns1_extended(258 downto 154)<=(others=>'0');
	patterns1_extended(153 downto 146)<=dout_1(11 downto 4);
	patterns1_extended(145)<='0';
	patterns1_extended(144 downto 141)<=dout_1(3 downto 0);
	patterns1_extended(140 downto 73)<=(others=>'0');
	patterns1_extended(72)<='1';
	patterns1_extended(71)<=test_clk_g;
	patterns1_extended(70 downto 0)<=(others=>'0');
	--extension on 262 bits for capture patterns
	patterns2_extended(261 downto 260)<=dout_2(261 downto 260);
	patterns2_extended(259)<=test_rst_g;
	patterns2_extended(258 downto 72)<=dout_2(258 downto 72);
	patterns2_extended(71)<=test_clk_g;
	patterns2_extended(70 downto 0)<=dout_2(70 downto 0);

	--selector between patterns1, patterns2
	selector: mux
	generic map(
		N=>W_SIZE_CAP
	)
	port map (
		A=>patterns1_extended,
		B=>patterns2_extended,
		S=>load_capture,
		Y=>patterns_extended
	);

	TEST_PATTERNS<=patterns_extended;

	--controller

	ctrl: controller
    generic map (
        TEST_CYCLES=> (M_SIZE_LD_UNLD + M_SIZE_LD_UNLD/SCAN_SIZE),
		A1_SIZE=>W_ADDR_SIZE_LD_UNLD,
		A2_SIZE=>W_ADDR_SIZE_CAP,
		MAX_SCAN_SIZE=>SCAN_SIZE
    )
    port map(
        CLOCK=>test_clk_g,			
		RESET=>test_rst_g,
		TEST_START=>TEST_START,
		RESULT=>go_nogo_i,
		LOAD_CAPTURE=>load_capture,
		A1=>A1,
		A2=>A2
    );

	GO_NOGO<=go_nogo_i;
	
    
end architecture struct;










