-- Copyright (c) 2013 VariStream
-- Author : Yu Peng 
-- Notes: Generates a "synchronous" reset from the async global reset

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity SyncReset is
	port(
		iClk				: in std_logic;						-- Clock domain that the reset should be resynchronyze to
		iAsyncReset      	: in std_logic;						-- Asynchronous reset that should be resynchronyse
		oSyncReset       	: out std_logic						-- Synchronous reset output
	);
end SyncReset;

architecture SyncReset of SyncReset is  

	signal sResetStage1				: std_logic;
	
begin

	process(iClk, iAsyncReset)
	begin
		if iAsyncReset = '1' then
			sResetStage1		<= '1';
			oSyncReset			<= '1';
		elsif rising_edge(iClk) then
			sResetStage1		<= '0';
			oSyncReset			<= sResetStage1;
		end if;
	end process;

end SyncReset;


  