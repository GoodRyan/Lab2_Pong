--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:11:42 02/12/2014
-- Design Name:   
-- Module Name:   C:/Users/C15Ryan.Good/Documents/classes/ECE/Lab2_Pong/pong_control_testbench.vhd
-- Project Name:  Lab2_Pong
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pong_control
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY pong_control_testbench IS
END pong_control_testbench;
 
ARCHITECTURE behavior OF pong_control_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pong_control
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         up : IN  std_logic;
         down : IN  std_logic;
         v_completed : IN  std_logic;
         ball_x : OUT  std_logic_vector(10 downto 0);
         ball_y : OUT  std_logic_vector(10 downto 0);
         paddle_y : OUT  std_logic_vector(10 downto 0)
        );
    END COMPONENT;
	 
component v_sync_gen
	generic(
			  sync_count: natural;
			  back_porch_count: natural;
			  active_video_count: natural;
			  front_porch_count: natural
	);
	port ( clk				: in std_logic;
			 reset			: in std_logic;
			 h_completed 	: in std_logic;
			 v_sync			: out std_logic;
			 blank			: out std_logic;
			 completed 		: out std_logic;
			 row				: out unsigned(10 downto 0)
	);
end component;

component h_sync_gen
	generic(
			  sync_count: natural;
			  back_porch_count: natural;
			  active_video_count: natural;
			  front_porch_count: natural
	);
	port( clk			: in std_logic;
			reset			: in std_logic;
			h_sync		: out std_logic;
			blank			: out std_logic;
			completed	: out std_logic;
			column		: out unsigned (10 downto 0)
	);
end component;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal up : std_logic := '0';
   signal down : std_logic := '0';
   signal v_completed : std_logic := '0';

 	--Outputs
   signal ball_x : std_logic_vector(10 downto 0);
   signal ball_y : std_logic_vector(10 downto 0);
   signal paddle_y : std_logic_vector(10 downto 0);
	
	--extra
	signal v_completed_sig, h_completed_sig : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pong_control PORT MAP (
          clk => clk,
          reset => reset,
          up => up,
          down => down,
          v_completed => v_completed_sig,
          ball_x => ball_x,
          ball_y => ball_y,
          paddle_y => paddle_y
        );
		  
	--instantiate v_sync
	v_sync_instance: v_sync_gen
		generic map( 
			sync_count=>2, 
			back_porch_count=>33,
			active_video_count=>480,
			front_porch_count=>10
		)
	port map(
		clk => clk,
		reset => reset,
		h_completed => h_completed_sig,
		v_sync => open,
		blank => open,
		completed => v_completed_sig,
		row => open
	);
	
	--instantiate h_sync
	h_sync_instance: h_sync_gen
	generic map( 
	sync_count=>95, 
	back_porch_count=>47,
	active_video_count=>639,
	front_porch_count=>15
	)
	port map(
		clk => clk,
		reset => reset,
		h_sync => open,
		blank => open,
		completed => h_completed_sig,
		column => open
	);
	
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
