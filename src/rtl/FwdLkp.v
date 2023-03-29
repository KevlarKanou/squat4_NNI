
module FwdLkp (
                clk        ,
				rst_n      ,
                BusMode    , 
				Addr       , 
				Sel        , 
				DataIn     , 
				Rd_DS      , 
				Wr_RW      ,
		        DataOut    , 
				Rdy_Dtack  ,
				
				fwd_rden   ,
				fwd_addr   ,
				fwd_data
			
              );

////////////////////////////////////////////////
input           clk        ;
input           rst_n      ;
			  
input           BusMode    ; 
input  [7:0]    Addr       ;
input           Sel        ;
input  [15:0]   DataIn     ; 
input           Rd_DS      ; 
input           Wr_RW      ;
output [15:0]   DataOut    ;
output          Rdy_Dtack  ;

input           fwd_rden   ;
input  [7:0]    fwd_addr   ;
output [15:0]   fwd_data   ;

///////////////////////////////////////////////////////////////////////////



  wire  [2:0]   WriteCycle = 3'b010 ;
  wire  [2:0]   ReadCycle  = 3'b001 ;
			    
  wire          host_wren  = BusMode & ({Sel, Rd_DS, Wr_RW} == WriteCycle) ;
  wire          host_rden  = BusMode & ({Sel, Rd_DS, Wr_RW} == ReadCycle ) ;
			    
  wire          Rdy_Dtack  = (host_wren || host_rden) ? 1'b0 : 1'b1 ;
  wire  [7:0]   host_addr  = Addr       ;
  wire  [15:0]  host_wdata = DataIn     ;
  wire  [15:0]  host_rdata              ;
  assign        DataOut    = host_rdata ;
  

LookupTable #(.Asize(8)) lut ( 
                              .clk            ( clk          ),
			      .rst_n          ( rst_n        ),
					          .host_wren      ( host_wren    ),
					          .host_rden      ( host_rden    ),
                                                  .host_addr      ( host_addr    ),
					          .host_wdata     ( host_wdata   ),
					          .host_rdata     ( host_rdata   ),
					          .fwd_rden       ( fwd_rden     ),
					          .fwd_addr       ( fwd_addr     ),
					          .fwd_rdata      ( fwd_data     )
                             );

/////////////////////////////////////////////////////////////////////////

endmodule			  
