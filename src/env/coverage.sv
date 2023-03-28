

`ifndef COVERAGE__SV
`define COVERAGE__SV

class Coverage;

   bit [1:0] src;
   bit [NumTx-1:0] fwd;
   event cov_done ;
   real coverage_result = 0.0;

   // covergroup CG_Forward;

   //    coverpoint src
	//     {bins src[] = {[0:3]};
	//        option.weight = 0;}
   //    coverpoint fwd
	//    {bins fwd[] = {[1:15]}; // Ignore fwd==0
	//        option.weight = 0;}
   //    cross src, fwd;

   // endgroup : CG_Forward

   covergroup CG_Forward;

      x_cp: coverpoint src;
      y_cp: coverpoint fwd{
         bins fwd[] = {[1:15]}; // Ignore fwd==0
	      option.weight = 0;
      }
      x_y_cross : cross x_cp, y_cp{
         ignore_bins ignore_fwd = x_y_cross with (((y_cp >> x_cp) & 1) == 0);
         // Receiving data on a port indicates that fwd is 1 on the bit corresponding to that port.
         // For those cases that are 0, we must ignore them, and the determination of whether
         // they should not be received we do not make in coverage.
      }

   endgroup : CG_Forward

     // Instantiate the covergroup
     function new;
	   CG_Forward = new;
     endfunction : new

   // Sample input data
   function void sample(input bit [1:0] src,
			input bit [NumTx-1:0] fwd);
			
      $display("@%0t: Coverage: src=%d. FWD=%b", $time, src, fwd);
      this.src = src;
      this.fwd = fwd;
      CG_Forward.sample();
      coverage_result = $get_coverage();
      $display("###################################################################################");
      $display("@%0t: Coverage: src=%d. FWD=%b. Coverage = %3.2f", $time, src, fwd, coverage_result);
      $display("###################################################################################");
      if(coverage_result == 100) begin
         ->this.cov_done ;
         $display("!!!!!!!!!!!!!!!!!!! coverage done !!!!!!!!!!!!!!!!!!!!!!!!!!!");
      end        	 
   endfunction : sample

endclass : Coverage


`endif // COVERAGE__SV
