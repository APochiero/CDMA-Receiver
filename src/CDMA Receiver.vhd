library IEEE;
use ieee.std_logic_1164.all;

entity CDMA_Receiver is 
	port(
		clk_R : in std_ulogic;
		reset_R : in std_ulogic;
		code_word : in integer;
		chip_stream : in integer;
		bitstream_R : out std_ulogic
	);
end CDMA_Receiver;

architecture data_flow of CDMA_Receiver is
	component DecisoreHardASoglia is
		port(
			clk_DHS : in std_ulogic;
			reset_DHS : in std_ulogic;
			data_DHS : in integer;
			bitstream_DHS : out std_ulogic
		);
	end component;
	
	signal data_s : integer;

	begin
		DHS: DecisoreHardASoglia 
		port map (
			clk_DHS => clk_R,
			reset_DHS => clk_R,
			data_DHS => data_s,
			bitstream_DHS => bitstream_R
		);

		data_s <= code_word * chip_stream;
end data_flow;
