library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity dffx is

	port ( resetN : in  std_logic ;
		   clk 	  : in  std_logic ;
		   clr_tx : in  std_logic ;
	       set_tx : in  std_logic ;
	       ena_tx : in  std_logic ;
		   din 	  : in  std_logic ;
		   tx     : out std_logic ) ;
		   
end dffx;

architecture arc_dffx of dffx is

begin

	process ( resetN, clk )
	
	begin
	
		if resetN = '0' then
		   tx <= '1' ;
		elsif rising_edge(clk) then
		   if clr_tx = '1' then
		      tx <= '0' ;
		   elsif set_tx = '1' then
		      tx <= '1' ;
		   elsif ena_tx = '1' then
		      tx <= din ; 
		   end if ;
		end if ;
		
	end process;
	
end arc_dffx;
