-- Copyright (c) 2013 VariStream
-- Author : Yu Peng
-- Notes : Introduce delay of 1 clock cycle

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.sha_256_pkg.ALL;

entity sha_256_ext_func_1c is
	port(
		iClk : in std_logic;
		iRst_async : in std_logic;

		ivWIM2 : in std_logic_vector(31 downto 0);
		ivWIM7 : in std_logic_vector(31 downto 0);	
		ivWIM15 : in std_logic_vector(31 downto 0);
		ivWIM16 : in std_logic_vector(31 downto 0);
				 
		ovWO : out std_logic_vector(31 downto 0)
	);
end sha_256_ext_func_1c;

architecture behavioral of sha_256_ext_func_1c is

begin
	
	process(iClk)
	begin
		if rising_edge(iClk) then
			ovWO <= ivWIM16 + sigma_0(ivWIM15) + ivWIM7 + sigma_1(ivWIM2);
		end if;
	end process;
		
end behavioral;
