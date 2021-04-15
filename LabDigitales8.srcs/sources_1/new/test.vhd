----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2021 03:24:25 PM
-- Design Name: 
-- Module Name: test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test is
  Port (
    clk : in std_logic;
    seg, an : out std_logic_vector(7 downto 0));
end test;

architecture Behavioral of test is

component main_pwm
    port (
        clk100m : in std_logic;
        btn_in  : in std_logic;
        pwm_out : out std_logic;
        seg : out std_logic_vector(7 downto 0);
        an : out std_logic_vector(7 downto 0));
end component;

type BUTTON_STATES is
    (NOT_PRESSED, PRESSED);
signal state : BUTTON_STATES := NOT_PRESSED;

signal btn : std_logic := '0';
signal pwm : std_logic := '0';


begin
main : main_pwm port map(clk, btn, pwm, seg, an);
process(clk)
variable timer : integer := 0;
begin

    if(clk = '1' and clk'event) then
        timer := timer + 1;
        case (state) is
            when NOT_PRESSED => 
                if(timer > 100000000) then
                    state <= PRESSED;
                    btn <= '1';
                    timer := 0;
                end if;
            when PRESSED =>
                if(timer > 100000000) then
                    state <= NOT_PRESSED;
                    btn <= '0';
                    timer := 0;
                end if;
        end case;
        end if;

end process;

end Behavioral;
