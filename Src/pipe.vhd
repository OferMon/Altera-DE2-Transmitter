library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity pipe is

	port ( resetN    : in    std_logic 				      ;
		   clk 	     : in    std_logic 				      ;
		   ena_shift : in    std_logic 				      ;
		   ena_load  : in    std_logic 				      ;
		   write_din : in    std_logic 				      ;
		   din	     : in    std_logic_vector(7 downto 0) ;
		   dint 	 : inout std_logic_vector(7 downto 0) ) ;
		   
end pipe;

architecture arc_pipe of pipe is

begin

	process ( resetN, clk )
	
	begin
	
	   if resetN = '0' then
	      dint <= ( others => '0' ) ;
	   elsif rising_edge(clk) then
	      if write_din = '1' and ena_load = '1' then
		     dint <= din ;
		  elsif ena_shift = '1' then
		     dint <= '0' & dint( 7 downto 1 ) ;
		  end if ;
	   end if ;
	   
	end process ;
	
end arc_pipe;