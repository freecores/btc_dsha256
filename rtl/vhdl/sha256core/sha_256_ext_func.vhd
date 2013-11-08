-- Copyright (c) 2013 VariStream
-- Author : Yu Peng
-- Notes : Introduce delay of 3 clock cycle

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.sha_256_pkg.ALL;

entity sha_256_ext_func is
	port(
		iClk : in std_logic;
		iRst_async : in std_logic;

		ivWIM2 : in std_logic_vector(31 downto 0);
		ivWIM7 : in std_logic_vector(31 downto 0);	
		ivWIM15 : in std_logic_vector(31 downto 0);
		ivWIM16 : in std_logic_vector(31 downto 0);
				 
		ovWO : out std_logic_vector(31 downto 0)
	);
end sha_256_ext_func;

architecture behavioral of sha_256_ext_func is

	signal svS0, svS1 : std_logic_vector(31 downto 0);
	signal svTemp_1d, svTemp_2d : std_logic_vector(31 downto 0); 
	signal svS_1d : std_logic_vector(31 downto 0);

begin

	proc_delay1: process(iClk)
	begin
		if rising_edge(iClk) then
			svS0 <= sigma_0(ivWIM15);
			svS1 <= sigma_1(ivWIM2);
			svTemp_1d <= ivWIM16 + ivWIM7;
		end if;
	end process;

	proc_delay2: process(iClk)
	begin
		if rising_edge(iClk) then
			svS_1d <= svS1 + svS0;
			svTemp_2d <= svTemp_1d;
		end if;
	end process;
	
	proc_delay3: process(iClk)
	begin
		if rising_edge(iClk) then
			ovWO <= svTemp_2d + svS_1d;
		end if;
	end process;
		
end behavioral;

