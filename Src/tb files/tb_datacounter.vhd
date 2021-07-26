library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity tb_datacounter is
   
end tb_datacounter ;

architecture arc_tb_datacounter of tb_datacounter is

	component datacounter is
	
	port ( resetN     : in    std_logic 				   ;
		   clk 	      : in    std_logic 				   ;
		   ena_dcount : in    std_logic                    ;
		   clr_dcount : in    std_logic                    ;
		   eoc        : out   std_logic                    ;
		   dcount     : inout std_logic_vector(2 downto 0) ) ;
		   
		   
	end component datacounter ;
	
	signal resetN     : std_logic 				     ;
	signal clk 	      : std_logic 				     ;
	signal ena_dcount : std_logic                    ;
	signal clr_dcount : std_logic                    ;
	signal eoc        : std_logic                    ;
	signal dcount     : std_logic_vector(2 downto 0) ;
	
begin
   
   eut: datacounter
		port map ( resetN, clk, ena_dcount, clr_dcount, eoc, dcount ) ;
   
   resetN <= '0' , '1' after 100 ns ;
   
   process
   
   begin
   
      clk <= '0' ;  wait for 50 ns ;
      clk <= '1' ;  wait for 50 ns ;
	  
   end process ;

   process
   
   begin
   
      ena_dcount <= '0'; clr_dcount <= '0'; wait for 100 ns ;
	  ena_dcount <= '0'; clr_dcount <= '1'; wait for 100 ns ;
	  ena_dcount <= '1'; clr_dcount <= '0'; wait for 900 ns ;
	  ena_dcount <= '1'; clr_dcount <= '1'; wait for 100 ns ;
	  report "End of test";
      wait ;
	  
   end process ;

end arc_tb_datacounter ;

--assert ( q = '1' and q_bar = '0')
		--report "loading '1' to latch"
		--severity error;