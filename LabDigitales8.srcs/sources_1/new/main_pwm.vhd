library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main_pwm is  
port (
    clk100m : in std_logic;
    btn_in  : in std_logic;
    pwm_out : out std_logic;
    seg : out std_logic_vector(7 downto 0);
    an : out std_logic_vector(7 downto 0)
);
end main_pwm;

architecture Behavioral of main_pwm is

subtype u20 is unsigned(19 downto 0);
signal counter      : u20 := x"00000";

constant clk_freq   : integer := 100_000_000;       -- Clock frequency in Hz (10 ns)
constant pwm_freq   : integer := 50;                -- PWM signal frequency in Hz (20 ms)
constant period     : integer := clk_freq/pwm_freq; -- Clock cycle count per PWM period
signal duty_cycle : integer := 50_000;            -- Clock cycle count per PWM duty cycle

signal pwm_counter  : std_logic := '0';
signal stateHigh    : std_logic := '1';

signal clk50m       : std_logic;

component sSegDisplay
    Port(ck : in  std_logic;                          -- 100MHz system clock
        number : in  std_logic_vector (63 downto 0); -- eight digit number to be displayed
        seg : out  std_logic_vector (7 downto 0);    -- display cathodes
        an : out  std_logic_vector (7 downto 0)    -- display anodes (active-low, due to transistor complementing)
 );
end component;
signal num : std_logic_vector(63 downto 0) := (others => '1');
begin

seg7 : sSegDisplay port map(clk100m, num, seg, an);


 
pwm_generator : process(clk100m, btn_in) is
variable cur : u20 := counter;
begin
    -- 0, 45, 90, 135, 180
    case (duty_cycle) is
         when 50_000 => 
            num(7 downto 0) <= "00000011";
            num(15 downto 8) <= "11111111";
            num(23 downto 16) <= "11111111";

         when 100_000 => 
            num(7 downto 0) <= "01001001";
            num(15 downto 8) <= "10011001";
            num(23 downto 16) <= "11111111";
         when 150_000 => 
            num(7 downto 0) <= "00000011";
            num(15 downto 8) <= "00001001";
            num(23 downto 16) <= "11111111";
         when 200_000 =>
            num(7 downto 0) <= "01001001";
            num(15 downto 8) <= "00001101";
            num(23 downto 16) <= "10011111";
         when 250_000 => 
            num(7 downto 0) <= "00000011";
            num(15 downto 8) <= "00000001";
            num(23 downto 16) <= "10011111";
         when others => 
            num(7 downto 0) <= "11111111";
            num(15 downto 8) <= "11111111";
            num(23 downto 16) <= "11111111";
         end case;
         
         
    if((btn_in = '1' and btn_in'event)) then   
        if(duty_cycle /= 250_000) then
            duty_cycle <= duty_cycle + 50_000;
        else
            duty_cycle <= 50_000;
        end if;
    end if;
    
    if ((clk100m = '1' and clk100m'event) ) then
        cur := cur + 1;  
        counter <= cur;
        if (cur <= duty_cycle) then
            pwm_counter <= '1'; 
        elsif (cur > duty_cycle) then
            pwm_counter <= '0';
        elsif (cur = period) then
            cur := x"00000";
        end if;  
    end if;
end process pwm_generator;
pwm_out <= pwm_counter;
end Behavioral;