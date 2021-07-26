library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity tb_timer is
   
end tb_timer ;

architecture arc_tb_timer of tb_timer is

	component timer is
	
	port ( resetN : in    std_logic 					  ;
		   clk 	  : in    std_logic 					  ;
		   te     : in    std_logic 					  ;
		   t1     : out   std_logic 					  ;
		   tcount : inout std_logic_vector ( 8 downto 0 ) ) ;
		   
	end component timer ;
	
	signal resetN : std_logic 					    ;
	signal clk 	  : std_logic 					    ;
	signal te     : std_logic 					    ;
	signal t1     : std_logic 					    ;
	signal tcount : std_logic_vector ( 8 downto 0 ) ;
	
begin
   
   eut: timer
		port map ( resetN, clk, te, t1, tcount ) ;
   
   resetN <= '0' , '1' after 100 ns ;
   
   process
   
   begin
   
      clk <= '0' ;  wait for 50 ns ;
      clk <= '1' ;  wait for 50 ns ;
	  
   end process ;

   process
   
   begin
   
      te <= '0'; wait for 100 ns ;
	  te <= '1'; wait for 500 ns ;
	  te <= '0'; wait for 100 ns ;
	  te <= '1'; wait for 25000 ns ;
	  te <= '0'; wait for 300 ns ;
	  report "End of test";
      wait ;
	  
   end process ;

end arc_tb_timer ;

--assert ( q = '1' and q_bar = '0')
		--report "loading '1' to latch"
		--severity error;