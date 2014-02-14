----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:53:58 02/12/2014 
-- Design Name: 
-- Module Name:    button_pressed - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity button_pressed is
	port(
		clk         : in std_logic;
      reset       : in std_logic;
		button_in	: in std_logic;
		button_out	: out std_logic
		);
end button_pressed;

architecture Behavioral of button_pressed is
	type state_type is
		(idle, debounce, output);
	signal state_reg, state_next: state_type;
	signal button_out_reg, button_out_next: std_logic;
	signal count, count_next : unsigned(19 downto 0);
	signal counter : natural;
begin

--counter register
count_next <= count + 1 when state_reg = debounce else
to_unsigned(0, 20);
	process(clk, reset)
	begin
			if (reset = '1') then
				count <= to_unsigned(0,20);
			elsif rising_edge(clk) then
				count <= count_next;
			end if;
	end process;


--state register
	process(clk, reset)
	begin
		if (reset='1') then
			state_reg <= idle;
		elsif (rising_edge(clk)) then
			state_reg <= state_next;
		end if;
	end process;
	
--output buffer
	process(clk)
	begin
		if (rising_edge(clk)) then
			button_out_reg <= button_out_next;
		end if;
	end process;

--next-state logic
process(button_in, count)
begin
	state_next <= state_reg;
	
	case state_reg is
		when idle =>
			if (button_in = '1') then
				state_next <= debounce;
			end if;
		
		when debounce =>
			if (count > 50000 and button_in = '0') then
				state_next <= output;
			end if;
		
		when output =>
			state_next <= idle;
				
	end case;
end process;

--output logic
process(state_reg)
begin
	case state_reg is
		when idle =>
			button_out_next <= '0';
		when debounce =>
			button_out_next <= '0';
		when output =>
			button_out_next <= '1';
	end case;
end process;

--output
button_out <= button_out_reg;

end Behavioral;

