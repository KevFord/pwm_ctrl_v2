library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;

entity tb is
end entity tb;

architecture behave of tb is

type t_7seg_number is array(0 to 10) of std_logic_vector(6 downto 0);
constant c_7seg_number      : t_7seg_number := (
    "1000000", -- 0
    "1111001", -- 1
    "0100100", -- 2
    "0110000", -- 3
    "0011001", -- 4
    "0010010", -- 5
    "0000010", -- 6
    "1111000", -- 7
    "0000000", -- 8
    "0011000", -- 9
    "1111111"  -- Blank
);

signal current_dc           : std_logic_vector(7 downto 0) := (others => '0');
signal current_dc_update    : std_logic := '0';

signal hex0                 : std_logic_vector(6 downto 0) := (others => '0');
signal hex1                 : std_logic_vector(6 downto 0) := (others => '0');
signal hex2                 : std_logic_vector(6 downto 0) := (others => '0');

signal transmit_data        : std_logic_vector(7 downto 0) := (others => '0');
signal transmit_valid       : std_logic := '0';
signal transmit_ready       : std_logic := '0';

signal received_data        : std_logic_vector(7 downto 0) := (others => '0');
signal received_valid       : std_logic := '0';
signal received_error       : std_logic := '0';

signal reset                : std_logic := '0';
signal clk_50               : std_logic := '0';
signal kill_clock           : std_logic := '0';

signal tx                   : std_logic := '1';
signal rx                   : std_logic := '1';

signal key_n                : std_logic_vector(3 downto 0) := (others => '1');
signal key_up               : std_logic := '0';
signal key_down             : std_logic := '0';
signal key_on               : std_logic := '0';
signal key_off              : std_logic := '0';

signal serial_down          : std_logic := '0';
signal serial_up          : std_logic := '0';
signal serial_on          : std_logic := '0';
signal serial_off          : std_logic := '0';

signal pwm_out          : std_logic := '0';

signal duty_cycle_out  : integer;
signal prev_duty_out    : integer;
signal key_event_out    : std_logic := '0';

begin

    i_pwm       : entity work.pwm_ctrl
    port map (
        clk_50              => clk_50, -- 50 MHz clock.
        reset               => reset, -- Active high.

        duty_cycle_out      => duty_cycle_out,
        prev_duty_out       => prev_duty_out,
        key_event_out       => key_event_out,

-- ///////////////// Block diagram A
    -- Key inputs will be pulsed high one clock pulse and key_up, key_down may be pulsed every 10 ms, indicating the key is being held.
        key_on              => key_on, -- Go back to previous DC (minimum 10%). Reset sets previous to 100%
        key_off             => key_off, -- Set current DC to 0%
        key_up              => key_up, -- Increase DC by 1%, 100% is maximum, minimum is 10%. If the unit is off, DC shall be set to 10% if this signal is received
        key_down            => key_down, -- Decrease DC by 1%, if unit is in the off state this signal is ignored

-- ///////////////// Block diagram C
    -- Inputs from the UART component. They have the same functionality as the key inputs but key inputs have priority.
        serial_on           => serial_on, -- Go back to previous DC (minimum 10%). Reset sets previous to 100%
        serial_off          => serial_off, -- Set current DC to 0%
        serial_up           => serial_up, -- Increase DC by 1%, 100% is maximum, minimum is 10%. If the unit is off, DC shall be set to 10% if this signal is received
        serial_down         => serial_down,-- Decrease DC by 1%, if unit is in the off state this signal is ignored

-- ///////////////// Block diagram D
    -- Outputs  
        current_dc          => current_dc, -- A byte representing the current duty cycle. range 0 - 100
        current_dc_update   => current_dc_update,-- A flag
-- PWM out
        ledg0               => pwm_out -- Output led. 1 ms period.
    );

    p_clock_gen : process
    begin
        while ( kill_clock = '0' ) loop
            clk_50 <= not clk_50;
            wait for 10 ns;
         end loop;
         -- wait forever;
         wait;
    end process p_clock_gen;

    p_reset_gen : process
    begin
        report("Reset process waiting on clock..");
        wait for 1 us;
        reset <= '1';
        report("Reset set.");
        wait for 1 us;
        reset <= '0';
        report("Reset released.");
        wait;
    end process p_reset_gen;

    p_main_test : process
    begin
        wait for 1.1 ms;
        wait on reset for 1 us;
        if reset = '0' then
            report("Main test begins.");            
        end if;
        wait for 1 ms;

        wait on clk_50 for 1 us;
        key_off <= '1';
        wait on clk_50 for 1 us;
        key_off <= '0';
        wait for 1.1 ms;

        wait on clk_50 for 1 us;
        key_on <= '1';
        wait on clk_50 for 1 us;
        key_on <= '0';
        wait for 1.1 ms;

        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;
        wait on clk_50 for 1 us;
        key_down <= '1';
        wait on clk_50 for 1 us;
        key_down <= '0';
        wait for 2.1 ms;

        --wait on clk_50 for 1 us;
        --key_up <= '1';
        --wait on clk_50 for 1 us;
        --key_up <= '0';
        --wait for 2.1 ms;
        --wait on clk_50 for 1 us;
        --key_up <= '1';
        --wait on clk_50 for 1 us;
        --key_up <= '0';
        --wait for 2.1 ms;

        --wait on clk_50 for 1 us;
        --key_on <= '1';
        --wait on clk_50 for 1 us;
        --key_on <= '0';
        --wait for 2.1 ms;
    
        wait on clk_50 for 1 us;
        key_off <= '1';
        wait on clk_50 for 1 us;
        key_off <= '0';
        wait for 2.1 ms;

        wait on clk_50 for 1 us;
        key_on <= '1';
        wait on clk_50 for 1 us;
        key_on <= '0';
        wait for 2.1 ms;
        
        wait for 1 ms;
        kill_clock <= '1';
        report("Main test over. Check waves.");
        wait;
    end process p_main_test;
end architecture behave;