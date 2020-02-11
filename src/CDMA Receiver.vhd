library IEEE;
use ieee.std_logic_1164.all;
 
entity CDMA_Receiver is
	-- K active users
	generic ( K : positive := 2;
		  SF : positive := 16 );
	port(
		clk_R : in std_ulogic;
		reset_R : in std_ulogic;
		code_word : in integer range -1 to 1 ;
		chip_stream : in integer range -K to K;
		bitstream_R : out std_ulogic
	);
end CDMA_Receiver;

architecture data_flow of CDMA_Receiver is
	-- Add component
	component DecisoreHardASoglia is
		generic ( K: positive := 2;
			  SF : positive := 16 );
		port(
			clk_DHS : in std_ulogic;
			reset_DHS : in std_ulogic;
			data_DHS : in integer range -K to K;
			bitstream_DHS : out std_ulogic
		);
	end component;
	-- signal used as input for the DesisoreHardASoglia
	signal data_s : integer range -K to K;

	begin
		DHS: DecisoreHardASoglia
		-- Mapping
		generic map ( K => K, SF => SF ) 
		port map (
			clk_DHS => clk_R,
			reset_DHS => reset_R,
			data_DHS => data_s,
			bitstream_DHS => bitstream_R
		);
		
		-- Multiply the received signal ( chip_stream ) with own code word
		data_s <= code_word * chip_stream;
end data_flow;

