----------------------------------------------------------------------------------------------------------------------
-- Copyright (c) 2013 VariStream
-- Author : Yu Peng 
-- Description:
--   Edge detector
--   If iEdge = 1 > rising edge detect
--   If iEdge = 0 > falling edge detect
----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity edgedtc is port
	(
		iD				: in		std_logic; 		
		iClk			: in		std_logic;
		iResetSync_Clk	: in		std_logic;
		iEdge			: in		std_logic;
		oQ				: out		std_logic := '0'
	);
end edgedtc;

architecture edgedtc of edgedtc is 

	
	signal sFf	: std_logic_vector(1 downto 0) := "00";

begin

	edgedtc:process(iClk)
		begin
		if rising_edge(iCLk) then 
			if iResetSync_Clk = '1' THEN
				oQ <= '0';
				sFf <= iEdge & iEdge;--"00";
			else
				sFf(0) <= iD;
				sFf(1) <= sFf(0);
				
				oQ <= (not iEdge xor sFf(0)) and (iEdge xor sFf(1));
			end if;
		end if;
			
	end process;



end edgedtc;

