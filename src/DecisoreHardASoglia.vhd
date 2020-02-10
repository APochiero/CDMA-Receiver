library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity DecisoreHardASoglia is 
	port(
		clk_DHS : in std_ulogic;
		reset_DHS : in std_ulogic;
		data_DHS : in integer;
		bitstream_DHS : out std_ulogic
	);
end DecisoreHardASoglia;


architecture behavioural of DecisoreHardASoglia is
	constant SF : integer := 16;
	type integerVector is array ( 0 to SF-1 ) of integer;

	signal storeSymbols : integerVector;
	signal waitData : integer  := 0;
	signal sum : integer range 0 to SF-1:= 0;
	signal symbol: integer := 0;
	begin 
		proc : process(clk_DHS)
		begin 
			if ( rising_edge(clk_DHS)) then
				if (reset_DHS = '0' ) then
					bitstream_DHS <= '0';
				else 
					storeSymbols(waitData) <= data_DHS;
					
					if ( waitData = 15 ) then
						-- calcola il bit
						for i in storeSymbols' range loop
							sum <= sum + storeSymbols(i);
						end loop;
						symbol <= sum/SF;
						if ( symbol = -1 ) then
							bitstream_DHS <= '0';
						else
							bitstream_DHS <= '1';
						end if;
					else 
						waitData <= waitData + 1;
					end if;
				end if;
			end if;
		end process proc;
	end behavioural;
				