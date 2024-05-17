-- Project: amp
-- Testbench: math_tb
--
-- Tests the VHDL functions for the math package by used precomputed inputs and
-- outputs generated by an external Python script done as a separate preprocessing
-- step.

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types.all;
use work.math.all;
use work.cast.all;

entity math_tb is
end entity;

architecture sim of math_tb is

  constant STEPS: usize := 16;

  signal counter: logics(highest_bit_set(STEPS) downto 0) := logics(to_usign(STEPS, highest_bit_set(STEPS)+1));

begin

  uut: entity work.pseudo
    port map(
      active => open
    );

  check: process
    constant k_input: usizes := (0, 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 15, 16, 45, 46, 47, 63, 64);
    constant soln_clog2: usizes := (0, 1, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 6, 6, 6, 6, 6);
    constant soln_flog2p1: usizes := (1, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 6, 6, 6, 6, 7);
    constant soln_pow2: usizes := (1, 2, 4, 8, 16, 32, 64, 128, 256, 4096, 8192, 32768, 65536);
    constant soln_pow2m1: usizes := (0, 1, 3, 7, 15, 31, 63, 127, 255, 4095, 8191, 32767, 65535);
    constant soln_is_pow2: bools := (false, true, true, false, true, false, false, false, true, false, false, false, true, false, false, false, false, true);
    
    variable k: usize := 0;

    constant cutoff: usize := 13;

  begin

    report "counter is bits: " & to_str(counter);

    -- test lower k values
    for i in 0 to cutoff-1 loop
      k := k_input(i);
      assert soln_clog2(i) = clog2(k) report "MATH.CLOG2: incorrect result k = " & usize'image(k) & ", got: " & usize'image(clog2(k)) & ", expected: " & usize'image(soln_clog2(i)) severity error;
      assert soln_flog2p1(i) = flog2p1(k) report "MATH.FLOG2P1: incorrect result k = " & usize'image(k) & ", got: " & usize'image(flog2p1(k)) & ", expected: " & usize'image(soln_flog2p1(i)) severity error;
      assert soln_pow2(i) = pow2(k) report "MATH.POW2: incorrect result k = " & usize'image(k) & ", got: " & usize'image(pow2(k)) & ", expected: " & usize'image(soln_pow2(i)) severity error;
      assert soln_pow2m1(i) = pow2m1(k) report "MATH.POW2M1: incorrect result k = " & usize'image(k) & ", got: " & usize'image(pow2m1(k)) & ", expected: " & usize'image(soln_pow2m1(i)) severity error;
      assert soln_is_pow2(i) = is_pow2(k) report "MATH.IS_POW2: incorrect result k = " & usize'image(k) & ", got: " & bool'image(is_pow2(k)) & ", expected: " & bool'image(soln_is_pow2(i)) severity error;
      
      assert soln_clog2(i) = length_bits_enum(k) report "MATH.LEN_BITS_ENUM: incorrect result" severity error;
      assert soln_flog2p1(i) = length_bits_repr(k) report "MATH.LEN_BITS_REPR: incorrect result" severity error;
    end loop;

    -- test higher k values
    for i in cutoff to k_input'length-1 loop
      k := k_input(i);
      assert soln_clog2(i) = clog2(k) report "MATH.CLOG2: incorrect result k = " & usize'image(k) & ", got: " & usize'image(clog2(k)) & ", expected: " & usize'image(soln_clog2(i)) severity error;
      assert soln_flog2p1(i) = flog2p1(k) report "MATH.FLOG2P1: incorrect result k = " & usize'image(k) & ", got: " & usize'image(flog2p1(k)) & ", expected: " & usize'image(soln_flog2p1(i)) severity error;
      assert soln_is_pow2(i) = is_pow2(k) report "MATH.IS_POW2: incorrect result k = " & usize'image(k) & ", got: " & bool'image(is_pow2(k)) & ", expected: " & bool'image(soln_is_pow2(i)) severity error;
    
      assert soln_clog2(i) = length_bits_enum(k) report "MATH.LEN_BITS_ENUM: incorrect result" severity error;
      assert soln_flog2p1(i) = length_bits_repr(k) report "MATH.LEN_BITS_REPR: incorrect result" severity error;
    end loop;

    wait;
  end process;

end architecture;