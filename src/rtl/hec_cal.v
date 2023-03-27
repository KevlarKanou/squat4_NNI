
module hec_cal(
               hec_in ,
			   hec_out
               );

input   [31:0] hec_in  ;
output  [7:0]  hec_out ;

   //////////////////////////////////////////////////////////
   /////////// Generate the CRC-8 syndrom table /////////////
   //////////////////////////////////////////////////////////
   reg  [7:0] syndrom[0:255];
   reg  [7:0] sndrm;
   
   integer    i ;
   initial begin

     for (i=0; i<256; i++) begin
	   sndrm = i;
	   repeat (8) begin
	     if (sndrm[7] == 1'b1)
              sndrm = (sndrm << 1) ^ 8'h07;
	     else
              sndrm = sndrm << 1;
	   end
	   syndrom[i] = sndrm;
     end
   end



  //
  // Function to compute the HEC value
  //
 /*
  function hec ;
    input  [31:0]  hdr ;
    reg   [7:0]   RtnCode = 8'h00;
    repeat (4) begin
      RtnCode = syndrom[RtnCode ^ hdr[31:24]];
      hdr = hdr << 8;
    end
    RtnCode = RtnCode ^ 8'h55;
    return RtnCode;
  endfunction
 */
  
  /* .................... CRC ................ */
  wire [31:0] hdr = hec_in;
  wire [7:0]  RtnCode0 = syndrom[hdr[31:24]];
  wire [7:0]  RtnCode1 = syndrom[RtnCode0 ^ hdr[23:16]];
  wire [7:0]  RtnCode2 = syndrom[RtnCode1 ^ hdr[15:8]];
  wire [7:0]  RtnCode3 = syndrom[RtnCode2 ^ hdr[7:0]];
  wire [7:0]  RtnCode = RtnCode3 ^ 8'h55;

  assign   hec_out = RtnCode ;

  
endmodule  
