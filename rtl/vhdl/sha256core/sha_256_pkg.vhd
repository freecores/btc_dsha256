-- Copyright (c) 2013 VariStream
-- Author : Yu Peng 

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;

package sha_256_pkg is
	type tDwordArray is array (natural range<>) of std_logic_vector(31 downto 0);
	
	function sigma_0 (signal x : in std_logic_vector) return std_logic_vector;
	function sigma_1 (signal x : in std_logic_vector) return std_logic_vector;

	function sum_0 (signal x : in std_logic_vector) return std_logic_vector;
	function sum_1 (signal x : in std_logic_vector) return std_logic_vector;

	function chi (signal x : in std_logic_vector;
				signal y : in std_logic_vector;
				signal z : in std_logic_vector) return std_logic_vector;

	function maj (signal x : in std_logic_vector;
				signal y : in std_logic_vector;
				signal z : in std_logic_vector) return std_logic_vector;
				
	function getW_IS_CONST (is_const : in std_logic_vector) return std_logic_vector;
	function conv_str_to_msg (str : in string) return tDwordArray;
end sha_256_pkg;

package body sha_256_pkg is

function sigma_0 (signal x : in std_logic_vector) return std_logic_vector is
	variable tmp_0 : std_logic_vector(31 downto 0);
	variable tmp_1 : std_logic_vector(31 downto 0);
	variable tmp_2 : std_logic_vector(31 downto 0); 
	variable r : std_logic_vector(31 downto 0); 
begin
	tmp_0 := x(6 downto 0) & x(31 downto 7);
	tmp_1 := x(17 downto 0) & x(31 downto 18);
	tmp_2 := "000" & x(31 downto 3);
	
	r := tmp_0 xor tmp_1 xor tmp_2;   
   
	return r; 
end sigma_0;


function sigma_1 (signal x : in std_logic_vector) return std_logic_vector is
	variable tmp_0 : std_logic_vector(31 downto 0);
	variable tmp_1 : std_logic_vector(31 downto 0);
	variable tmp_2 : std_logic_vector(31 downto 0); 
	
	variable r : std_logic_vector(31 downto 0); 
begin
	tmp_0 := x(16 downto 0) & x(31 downto 17);
	tmp_1 := x(18 downto 0) & x(31 downto 19);
	tmp_2 := "0000000000" & x(31 downto 10);
	
	r := tmp_0 xor tmp_1 xor tmp_2; 
   
	return r; 
end sigma_1;


function chi (signal x : in std_logic_vector;
	signal y : in std_logic_vector;
	signal z : in std_logic_vector) return std_logic_vector is
					  
    variable r : std_logic_vector(31 downto 0);
	 
begin
	r := (x and y) xor (not(x) and z); 
			
	return r;
end chi;


function maj (signal x : in std_logic_vector;
	signal y : in std_logic_vector;
	signal z : in std_logic_vector) return std_logic_vector is
	
	variable r : std_logic_vector(31 downto 0);
  
begin
	r := (x and y) xor (x and z) xor (y and z);
		
	return r;

end maj;  


function sum_0 (signal x : in std_logic_vector) return std_logic_vector is
	variable tmp_0 : std_logic_vector(31 downto 0);
	variable tmp_1 : std_logic_vector(31 downto 0);
	variable tmp_2 : std_logic_vector(31 downto 0);
	
	variable r : std_logic_vector(31 downto 0);
begin
	tmp_0 := x(1 downto 0) & x(31 downto 2);
	tmp_1 := x(12 downto 0) & x(31 downto 13);
	tmp_2 := x(21 downto 0) & x(31 downto 22);
	
	r := tmp_0 xor tmp_1 xor tmp_2;
	
	return r;
	
end sum_0;


function sum_1 (signal x : in std_logic_vector) return std_logic_vector is
	variable tmp_0 : std_logic_vector(31 downto 0);
	variable tmp_1 : std_logic_vector(31 downto 0);
	variable tmp_2 : std_logic_vector(31 downto 0);
	
	variable r : std_logic_vector(31 downto 0);
begin

	tmp_0 := x(5 downto 0) & x(31 downto 6);
	tmp_1 := x(10 downto 0) & x(31 downto 11);
	tmp_2 := x(24 downto 0) & x(31 downto 25);
	
	r := tmp_0 xor tmp_1 xor tmp_2;
	
	return r;
end sum_1;

function getW_IS_CONST (is_const : in std_logic_vector) return std_logic_vector is
	variable r : std_logic_vector(0 to 63);
begin
	for i in 0 to 15 loop 
		r(i) := is_const(i);
	end loop;
	
	for i in 16 to 63 loop
		r(i) := r(i-16) and r(i-15) and r(i-7) and r(i-2);
	end loop;
	
	return r;
end getW_IS_CONST;

function conv_str_to_msg (str : in string) return tDwordArray is
	variable str_len : integer := str'length;
	variable retval : tDwordArray(0 to 15) := (others=>(others=>'0'));
begin
	if str_len > 0 then
		for i in 0 to (str_len - 1) loop
			retval(i / 4)(((4 - (i mod 4)) * 8 - 1) downto ((3 - (i mod 4)) * 8)) := conv_std_logic_vector(character'pos(str(i + 1)), 8);
		end loop;
	end if;
	
	retval(str_len / 4)(((4 - (str_len mod 4)) * 8 - 1) downto ((3 - (str_len mod 4)) * 8)) := X"80";
	retval(15) := conv_std_logic_vector((str_len * 8), 32);
		
	return retVal;
end conv_str_to_msg;

end sha_256_pkg;
