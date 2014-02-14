--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use IEEE.NUMERIC_STD.ALL;

package PONG_CONSTANTS is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
	constant vertical_size				: natural := 480;
	constant horizontal_size			: natural := 639;
	
	constant AF_Start_Row				: natural := 175;
	constant AF_Start_Column			: natural := 200;
	
	constant Vertical_Bar_Size			: natural := 125;
	constant Horizontal_Bar_Size		: natural := 100;
	constant Standard_Width				: natural := 20;
	
	constant paddle_increment			: natural := 2;
	constant paddle_size					: natural := 50;
	constant paddle_start				: natural := 200;
	constant paddle_bit_size			: natural := 11;
	
	constant ball_x_init					: natural := 100;
	constant ball_y_init					: natural := 200;
	
	constant ball_speed					: natural := 1000;

-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end PONG_CONSTANTS;

package body PONG_CONSTANTS is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end PONG_CONSTANTS;
