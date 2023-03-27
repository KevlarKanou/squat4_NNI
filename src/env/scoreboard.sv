
`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV

//`include "atm_cell.sv"

class Expect_cells;
   UNI_cell q[$];
   int iexpect, iactual;
endclass : Expect_cells


class Scoreboard;

   Config cfg ;
   Expect_cells expect_cells[];
   NNI_cell cellq[$];
   int iexpect, iactual;

   extern function new(Config cfg);
   extern virtual function void wrap_up();
   extern function void save_expected(NNI_cell ncell);
   extern function void check_actual(input UNI_cell ucell, input int portn);
   extern function void display(string prefix="");
   
endclass : Scoreboard


//---------------------------------------------------------------------------
function Scoreboard::new(Config cfg);
   this.cfg = cfg;
   expect_cells = new[cfg.numTx];
   foreach (expect_cells[i])
     expect_cells[i] = new();
endfunction // Scoreboard


//---------------------------------------------------------------------------
function void Scoreboard::save_expected(NNI_cell ncell);

    CellCfgType CellFwd = env.cpu.lookup[ncell.VPI[7:0]] ;
    UNI_cell n2ucell;
    n2ucell = new();
    n2ucell = ncell.to_UNI(CellFwd.VPI);

   $display("@%0t: Scb save: VPI=%0x, Forward=%b", $time, CellFwd.VPI, CellFwd.FWD);

    for (int i=0; i<cfg.numTx; i++)
         if (CellFwd.FWD[i]) begin
	        expect_cells[i].q.push_back(n2ucell); // Save cell in this forward queue
	        expect_cells[i].iexpect++;
	        iexpect++;
         end
	 
endfunction : save_expected


//-----------------------------------------------------------------------------
function void Scoreboard::check_actual(input UNI_cell ucell, input int portn);
			
   //ncell.display($psprintf("@%0t: Scb check: ", $time));
			
   if (expect_cells[portn].q.size() == 0) begin
      $display("@%0t: ERROR: %m cell not found because scoreboard for TX%0d empty", $time, portn);
      ucell.display("Not Found: ");
      return;
   end
   
   expect_cells[portn].iactual++;
   iactual++;

   foreach (expect_cells[portn].q[i]) begin
      if (expect_cells[portn].q[i].compare(ucell)) begin
	     //$display("@%0t: Match found for cell", $time);
	     //$display("@%0t: Packet %m Successfully Compare !!!!", $time,ncell);
	     $display("@%0t: Packet Successfully Compare !!!!", $time);
	     expect_cells[portn].q.delete(i);
	     return;
      end
   end

   //$display("@%0t: ERROR: %m cell not found", $time,ncell);
   //$display("@%0t: Packet %m Compare Fail !!!", $time,ncell);
   $display("@%0t: Packet Compare Fail !!!", $time);
   //$display("@%0t: Packet %d Cell is %m !!!", $time,iactual,ncell);
   ucell.display("Not Found: ");
   $finish; 
					   
 
endfunction : check_actual


//---------------------------------------------------------------------------
// Print end of simulation report
//---------------------------------------------------------------------------
function void Scoreboard::wrap_up();
   $display("@%0t: %m %0d expected cells, %0d actual cells received", $time, iexpect, iactual);

   // Look for leftover cells
   foreach (expect_cells[i]) begin
      if (expect_cells[i].q.size()) begin
	     $display("@%0t: %m cells remaining in Tx[%0d] scoreboard at end of test", $time, i);
	     this.display("Unclaimed: ");
	  end
   end
endfunction : wrap_up


//---------------------------------------------------------------------------
// Print the contents of the scoreboard, mainly for debugging
//---------------------------------------------------------------------------
function void Scoreboard::display(string prefix);
   $display("@%0t: %m so far %0d expected cells, %0d actual cells received", $time, iexpect, iactual);
   foreach (expect_cells[i]) begin
      $display("Tx[%0d]: exp=%0d, act=%0d", i, expect_cells[i].iexpect, expect_cells[i].iactual);
      foreach (expect_cells[i].q[j])
	     expect_cells[i].q[j].display($psprintf("%sScoreboard: Tx%0d: ", prefix, i));
   end
endfunction : display

`endif
