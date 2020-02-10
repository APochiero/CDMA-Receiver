library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity counter is 
	port( 
		clk: in std_logic;
		reset: in std_logic;
		count: out std_logic_vector( 3 downto 0 )
	);
end counter;

architecture behavioural of counter is 
	signal l_count : std_logic_vector( 3 downto 0 );
	begin
		process(clk, reset)
		begin 
			if ( reset = '0' ) then
				l_count <= "0000";
			elsif (clk'event and clk = '1' ) then 
				if ( l_count = "1111" ) then 
					l_count <= "0000";
				else 
					l_count <= l_count + 1;
				end if;
			end if;
			count <= l_count;
		end process;
end behavioural;
