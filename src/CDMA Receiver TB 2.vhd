library IEEE;
use ieee.std_logic_1164.all;

entity TestBench_CDMA_Receiver2 is
end TestBench_CDMA_Receiver2;

architecture behavior of TestBench_CDMA_Receiver2 is 

	-- Constants
	constant resetTime : time := 10 ns;
	constant clockPeriod: time := 10 ns;
	constant SF : integer := 16;

	type integerVector is array ( 0 to SF-1 ) of integer;

	component CDMA_Receiver 
		port (
			clk_R : in std_ulogic;
			reset_R : in std_ulogic;
			code_word : in integer;
			chip_stream : in integer;	
			bitstream_R : out std_ulogic
		);
	end component;

	signal clk_tb :std_logic := '0'; -- Clock
	signal reset_tb: std_logic := '0'; -- Reset
	signal code_word_tb: integer := 0;
	signal chip_stream_tb: integer := 0; 

	-- Outputs
	signal bitstream_tb : std_ulogic; -- Received Bit 
	
	-- Others
	signal stopSimulation : std_logic := '1';
	signal waitData : integer := 0;
	begin	
	
		-- Clock variation
		clk_tb <= (not(clk_tb) and stopSimulation) after clockPeriod;
		
		--Reset
		reset_tb <= '1' after resetTime;
		
		test_CDMA_Receiver2: CDMA_Receiver 
			port map ( clk_tb, reset_tb, code_word_tb, chip_stream_tb, bitstream_tb );

		stim_proc: process
			constant code_word_2 : integerVector := (1,-1,1,-1,1,-1,-1,-1,1,1,-1,-1,-1,1,-1,-1);
			constant interference_pattern: integerVector := (0,2,-2,2,-2,0,0,2,0,-2,0,0,2,0,0,2);
		begin
			wait until reset_tb = '1';
			for i in interference_pattern' range loop
				code_word_tb <= code_word_2(i);
				chip_stream_tb <= interference_pattern(i);
				wait until rising_edge(clk_tb);				
			end loop;
			stopSimulation <= '0';
		end process stim_proc;
	end behavior;

		
		

		
		
