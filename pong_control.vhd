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
		(initialize, idle, button_pressed, button_held);
	signal paddle_y_reg, paddle_y_next : unsigned(10 downto 0);
	signal state_reg, state_next: state_type;
 
begin

	--state register
	process(clk, reset)
	begin
		if (reset='1') then
			state_reg <= initialize;
		elsif (rising_edge(clk)) then
			state_reg <= state_next;
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
			when initialize =>
				state_next <= idle;
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
			when initialize =>
				paddle_y_next <= paddle_start;
			when idle =>
			
			when button_pressed =>
				if (up = '1' and paddle_y_reg > 2) then
					paddle_y_next <= paddle_y_reg - paddle_increment;
				elsif (down = '1' and paddle_y_reg < 478) then
					paddle_y_next <= paddle_y_reg + paddle_increment;
				end if;
			when button_held =>
				
		end case;
	end process;
	
	--output
	paddle_y <= paddle_y_reg;
	
end pong_control_arch;

