library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity tb_pipe is
   
end tb_pipe ;

architecture arc_tb_pipe of tb_pipe is

	component pipe is
	
	port ( resetN    : in  std_logic 				    ;
		   clk 	     : in  std_logic 				    ;
		   ena_shift : in  std_logic 				    ;
		   ena_load  : in  std_logic 				    ;
		   write_din : in  std_logic 				    ;
		   din	     : in  std_logic_vector(7 downto 0) ;
		   dint 	 : inout std_logic_vector(7 downto 0) ) ;
		   
	end component pipe ;
	
	signal resetN    : std_logic 				    ;
	signal clk 	     : std_logic 				    ;
	signal ena_shift : std_logic 				    ;
	signal ena_load  : std_logic 				    ;
	signal write_din : std_logic 				    ;
	signal din	     : std_logic_vector(7 downto 0) ;
	signal dint 	 : std_logic_vector(7 downto 0) ;
	
begin
   
   eut: pipe
		port map ( resetN, clk, ena_shift, ena_load, write_din, din, dint ) ;
   
   resetN <= '0' , '1' after 100 ns ;
   
   process
   
   begin
   
      clk <= '0' ;  wait for 50 ns ;
      clk <= '1' ;  wait for 50 ns ;
	  
   end process ;

   process
   
   begin
   
      ena_shift <= '0'; ena_load <= '0'; write_din <= '0'; din <= "11010011"; wait for 100 ns ;
	  ena_shift <= '0'; ena_load <= '0'; write_din <= '1'; din <= "11010011"; wait for 100 ns ;
	  ena_shift <= '0'; ena_load <= '1'; write_din <= '0'; din <= "11010011"; wait for 100 ns ;
	  ena_shift <= '0'; ena_load <= '1'; write_din <= '1'; din <= "11010011"; wait for 100 ns ;
	  ena_shift <= '1'; ena_load <= '0'; write_din <= '0'; din <= "11010011"; wait for 100 ns ;
	  ena_shift <= '1'; ena_load <= '0'; write_din <= '1'; din <= "11010011"; wait for 100 ns ;
	  ena_shift <= '1'; ena_load <= '1'; write_din <= '0'; din <= "11010011"; wait for 100 ns ;
	  ena_shift <= '1'; ena_load <= '1'; write_din <= '1'; din <= "11010011"; wait for 100 ns ;
	  report "End of test";
      wait ;
	  
   end process ;

end arc_tb_pipe ;

--assert ( q = '1' and q_bar = '0')
		--report "loading '1' to latch"
		--severity error;