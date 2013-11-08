-------------------------------------------------------------------------------
-- Copyright (c) 2013 VariStream
-- Author : Yu Peng
-- Description:
--   Simple dual-port RAM in read-first mode with output register.
--   This block infers block RAM or distribute RAM according to value of gADDRESS_WIDTH and gDATA_WIDTH,
-- NOTE: 
--   Reset is on data output ONLY.
--   This requirement follows the XST User Guide to synthesize into BRAM.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sdpram_infer_read_first_outreg is
    generic (
        gADDRESS_WIDTH : integer := 5;
        gDATA_WIDTH : integer := 24
        );
    port (
        iClk : in std_logic;
        iReset_sync : in std_logic;
        iWe : in std_logic;
        ivWrAddr : in std_logic_vector(gADDRESS_WIDTH-1 downto 0);
		ivRdAddr : in std_logic_vector(gADDRESS_WIDTH-1 downto 0);
        ivDataIn : in std_logic_vector(gDATA_WIDTH-1 downto 0);
        ovDataOut : out std_logic_vector(gDATA_WIDTH-1 downto 0)
        );
end sdpram_infer_read_first_outreg;

architecture behavioral of sdpram_infer_read_first_outreg is
    -- Output register
    signal svDataOut : std_logic_vector (gDATA_WIDTH-1 downto 0) := (others => '0');

    -- RAM addressable data array
    type   tRAM is array (2**gADDRESS_WIDTH-1 downto 0) of std_logic_vector (gDATA_WIDTH-1 downto 0);
    signal svRAM : tRAM := (others => (others => '0'));

begin
    ovDataOut <= svDataOut;
    process (iClk)
    begin
        if iClk'event and iClk = '1' then
            if iWE = '1' then
                svRAM(conv_integer(ivWrAddr)) <= ivDataIn;
            end if;
			
			svDataOut <= svRAM(conv_integer(ivRdAddr));
        end if;
    end process;
end behavioral;
