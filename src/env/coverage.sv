

`ifndef COVERAGE__SV
`define COVERAGE__SV

class Coverage;

   bit [1:0] src;
   bit [NumTx-1:0] fwd;
   event cov_done ;
   real coverage_result = 0.0;

   covergroup CG_Forward;

      coverpoint src
	    {bins src[] = {[0:3]};
	       option.weight = 0;}
      coverpoint fwd
	   {bins fwd[] = {[0:15]};
	       option.weight = 0;}
      cross src, fwd;

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
      if(coverage_result > 80) begin
         ->this.cov_done ;
         $display("!!!!!!!!!!!!!!!!!!! coverage done !!!!!!!!!!!!!!!!!!!!!!!!!!!");
      end        	 
   endfunction : sample

endclass : Coverage


`endif // COVERAGE__SV
