----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:18:56 01/31/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
-- Project Name: 
------	-- Target Devices: 
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

entity pixel_gen is
port ( 	 row      : in unsigned(10 downto 0);
          column   : in unsigned(10 downto 0);
          blank    : in std_logic;
          ball_x   : in unsigned(10 downto 0);
          ball_y   : in unsigned(10 downto 0);
          paddle_y : in unsigned(10 downto 0);
          r,g,b    : out std_logic_vector(7 downto 0)
		);
end pixel_gen;

architecture pixel_arch of pixel_gen is
begin

	process (row, column, blank)
	begin	
--		initial status
		r <= (others => '0');
		g <= (others => '0');
		b <= (others => '0');
		
--		Left Side of A
		if (row >= AF_Start_Row and row <= AF_Start_Row + Vertical_Bar_Size) then
			if (column >= AF_Start_Column and column <= AF_Start_Column + Standard_Width) then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '1');
			end if;
		end if;
		
--		Top of A
		if (row <= AF_Start_Row and row >= AF_Start_Row - Standard_Width) then
			if (column >= AF_Start_Column and column <= Horizontal_Bar_Size + AF_Start_Column) then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '1');
			end if;
		end if;
		
--		Middle of A
		if (row >= AF_Start_Row + Vertical_Bar_Size/2 - Standard_Width and
			row <= AF_Start_Row + Vertical_Bar_Size/2) then
			if (column >= AF_Start_Column and column <= Horizontal_Bar_Size + AF_Start_Column) then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '1');
			end if;
		end if;
		
--		Right Side of A
		if (row >= AF_Start_Row - Standard_Width and row <= AF_Start_Row + Vertical_Bar_Size) then
			if (column >= AF_Start_Column + Horizontal_Bar_Size and
			column <= AF_Start_Column + Horizontal_Bar_Size + Standard_Width) then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '1');
			end if;
		end if;
		
--		Vertical bar of F
	   if (row >= AF_Start_Row - Standard_Width and row <= AF_Start_Row + Vertical_Bar_Size) then
			if (column >= AF_Start_Column + Horizontal_Bar_Size + Standard_Width*2 and
			column <= AF_Start_Column + Horizontal_Bar_Size + Standard_Width*3) then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '1');
			end if;
		end if;
		
--		Top Bar of F
		if (row <= AF_Start_Row and row >= AF_Start_Row - Standard_Width) then
			if (column >= AF_Start_Column + Horizontal_Bar_Size + Standard_Width*2 and
			column <= AF_Start_Column + Horizontal_Bar_Size*2 + Standard_Width*2) then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '1');
			end if;
		end if;

--		Middle Bar of F
		if (row >= AF_Start_Row + Vertical_Bar_Size/2 - Standard_Width and
			row <= AF_Start_Row + Vertical_Bar_Size/2) then
			if (column >= AF_Start_Column + Horizontal_Bar_Size + Standard_Width*2 and
			column <= AF_Start_Column + Horizontal_Bar_Size*2 + Standard_Width*2) then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '1');
			end if;
		end if;

	end process;

end pixel_arch;