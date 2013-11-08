library hotan;
use hotan.sha_256_pkg.all;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

	-- Add your library and packages declaration here ...

entity btc_dsha_tb is
	-- Generic declarations of the tested unit
		generic(
		gBASE_DELAY : INTEGER := 1 );
end btc_dsha_tb;

architecture TB_ARCHITECTURE of btc_dsha_tb is
	-- Component declaration of the tested unit
	component btc_dsha
		generic(
		gBASE_DELAY : INTEGER := 1 );
	port(
		iClkReg : in STD_LOGIC;
		iClkProcess : in STD_LOGIC;
		iRst_async : in STD_LOGIC;
		iValid_p : in STD_LOGIC;
		ivAddr : in STD_LOGIC_VECTOR(3 downto 0);
		ivData : in STD_LOGIC_VECTOR(31 downto 0);
		oReachEnd : out STD_LOGIC;
		oFoundNonce : out STD_LOGIC;
		ovNonce : out STD_LOGIC_VECTOR(31 downto 0);
		ovDigest : out tDwordArray(0 to 7) );
	end component;
	
	component sha_256_chunk
	generic(
		gMSG_IS_CONSTANT : std_logic_vector(0 to 15) := (others=>'1');
		gH_IS_CONST : std_logic_vector(0 to 7) := (others=>'1');
		gBASE_DELAY : integer := 1
	);
	port(
		iClk : in STD_LOGIC;
		iRst_async : in STD_LOGIC;
		iValid : in STD_LOGIC;
		ivMsgDword : in tDwordArray(0 to 15);
		ivH0 : in STD_LOGIC_VECTOR(31 downto 0);
		ivH1 : in STD_LOGIC_VECTOR(31 downto 0);
		ivH2 : in STD_LOGIC_VECTOR(31 downto 0);
		ivH3 : in STD_LOGIC_VECTOR(31 downto 0);
		ivH4 : in STD_LOGIC_VECTOR(31 downto 0);
		ivH5 : in STD_LOGIC_VECTOR(31 downto 0);
		ivH6 : in STD_LOGIC_VECTOR(31 downto 0);
		ivH7 : in STD_LOGIC_VECTOR(31 downto 0);
		ovH0 : out STD_LOGIC_VECTOR(31 downto 0);
		ovH1 : out STD_LOGIC_VECTOR(31 downto 0);
		ovH2 : out STD_LOGIC_VECTOR(31 downto 0);
		ovH3 : out STD_LOGIC_VECTOR(31 downto 0);
		ovH4 : out STD_LOGIC_VECTOR(31 downto 0);
		ovH5 : out STD_LOGIC_VECTOR(31 downto 0);
		ovH6 : out STD_LOGIC_VECTOR(31 downto 0);
		ovH7 : out STD_LOGIC_VECTOR(31 downto 0) );
	end component; 
	
	component pipelines_without_reset IS
		GENERIC (gBUS_WIDTH : integer := 1; gNB_PIPELINES: integer range 1 to 255 := 2);
		PORT(
			iClk				: IN		STD_LOGIC;
			iInput				: IN		STD_LOGIC;
			ivInput				: IN		STD_LOGIC_VECTOR(gBUS_WIDTH-1 downto 0);
			oDelayed_output		: OUT		STD_LOGIC;
			ovDelayed_output	: OUT		STD_LOGIC_VECTOR(gBUS_WIDTH-1 downto 0)
		);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal iClkReg : STD_LOGIC := '1';
	signal iClkProcess : STD_LOGIC := '1';
	signal iRst_async : STD_LOGIC := '1';
	signal iValid_p : STD_LOGIC := '0';
	signal ivAddr : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal ivData : STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
	-- Observed signals - signals mapped to the output ports of tested entity
	signal oReachEnd : STD_LOGIC := '0';
	signal oFoundNonce : STD_LOGIC := '0';
	signal ovNonce : STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
	signal ovDigest : tDwordArray(0 to 7) := (others=>(others=>'0'));

	-- Add your code here ...
	constant cCMD_ADDR : std_logic_vector(3 downto 0) := X"D";
	constant cCMD_IDLE : std_logic_vector(15 downto 0) := X"0000";
	constant cCMD_RESET : std_logic_vector(15 downto 0) := X"CAFE";
	constant cCMD_START : std_logic_vector(15 downto 0) := X"0001";
	
	signal svWork : tDwordArray(0 to 31) := (others=>(others=>'0'));
	
	signal siWriteCnt : std_logic_vector(31 downto 0) := (others => '0');
	
	signal sHashMidStateValidIn : std_logic := '0';	
	signal sHashMidStateValidOut : std_logic := '0';
	signal svHashMidStateDataOut : tDwordArray(0 to 7) := (others=>(others=>'0'));
	signal svMidState : tDwordArray(0 to 7) := (others=>(others=>'0'));	
	signal sMidStateValid : std_logic := '0';

begin

	-- Unit Under Test port map
	UUT : btc_dsha
		generic map (
			gBASE_DELAY => gBASE_DELAY
		)

		port map (
			iClkReg => iClkReg,
			iClkProcess => iClkProcess,
			iRst_async => iRst_async,
			iValid_p => iValid_p,
			ivAddr => ivAddr,
			ivData => ivData,
			oReachEnd => oReachEnd,
			oFoundNonce => oFoundNonce,
			ovNonce => ovNonce,
			ovDigest => ovDigest
		);

	-- Add your stimulus here ...
	
	iClkReg <= not iClkReg after 5 ns;
	iClkProcess <= not iClkProcess after 5 ns;
	iRst_async <= '0' after 71 ns;
	
	svWork(0) <= X"02000000" after 251 ns;
	svWork(1) <= X"ea144059" after 251 ns;
	svWork(2) <= X"2a8b0d36" after 251 ns;
	svWork(3) <= X"b2e5f8a4" after 251 ns;
	svWork(4) <= X"85db1c04" after 251 ns;
	svWork(5) <= X"ca9290ca" after 251 ns;
	svWork(6) <= X"05bdc7f2" after 251 ns;
	svWork(7) <= X"05000000" after 251 ns;
	svWork(8) <= X"00000000" after 251 ns;
	svWork(9) <= X"11dfffb5" after 251 ns;
	svWork(10) <= X"ad285596" after 251 ns;
	svWork(11) <= X"8e4403d0" after 251 ns;
	svWork(12) <= X"60bdf636" after 251 ns;
	svWork(13) <= X"a023e387" after 251 ns;
	svWork(14) <= X"2870bbdc" after 251 ns;
	svWork(15) <= X"92e0aede" after 251 ns;
	svWork(16) <= X"acde4c0e" after 251 ns;
	svWork(17) <= X"032A6C52" after 251 ns;
	svWork(18) <= X"85fc0a19" after 251 ns;
	svWork(19) <= X"0BCFA6B6" after 251 ns;
	

	process(iClkReg, iRst_async)
	begin
		if iRst_async = '1' then
			siWriteCnt <= (others => '0');
			iValid_p <= '0';
		elsif rising_edge(iClkReg) then
			if sMidStateValid = '1' then
				siWriteCnt <= siWriteCnt + '1';
			end if;
			
			if siWriteCnt(3 downto 0) = X"F" and siWriteCnt(15 downto 4) <= conv_std_logic_vector(13, 12) then
				iValid_p <= '1';
			else
				iValid_p <= '0';
			end if;
		end if;
	end process;
	
	process(iClkReg, iRst_async)
	begin
		if iRst_async = '1' then
			ivAddr <= (others=>'0');
			ivData <= (others=>'0');
		elsif rising_edge(iClkReg) then
			if siWriteCnt(3 downto 0) = X"F" then
				case siWriteCnt(15 downto 4) is
					when X"000" =>
					ivAddr <= X"0";
					ivData <= svMidState(0);
					
					when X"001" =>
					ivAddr <= X"1";
					ivData <= svMidState(1);
					
					when X"002" =>
					ivAddr <= X"2";
					ivData <= svMidState(2);
					
					when X"003" =>
					ivAddr <= X"3";
					ivData <= svMidState(3);
					
					when X"004" =>
					ivAddr <= X"4";
					ivData <= svMidState(4);
					
					when X"005" =>
					ivAddr <= X"5";
					ivData <= svMidState(5);
					
					when X"006" =>
					ivAddr <= X"6";
					ivData <= svMidState(6);
					
					when X"007" =>
					ivAddr <= X"7";
					ivData <= svMidState(7);
					
					when X"008" =>
					ivAddr <= X"8";
					ivData <= svWork(16);
					
					when X"009" =>
					ivAddr <= X"9";
					ivData <= svWork(17);
					
					when X"00A" =>
					ivAddr <= X"A";
					ivData <= svWork(18);
					
					when X"00B" =>
					ivAddr <= X"B";
					ivData <= svWork(19) - X"20";
					
					when X"00C" =>
					ivAddr <= X"C";
					ivData <= svWork(19); -- + X"02";
					
					when X"00D" =>
					ivAddr <= cCMD_ADDR;
					ivData <= X"0000" & cCMD_START;
					
					when others =>
					ivAddr <= cCMD_ADDR;
					ivData <= X"0000" & cCMD_IDLE;					
				end case;
			end if;
		end if;
	end process;
	
	
	sHashMidStateValidIn <= '1' after 251 ns, '0' after 261 ns;
	
	sha_256_chunk_inst_HashMidState : sha_256_chunk
		generic map(
			gMSG_IS_CONSTANT => (others=>'0'),
			gH_IS_CONST => (others=>'1'),
			gBASE_DELAY => gBASE_DELAY
		)
		port map (
			iClk => iClkProcess,
			iRst_async => iRst_async,
			iValid => sHashMidStateValidIn,
			
			ivMsgDword => svWork(0 to 15),
			
			ivH0 => X"6a09e667",
			ivH1 => X"bb67ae85",
			ivH2 => X"3c6ef372",
			ivH3 => X"a54ff53a",
			ivH4 => X"510e527f",
			ivH5 => X"9b05688c",
			ivH6 => X"1f83d9ab",
			ivH7 => X"5be0cd19",
			
			ovH0 => svHashMidStateDataOut(0),
			ovH1 => svHashMidStateDataOut(1),
			ovH2 => svHashMidStateDataOut(2),
			ovH3 => svHashMidStateDataOut(3),
			ovH4 => svHashMidStateDataOut(4),
			ovH5 => svHashMidStateDataOut(5),
			ovH6 => svHashMidStateDataOut(6),
			ovH7 => svHashMidStateDataOut(7)
		);
		
	pipelines_without_reset_Valid : pipelines_without_reset
		GENERIC map(gBUS_WIDTH => 1, gNB_PIPELINES => (64 * gBASE_DELAY + 1))
		PORT map(
			iClk => iClkProcess,
			iInput => sHashMidStateValidIn,
			ivInput => (others=>'0'),
			oDelayed_output => sHashMidStateValidOut,
			ovDelayed_output => open
		);
		
	process(iClkProcess)
	begin
		if rising_edge(iClkProcess) then
			if sHashMidStateValidOut = '1' then
				svMidState <= svHashMidStateDataOut;
				sMidStateValid <= '1';
			end if;
		end if;
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_btc_dsha of btc_dsha_tb is
	for TB_ARCHITECTURE
		for UUT : btc_dsha
			use entity work.btc_dsha(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_btc_dsha;

