----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:58:31 02/12/2014 
-- Design Name: 
-- Module Name:    pong_control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
   use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
  library UNISIM;
  use UNISIM.VComponents.all;
  
--my constants library
library work;
use work.PONG_CONSTANTS.all;

entity pong_control is
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
end pong_control;

architecture pong_control_arch of pong_control is

component button_pressed
	port(
		clk         : in std_logic;
      reset       : in std_logic;
		button_in	: in std_logic;
		button_out	: out std_logic
		);
end component;

signal up_signal, down_signal : std_logic;
signal paddle_y_next, paddle_y_reg : unsigned(10 downto 0);
begin

inst_up_pressed: button_pressed
	port map(
		clk	=> clk,
		reset	=> reset,
		button_in => up,
		button_out => up_signal
	);

inst_down_pressed: button_pressed
	port map(
		clk => clk,
		reset => reset,
		button_in => down,
		button_out => down_signal
	);


--paddle flip flop
process(clk, reset)
begin
		if (reset = '1') then
			paddle_y_reg <= (others => '0');
		elsif rising_edge(clk) then
			paddle_y_reg <= paddle_y_next;
		end if;
		
end process;
	
--paddle movement
process (up_signal, down_signal, paddle_y_next, paddle_y_reg)
begin
	paddle_y_next <= paddle_y_reg;
	
	if (up_signal = '1' and  down_signal = '0' and paddle_y_next > 1) then
		paddle_y_next <= paddle_y_reg - to_unsigned(1, 11);	
	elsif (up_signal = '0' and down_signal = '1' and paddle_y_next < 479) then
		paddle_y_next <= paddle_y_reg + 1;
	end if;

end process;
	
paddle_y <= paddle_y_reg;	
	
end pong_control_arch;

