library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- This component has to take a decision on the output bit
entity DecisoreHardASoglia is 
	generic ( K: positive := 2;			  
		  SF : positive := 16 );
	port(
		clk_DHS : in std_ulogic;
		reset_DHS : in std_ulogic;
		data_DHS : in integer range -K to K;
		bitstream_DHS : out std_ulogic
	);
end DecisoreHardASoglia;

architecture behavior of DecisoreHardASoglia is
	-- Count how many data have been received
	signal waitData : integer range 0 to SF := 0;
	-- Sum data at every clock cycle
	signal sum : integer range -SF to SF := 0;
	begin 
		proc : process(clk_DHS)
		begin 
			if ( rising_edge(clk_DHS)) then
				-- synchronous reset
				if (reset_DHS = '0' ) then
					bitstream_DHS <= 'U';
				else
					-- Update sum and waitData 
					if ( waitData < 16 ) then
						sum <= sum + data_DHS;
						waitData <= waitData + 1;
					else 
						-- otherwise make a decision on the bit
						if ( sum >= 0 ) then
							bitstream_DHS <= '1';
						else
							bitstream_DHS <= '0';
						end if;
						-- reset signals
						waitData <= 0;	
						sum <= 0;					
					end if;
				end if;
			end if;
		end process proc;
	end behavior;				