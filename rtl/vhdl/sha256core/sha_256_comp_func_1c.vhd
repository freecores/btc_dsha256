-- Copyright (c) 2013 VariStream
-- Author : Yu Peng
-- Notes : Introduce delay of 1 clock cycle

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.sha_256_pkg.ALL;

entity sha_256_comp_func_1c is
	port(
		iClk : in std_logic;
		iRst_async : in std_logic;
		
		ivA : in std_logic_vector(31 downto 0);
		ivB : in std_logic_vector(31 downto 0);
		ivC : in std_logic_vector(31 downto 0);
		ivD : in std_logic_vector(31 downto 0);
		ivE : in std_logic_vector(31 downto 0);
		ivF : in std_logic_vector(31 downto 0);
		ivG : in std_logic_vector(31 downto 0);
		ivH : in std_logic_vector(31 downto 0);
				 
		ivK : in std_logic_vector(31 downto 0);
		ivW : in std_logic_vector(31 downto 0);
				 
		ovA : out std_logic_vector(31 downto 0);
		ovB : out std_logic_vector(31 downto 0);
		ovC : out std_logic_vector(31 downto 0);
		ovD : out std_logic_vector(31 downto 0);
		ovE : out std_logic_vector(31 downto 0);
		ovF : out std_logic_vector(31 downto 0);
		ovG : out std_logic_vector(31 downto 0);
		ovH : out std_logic_vector(31 downto 0)
	);
end sha_256_comp_func_1c;

architecture behavioral of sha_256_comp_func_1c is

	component pipelines_without_reset IS
		GENERIC (gBUS_WIDTH : integer := 3; gNB_PIPELINES: integer range 1 to 255 := 2);
		PORT(
			iClk				: IN		STD_LOGIC;
			iInput				: IN		STD_LOGIC;
			ivInput				: IN		STD_LOGIC_VECTOR(gBUS_WIDTH-1 downto 0);
			oDelayed_output		: OUT		STD_LOGIC;
			ovDelayed_output	: OUT		STD_LOGIC_VECTOR(gBUS_WIDTH-1 downto 0)
		);
	end component;
	
	signal svAOut : std_logic_vector(31 downto 0); 
	signal svEOut : std_logic_vector(31 downto 0);

begin
	process(iClk)
	begin
		if rising_edge(iClk) then
			svAOut <= ivH + sum_1(ivE) + chi(ivE, ivF, ivG) + ivK + ivW + sum_0(ivA) + maj(ivA, ivB, ivC);
			svEOut <= ivH + sum_1(ivE) + chi(ivE, ivF, ivG) + ivK + ivW + ivD;
		end if;
	end process;
	
	ovA <= svAOut;
	ovE <= svEOut;
	
	process(iClk)
	begin
		if rising_edge(iClk) then	
			ovB <= ivA;
			ovC <= ivB;
			ovD <= ivC;
			ovF <= ivE;
			ovG <= ivF;
			ovH <= ivG;
		end if;
	end process;
		
end behavioral;
