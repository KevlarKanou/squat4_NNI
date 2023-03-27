
`ifndef MONITOR__SV
`define MONITOR__SV

//`include "atm_cell.sv"

typedef class Monitor;


/////////////////////////////////////////////////////////////////////////////
// Monitor callback class
// Simple callbacks that are called before and after a cell is transmitted
// This class has empty tasks, which are used by default
// A testcase can extend this class to inject new behavior in the monitor
// without having to change any code in the monitor
class Monitor_cbs;
   virtual task post_rx(input Monitor mon,
		                input UNI_cell ucell);
   endtask : post_rx
endclass : Monitor_cbs

/////////////////////////////////////////////////////////////////////////////
class Monitor;

   vUtopiaTx Tx;		// Virtual interface with output of DUT
   Monitor_cbs cbsq[$];		// Queue of callback objects
   int PortID;

   extern function new(input vUtopiaTx Tx, input int PortID);
   extern task run();
   extern task receive (output UNI_cell ucell);
endclass : Monitor


//---------------------------------------------------------------------------
// new(): construct an object
//---------------------------------------------------------------------------
function Monitor::new(input vUtopiaTx Tx, input int PortID);
   this.Tx     = Tx;
   this.PortID = PortID;
endfunction : new

//---------------------------------------------------------------------------
// run(): Run the monitor
//---------------------------------------------------------------------------
task Monitor::run();
   UNI_cell ucell;
      
   forever begin
      receive(ucell);
      foreach (cbsq[i])
	      cbsq[i].post_rx(this, ucell);// Post-receive callback
   end
endtask : run


//---------------------------------------------------------------------------
// receive(): Read a cell from the DUT output, pack it into a NNI cell
//---------------------------------------------------------------------------
task Monitor::receive(output UNI_cell ucell);
 
   ATMCellType pkt_cmp;
   
   int j = 0 ;
   Tx.cbt.clav <= 1;
   
      wait(Tx.cbt.en);
      wait(Tx.cbt.soc);
      while (j<=52) begin
         if (Tx.cbt.en == 1'b1)begin
            pkt_cmp.Mem[j] = Tx.cbt.data ;
            @(Tx.cbt);
            j = j + 1 ;
         end
         else begin 
            @(Tx.cbt);
         end
      end
      j = 0 ;
      
      ucell=new();
      ucell.unpack(pkt_cmp);

endtask : receive

`endif // MONITOR__SV
