-------------------------------------------------------------------------------
-- i2s_unit.vhd:  VHDL RTL model for the i2s_unit.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- Entity declaration
-------------------------------------------------------------------------------

entity i2s_unit is
  port (
    clk       : in  std_logic;
    rst_n     : in  std_logic;
    play_in   : in  std_logic;
    tick_in   : in  std_logic;
    audio0_in : in  std_logic_vector(23 downto 0);
    audio1_in : in  std_logic_vector(23 downto 0);

    req_out   : out std_logic;
    ws_out    : out std_logic;
    sck_out   : out std_logic;
    sdo_out   : out std_logic
  );
end i2s_unit;

-------------------------------------------------------------------------------
-- Architecture declaration
-------------------------------------------------------------------------------

architecture RTL of i2s_unit is

  -- =========================
  -- Constants (from spec)
  -- =========================
  constant SAMPLE_W   : natural := 24;
  constant STEREO_W   : natural := 2 * SAMPLE_W; -- 48
  constant FRAME_CLKS : natural := 384;          -- one stereo frame in clk cycles
  constant SCK_PERIOD : natural := 8;            -- one sck period in clk cycles

  -- =========================
  -- Required registers
  -- =========================
  -- One binary counter (0..383 fits in 9 bits)
  signal ctr_r    : unsigned(8 downto 0);

  -- One 48-bit input register
  signal in_reg_r : std_logic_vector(STEREO_W-1 downto 0);

  -- One 48-bit shift register
  signal shreg_r  : std_logic_vector(STEREO_W-1 downto 0);

  -- =========================
  -- Helpful state (recommended)
  -- =========================
  signal play_r         : std_logic;
  signal stop_pending_r : std_logic;

  -- =========================
  -- Next-state signals (clean style)
  -- =========================
  signal ctr_n           : unsigned(8 downto 0);
  signal in_reg_n        : std_logic_vector(STEREO_W-1 downto 0);
  signal shreg_n         : std_logic_vector(STEREO_W-1 downto 0);
  signal play_n          : std_logic;
  signal stop_pending_n  : std_logic;

  -- =========================
  -- Combinational helper signals
  -- =========================
  signal sck_c    : std_logic;
  signal ws_c     : std_logic;
  signal sdo_c    : std_logic;
  signal req_c    : std_logic;

  signal sck_fall : std_logic; -- "this clk cycle is an sck falling edge"
  signal do_load  : std_logic; -- load shreg from in_reg
  signal do_shift : std_logic; -- shift shreg

begin

  -- Direct output connections (allowed in step 2)
  req_out <= req_c;
  ws_out  <= ws_c;
  sck_out <= sck_c;
  sdo_out <= sdo_c;

end RTL;
