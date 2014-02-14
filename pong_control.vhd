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

type state_type is (movement, right_wall, left_wall);
signal state_reg, state_next : state_type;
signal up_signal, down_signal : std_logic;
signal paddle_y_next, paddle_y_reg : unsigned(10 downto 0);
signal counter_reg, counter_next : unsigned(10 downto 0);
signal ball_x_reg, ball_x_next, ball_y_reg, ball_y_next : unsigned(10 downto 0);
signal y_dir, x_dir, y_dir_reg, x_dir_reg: std_logic;
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
	
--ball counter
	counter_next <= counter_reg + 1 when counter_reg < to_unsigned(ball_speed, 11) and v_completed = '1' else
					    (others => '0') when counter_reg >= to_unsigned(ball_speed, 11) else
					    counter_reg;
	
	process(clk, reset)
	begin
		if reset = '1' then
			counter_reg <= (others => '0');
		elsif rising_edge(clk) then
			counter_reg <= counter_next;
		end if;
	end process;

--State Register
process(clk, reset)
begin
	if reset = '1' then
		state_reg <= movement;
	elsif rising_edge(clk) then
		state_reg <= state_next;
	end if;
end process;

--output buffer
process(clk, reset)
	begin
		if (reset = '1') then
			ball_x_reg <= to_unsigned(ball_x_init, 11);
			ball_y_reg <= to_unsigned(ball_y_init, 11);
			x_dir_reg <= '0';
		elsif (rising_edge(clk)) then
			ball_x_reg <= ball_x_next;
			ball_y_reg <= ball_y_next;
			x_dir_reg <= x_dir;
			y_dir_reg <= y_dir;
		end if;
	end process;
	
--next-state logic
	process(state_next, state_reg, ball_x_reg)
	begin
		state_next <= state_reg;
	if (counter_reg >= ball_speed) then
	
		case state_reg is
			when movement =>
				if (ball_x_reg >= horizontal_size-1) then
					state_next <= right_wall;
				elsif (ball_x_reg <= 1) then
					state_next <= left_wall;
				end if;
			when right_wall =>	
				state_next <= movement;
			when left_wall =>
				state_next <= movement;			
		end case;
		
	end if;
		
	end process;
	
--output logic
	process(state_next, counter_reg)
	begin
		ball_x_next <= ball_x_reg;
		ball_y_next <= ball_y_reg;
		x_dir <= x_dir_reg;
		y_dir <= y_dir_reg;
	if (counter_reg >= ball_speed) then
		case state_next is
			when movement =>
				if (x_dir_reg = '0') then
					ball_x_next <= ball_x_reg + 1;
				elsif (x_dir_reg = '1') then
					ball_x_next <= ball_x_reg - to_unsigned(1, 11);
				end if;
			when right_wall =>
				x_dir <= '1';
			when left_wall =>
				x_dir <= '0';			
		end case;
	end if;
	
	end process;

--output
ball_x <= ball_x_reg;
ball_y <= ball_y_reg;

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
		paddle_y_next <= paddle_y_reg - to_unsigned(5, 11);	
	elsif (up_signal = '0' and down_signal = '1' and paddle_y_next < 479) then
		paddle_y_next <= paddle_y_reg + 5;
	end if;

end process;
	
paddle_y <= paddle_y_reg;	
	
end pong_control_arch;

