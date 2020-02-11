library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity DecisoreHardASoglia is 
	generic ( SF : positive := 16 );
	port(
		clk_DHS : in std_ulogic;
		reset_DHS : in std_ulogic;
		data_DHS : in integer range -SF to SF;
		bitstream_DHS : out std_ulogic
	);
end DecisoreHardASoglia;


architecture behavior of DecisoreHardASoglia is
	signal waitData : integer range -SF to SF  := 0;
	signal sum : integer range -SF to SF := 0;
	begin 
		proc : process(clk_DHS)
		begin 
			if ( rising_edge(clk_DHS)) then
				if (reset_DHS = '0' ) then
					bitstream_DHS <= 'U';
				else
					if ( waitData < 16 ) then
						sum <= sum + data_DHS;
						waitData <= waitData + 1;
					else 
						-- calcola il bit
						if ( sum >= 0 ) then
							bitstream_DHS <= '1';
						else
							bitstream_DHS <= '0';
						end if;
						waitData <= 0;	
						sum <= 0;					
					end if;
				end if;
			end if;
		end process proc;
	end behavior;
				