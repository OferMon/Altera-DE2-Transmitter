library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity tb_dffx is
   
end tb_dffx ;

architecture arc_tb_dffx of tb_dffx is

	component dffx is
	
	port ( resetN : in  std_logic ;
		   clk 	  : in  std_logic ;
		   clr_tx : in  std_logic ;
		   set_tx : in  std_logic ;
		   ena_tx : in  std_logic ;
		   din 	  : in  std_logic ;
		   tx     : out std_logic ) ;
		   
	end component dffx ;
	
	signal resetN : std_logic ;
	signal clk 	  : std_logic ;
	signal clr_tx : std_logic ;
	signal set_tx : std_logic ;
	signal ena_tx : std_logic ;
	signal din 	  : std_logic ;
	signal tx     : std_logic ;
	
begin
   
   eut: dffx
		port map ( resetN, clk, clr_tx, set_tx, ena_tx, din, tx ) ;
   
   resetN <= '0' , '1' after 100 ns ;
   
   process
   
   begin
   
      clk <= '0' ;  wait for 50 ns ;
      clk <= '1' ;  wait for 50 ns ;
	  
   end process ;

   process
   
   begin
   
      din <= '1'; ena_tx <= '0'; clr_tx <= '0'; set_tx <= '0'; wait for 100 ns ;
	  din <= '1'; ena_tx <= '0'; clr_tx <= '0'; set_tx <= '1'; wait for 100 ns ;
	  din <= '1'; ena_tx <= '0'; clr_tx <= '1'; set_tx <= '0'; wait for 100 ns ;
	  din <= '1'; ena_tx <= '0'; clr_tx <= '1'; set_tx <= '1'; wait for 100 ns ;
	  din <= '1'; ena_tx <= '1'; clr_tx <= '0'; set_tx <= '0'; wait for 100 ns ;
	  din <= '1'; ena_tx <= '1'; clr_tx <= '0'; set_tx <= '1'; wait for 100 ns ;
	  din <= '1'; ena_tx <= '1'; clr_tx <= '1'; set_tx <= '0'; wait for 100 ns ;
	  din <= '1'; ena_tx <= '1'; clr_tx <= '1'; set_tx <= '1'; wait for 100 ns ;
	  report "End of test";
      wait ;
	  
   end process ;

end arc_tb_dffx ;

--assert ( q = '1' and q_bar = '0')
		--report "loading '1' to latch"
		--severity error;