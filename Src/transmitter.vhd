--package uart_constants is

--   constant clockfreq  : integer := 25000000 ;
--   constant baud       : integer := 115200   ;
--   constant t1_count   : integer := clockfreq / baud ; -- 217
--   constant t2_count   : integer := t1_count / 2     ; -- 108

--end uart_constants ;

-------------------------------------------------------------------------------------

use work.uart_constants.all ;
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity transmitter is

    port ( resetN    : in  std_logic                    ;
           clk       : in  std_logic                    ;
           write_din : in  std_logic                    ;
           din       : in  std_logic_vector(7 downto 0) ;
           tx        : out std_logic                    ;
           tx_ready  : out std_logic                    ) ;
		   
end transmitter ;

architecture arc_transmitter of transmitter is

   component timer is
   
        port ( resetN : in    std_logic 					  ;
   		       clk 	  : in    std_logic 					  ;
   		       te     : in    std_logic 					  ;
   		       t1     : out   std_logic 					  ;
   		       tcount : inout std_logic_vector ( 8 downto 0 ) ) ;
   		   
   end component timer ;
   
   component pipe is

	    port ( resetN    : in    std_logic 				      ;
	    	   clk 	     : in    std_logic 				      ;
	    	   ena_shift : in    std_logic 				      ;
	    	   ena_load  : in    std_logic 				      ;
	    	   write_din : in    std_logic 				      ;
	    	   din	     : in    std_logic_vector(7 downto 0) ;
	    	   dint 	 : inout std_logic_vector(7 downto 0) ) ;
		   
   end component pipe;
   
   component dffx is

	    port ( resetN : in  std_logic ;
	    	   clk 	  : in  std_logic ;
	    	   clr_tx : in  std_logic ;
	           set_tx : in  std_logic ;
	           ena_tx : in  std_logic ;
	    	   din 	  : in  std_logic ;
	    	   tx     : out std_logic ) ;
		   
   end component dffx;
   
   component datacounter is

	    port ( resetN     : in    std_logic 				   ;
	    	   clk 	      : in    std_logic 				   ;
	    	   ena_dcount : in    std_logic                    ;
	           clr_dcount : in    std_logic                    ;
	           eoc        : out   std_logic                    ;
	    	   dcount     : inout std_logic_vector(2 downto 0) ) ;
		   
   end component datacounter;
   
   -- timer            floor(log2(t1_count)) downto 0
   signal tcount : std_logic_vector(8 downto 0) ;
   signal te     : std_logic ; -- Timer_Enable/!reset
   signal t1     : std_logic ; -- end of one time slot

   -- data counter
   signal dcount     : std_logic_vector(2 downto 0) ; -- data counter
   signal ena_dcount : std_logic                    ; -- enable this counter
   signal clr_dcount : std_logic                    ; -- clear this counter
   signal eoc        : std_logic                    ; -- end of count (7)

   -- shift register
   signal dint      : std_logic_vector(7 downto 0) ;
   signal ena_shift : std_logic                    ; -- enable shift register
   signal ena_load  : std_logic                    ; -- enable parallel load

   -- output flip-flop --
   signal clr_tx : std_logic ; -- clear  tx during start bit
   signal set_tx : std_logic ; -- set    tx during stop  bit
   signal ena_tx : std_logic ; -- enable tx from shift register during data transfer

  -- state machine
   type state is
   ( idle             ,
     write_din_start  ,
     clear_timer      ,
     write_din_data   ,
     test_eoc         ,
     shift_count      ,
     write_din_stop   ) ;

    signal present_state , next_state : state ;

begin

   -------------------
   -- state machine --
   -------------------
   process ( clk , resetN )
   
   begin
     
      if resetN = '0' then
	     present_state <= idle ;
      elsif rising_edge(clk) then
	     present_state <= next_state ;
	  end if ;
	  
   end process ;
   
   process ( present_state, write_din , din, t1, eoc )
   
   begin
   
   tx_ready   <= '0' ;
   te         <= '0' ;
   ena_dcount <= '0' ;
   clr_dcount <= '0' ;
   ena_shift  <= '0' ;
   ena_load   <= '0' ;
   clr_tx     <= '0' ;
   set_tx     <= '0' ;
   ena_tx     <= '0' ;
   
   next_state <= idle ;
   
   case present_state is
   
      when idle =>
	  
	     tx_ready <= '1' ;
		 ena_load <= '1' ;
		 clr_dcount <= '1' ;
	     if write_din = '1' then
		    next_state <= write_din_start ;
		 else
		    next_state <= idle ;
		 end if ;
			
	  when write_din_start =>
	     
		 clr_tx <= '1';
		 te <= '1' ;
		 if t1 = '1' then
		    next_state <= clear_timer ;
		 elsif t1 = '0' then
		    next_state <= write_din_start ;
		 else
		    next_state <= idle ;
		 end if ;
			
	  when clear_timer =>
	     
		 next_state <= write_din_data ;

      when write_din_data =>
	     
		 ena_tx <= '1' ;
		 te <= '1' ;
		 if t1 = '1' then
		    next_state <= test_eoc ;
		 elsif t1 = '0' then
		    next_state <= write_din_data ;
		 else
		    next_state <= idle ;
		 end if ;
		
	  when test_eoc =>
	     
		 if eoc = '1' then
		    next_state <= write_din_stop ;
		 elsif eoc = '0' then
		    next_state <= shift_count ;
		 else
		    next_state <= idle ;
		 end if ;
			
	  when shift_count =>
	     
		 ena_shift <= '1' ;
		 ena_dcount <= '1' ;
		 next_state <= write_din_data ;
		 
	  when write_din_stop =>
	     
		 set_tx <= '1' ;
		 te <= '1' ;
         if t1 = '0' then
		    next_state <= write_din_stop ;
		 else
		    next_state <= idle ;
		 end if ;
   
	  when others =>
		
		 next_state <= idle ;
		 
	end case ;
   
   end process ;
   
   -----------
   -- timer --
   -----------
   u0: timer
       port map(resetN, clk, te, t1, tcount) ;
	   
   ------------------
   -- data counter --
   ------------------
   u1: datacounter
       port map(resetN, clk, ena_dcount, clr_dcount, eoc, dcount) ;
	   
   --------------------
   -- shift register --
   --------------------
   u2: pipe
       port map(resetN, clk, ena_shift, ena_load, write_din, din, dint) ;
	   
   ----------------------
   -- output flip-flop --
   ----------------------
   u3: dffx
       port map(resetN, clk, clr_tx, set_tx, ena_tx, dint(0), tx) ;

end arc_transmitter ;