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

	type state_type is
		(idle, button_pressed, button_held);
	signal paddle_y_reg, paddle_y_next : unsigned(10 downto 0);
	signal state_reg, state_next: state_type;
 
begin

	--state register
	process(clk, reset)
	begin
		if (reset='1') then
			state_reg <= idle;
		elsif (rising_edge(clk)) then
			state_reg <= state_next;
		end if;
	end process;
	
	--initialize paddle
	process(clk, reset)
	begin
		if (reset = '1') then
			paddle_y_next <= to_unsigned(paddle_start, paddle_bits);
		end if;
	end process;
	
	--output buffer
	process(clk, paddle_y_next)
	begin
		if (rising_edge(clk)) then
			paddle_y_reg <= paddle_y_next;
		end if;
	end process;
	
	--next-state logic
	process(state_next, up, down)
	begin
		state_next <= state_reg;
		
		case state_reg is
			when idle =>
				if (up = '1' or down = '1') then
					state_next <= button_pressed;
				end if;
			when button_pressed =>
				if (up = '1' or down = '1') then
					state_next <= button_held;
				end if;
			when button_held =>
				if (up = '0' and down = '0') then
					state_next <= idle;
				end if;
		end case;		
	end process;
	
	--output logic
	process(state_next)
	begin
		case state_next is
			when idle =>
				paddle_y_next <= paddle_y_reg;
			when button_pressed =>
				if (up = '1') then
					paddle_y_next <= paddle_y_reg - paddle_increment;
				elsif (down = '1') then
					paddle_y_next <= paddle_y_reg + paddle_increment;
				end if;
			when button_held =>
				paddle_y_next <= paddle_y_reg;
		end case;
	end process;
	
	--output
	paddle_y <= paddle_y_reg;
	
end pong_control_arch;

