-- Copyright (c) 2013 VariStream
-- Author : Yu Peng 

LIBRARY ieee;
USE	ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY pipelines_without_reset IS
	GENERIC (gBUS_WIDTH : integer := 1; gNB_PIPELINES: integer range 1 to 255 := 2);
	PORT(
		iClk				: IN		STD_LOGIC;
		iInput				: IN		STD_LOGIC;
		ivInput				: IN		STD_LOGIC_VECTOR(gBUS_WIDTH-1 downto 0);
		oDelayed_output		: OUT		STD_LOGIC;
		ovDelayed_output	: OUT		STD_LOGIC_VECTOR(gBUS_WIDTH-1 downto 0)
	);
END pipelines_without_reset;

ARCHITECTURE behavioral OF pipelines_without_reset IS
	
	type tPipeline_stages is array(gNB_PIPELINES downto 1) of std_logic_vector(gBUS_WIDTH-1 downto 0);
	signal svPipeline_stages	: tPipeline_stages;
	
	type single_bit_pipe_stage is array(gNB_PIPELINES downto 1) of std_logic;
	signal sPipeline_stages	: single_bit_pipe_stage;

BEGIN
	ovDelayed_output <= svPipeline_stages(gNB_PIPELINES);
	oDelayed_output <= sPipeline_stages(gNB_PIPELINES);
	
	more_than_one_pipe:
	if (gNB_PIPELINES > 1) generate
		pipelinesGen:
		for i in 2 TO gNB_PIPELINES generate
			process(iClk)
			begin
				if rising_edge(iClk) then
					svPipeline_stages(i) <= svPipeline_stages(i-1);
					sPipeline_stages(i) <= sPipeline_stages(i-1);
				end if;
			end process;
		end generate;
	end generate more_than_one_pipe;	
	
	process(iClk)
	begin
		if rising_edge(iClk) then
			svPipeline_stages(1) <= ivInput;
			sPipeline_stages(1) <= iInput;
		end if;
	end process;
	

END behavioral;

