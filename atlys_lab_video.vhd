library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use IEEE.NUMERIC_STD.ALL;

entity atlys_lab_video is
    port (
             clk : in std_logic; -- 100 MHz
             reset : in std_logic;
				 up : in std_logic;
				 down : in std_logic;
             tmds : out std_logic_vector(3 downto 0);
             tmdsb : out std_logic_vector(3 downto 0)
    );
end atlys_lab_video;

architecture Good of atlys_lab_video is

component vga_sync
	port (
		clk	: in std_logic;
		reset	: in std_logic;
		h_sync	: out std_logic;
		v_sync	: out std_logic;
		v_completed : out std_logic;
		blank	: out std_logic;
		row	: out unsigned(10 downto 0);
		column	: out unsigned(10 downto 0)
	);
end component;

component pixel_gen
	port (  
		row      : in unsigned(10 downto 0);
      column   : in unsigned(10 downto 0);
      blank    : in std_logic;
      ball_x   : in unsigned(10 downto 0);
      ball_y   : in unsigned(10 downto 0);
      paddle_y : in unsigned(10 downto 0);
      r,g,b    : out std_logic_vector(7 downto 0)
	);
end component;

component pong_control
	port (
		clk         : in std_logic;
      reset       : in std_logic;
      up          : in std_logic;
      down        : in std_logic;
      v_completed : in std_logic;
      ball_x      : out unsigned(10 downto 0);
      ball_y      : out unsigned(10 downto 0);
      paddle_y    : out unsigned(10 downto 0)
	);
end component;


    signal pixel_clk, serialize_clk, serialize_clk_n, blank_sig: std_logic;
	 signal h_sync_sig, v_sync_sig, v_completed_sig: std_logic;
	 signal red, green, blue : std_logic_vector (7 downto 0);
	 signal red_s, green_s, blue_s, clock_s : std_logic;
	 signal row_sig, column_sig : unsigned(10 downto 0);
	 signal ball_x_sig, ball_y_sig, paddle_y_sig : unsigned(10 downto 0);
begin

    -- Clock divider - creates pixel clock from 100MHz clock
    inst_DCM_pixel: DCM
    generic map(
                   CLKFX_MULTIPLY => 2,
                   CLKFX_DIVIDE => 8,
                   CLK_FEEDBACK => "1X"
               )
    port map(
                clkin => clk,
                rst => reset,
                clkfx => pixel_clk
            );

    -- Clock divider - creates HDMI serial output clock
    inst_DCM_serialize: DCM
    generic map(
                   CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
                   CLKFX_DIVIDE => 8,
                   CLK_FEEDBACK => "1X"
               )
    port map(
                clkin => clk,
                rst => reset,
                clkfx => serialize_clk,
                clkfx180 => serialize_clk_n
            );

inst_vga_sync: vga_sync
	port map(
		clk	=> pixel_clk,
		reset	=> reset,
		h_sync	=> h_sync_sig,
		v_sync	=> v_sync_sig,
		v_completed => v_completed_sig,
		blank	=> blank_sig,
		row	=> row_sig,
		column	=> column_sig
	);

inst_pixel_gen: pixel_gen
	port map(
			  row => row_sig,
           column => column_sig,
           blank => blank_sig,
			  ball_x => ball_x_sig,
			  ball_y => ball_y_sig,
			  paddle_y => paddle_y_sig,
           r => red,
           g => green,
           b => blue
);

inst_pong_control: pong_control
	port map(
		clk         => pixel_clk,
      reset       => reset,
      up          => up,
      down        => down,
      v_completed => v_completed_sig,
      ball_x      => ball_x_sig,
      ball_y      => ball_y_sig,
      paddle_y    => paddle_y_sig
);


    -- Convert VGA signals to HDMI (actually, DVID ... but close enough)
    inst_dvid: entity work.dvid
    port map(
                clk => serialize_clk,
                clk_n => serialize_clk_n,
                clk_pixel => pixel_clk,
                red_p => red,
                green_p => green,
                blue_p => blue,
                blank => blank_sig,
                hsync => h_sync_sig,
                vsync => v_sync_sig,
                -- outputs to TMDS drivers
                red_s => red_s,
                green_s => green_s,
                blue_s => blue_s,
                clock_s => clock_s
            );

    -- Output the HDMI data on differential signalling pins
    OBUFDS_blue : OBUFDS port map
        ( O => TMDS(0), OB => TMDSB(0), I => blue_s );
    OBUFDS_red : OBUFDS port map
        ( O => TMDS(1), OB => TMDSB(1), I => green_s );
    OBUFDS_green : OBUFDS port map
        ( O => TMDS(2), OB => TMDSB(2), I => red_s );
    OBUFDS_clock : OBUFDS port map
        ( O => TMDS(3), OB => TMDSB(3), I => clock_s );

end Good;