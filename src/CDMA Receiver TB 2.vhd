library IEEE;
use ieee.std_logic_1164.all;

entity TestBench_CDMA_Receiver2 is
end TestBench_CDMA_Receiver2;

architecture behavior of TestBench_CDMA_Receiver2 is 

	-- Constants
	constant resetTime : time := 5 ns;
	constant clockPeriod: time := 10 ns;
	-- Spreading Factor, that is SymbolPeriod/ChipPeriod, following requirements this is equal to 16
	constant SF : positive := 16;
	constant K : positive := 2;

	-- type of array to store codeWord, chipStream and interference pattern
	type integerVector is array ( 0 to SF-1 ) of integer range -K to K;

	component CDMA_Receiver 
		generic ( K : positive := 2;
			  SF : positive := 16 );
		port(
			clk_R : in std_ulogic;
			reset_R : in std_ulogic;
			code_word : in integer range -1 to 1 ;
			chip_stream : in integer range -K to K;
			bitstream_R : out std_ulogic
		);
	end component;

	-- Inputs
	signal clk_tb :std_logic := '0'; -- Clock
	signal reset_tb: std_logic := '0'; -- Reset
	signal code_word_tb: integer range -1 to 1 := 0;
	signal chip_stream_tb: integer range -K to K := 0; 

	-- Outputs
	signal bitstream_tb : std_ulogic; -- Received Bit 
	
	-- Others
	signal stopSimulation : std_logic := '1';
	begin	
		-- Clock variation
		clk_tb <= (not(clk_tb) and stopSimulation) after clockPeriod/2;
		
		--Reset
		reset_tb <= '1' after resetTime;
		
		-- CDMA Instantiation
		test_CDMA_Receiver2: CDMA_Receiver 
			generic map ( K => K, SF => SF )
			port map ( clk_tb, reset_tb, code_word_tb, chip_stream_tb, bitstream_tb );
		
		-- Stimulus Process
		stim_proc: process
			-- Code Word of User 2
			constant code_word_2 : integerVector := (1,-1,1,-1,1,-1,-1,-1,1,1,-1,-1,-1,1,-1,-1);
			-- Received Signal, simulating 2 signal interfering each other
			constant interference_pattern: integerVector := (0,2,-2,2,-2,0,0,2,0,-2,0,0,2,0,0,2);
		begin
			wait until reset_tb = '1';
			-- every clock period update inputs
			for i in interference_pattern' range loop
				code_word_tb <= code_word_2(i);
				chip_stream_tb <= interference_pattern(i);
				wait for clockPeriod;				
			end loop;
			-- after ending inputs, simulation can be stopped
			stopSimulation <= '0';
		end process stim_proc;
	end behavior;

		
		
