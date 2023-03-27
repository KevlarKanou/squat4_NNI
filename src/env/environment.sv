`ifndef ENVIRONMENT__SV
`define ENVIRONMENT__SV


`include "../src/env/generator.sv"
`include "../src/env/driver.sv"
`include "../src/env/monitor.sv"
`include "../src/env/config.sv"
`include "../src/env/scoreboard.sv"
`include "../src/env/coverage.sv"
`include "../src/env/cpu_driver.sv"


/////////////////////////////////////////////////////////
// Call scoreboard from Driver using callbacks
/////////////////////////////////////////////////////////
class Scb_Driver_cbs extends Driver_cbs;
   Scoreboard scb;

   function new(Scoreboard scb);
      this.scb = scb;
   endfunction : new

   // Send received cell to scoreboard
   virtual task post_tx(input Driver drv,
                input NNI_cell ncell);
   scb.save_expected(ncell);
   endtask : post_tx
endclass : Scb_Driver_cbs


/////////////////////////////////////////////////////////
// Call scoreboard from Monitor using callbacks
/////////////////////////////////////////////////////////
class Scb_Monitor_cbs extends Monitor_cbs;
   Scoreboard scb;

   function new(Scoreboard scb);
      this.scb = scb;
   endfunction : new

   // Send received cell to scoreboard
   virtual task post_rx(input Monitor mon,
                input UNI_cell ucell);
   scb.check_actual(ucell, mon.PortID);
   endtask : post_rx
endclass : Scb_Monitor_cbs


/////////////////////////////////////////////////////////
// Call coverage from Monitor using callbacks
/////////////////////////////////////////////////////////
class Cov_Monitor_cbs extends Monitor_cbs;
   Coverage cov;

   function new(Coverage cov);
      this.cov = cov;
   endfunction : new

   // Send received cell to coverage
   virtual task post_rx(input Monitor mon,
                input UNI_cell ucell);
      //CellCfgType CellCfg = top.squat.fwdtable.lut.read(ncell.VPI);
      CellCfgType CellCfg = top.squat.u_FwdLkp.lut.Mem[ucell.VPI];
      cov.sample(mon.PortID, CellCfg.FWD);
   endtask : post_rx
endclass : Cov_Monitor_cbs



/////////////////////////////////////////////////////////
class Environment;
   NNI_generator gen[];
   mailbox gen2drv[];
   event   drv2gen[];
   Driver drv[];
   Monitor mon[];
   Config cfg;
   Scoreboard scb;
   Coverage cov;
   virtual Utopia.TB_Rx Rx[];
   virtual Utopia.TB_Tx Tx[];
   int numRx, numTx;
   vCPU_T mif;
   CPU_driver cpu;

   extern function new(input vUtopiaRx Rx[],
               input vUtopiaTx Tx[],
               input int numRx, numTx,
               input vCPU_T mif);
   extern virtual function void gen_cfg();
   extern virtual function void build();
   extern virtual task run();
   extern virtual function void wrap_up();
   extern virtual task reset();
   extern virtual task wait_for_end();

endclass : Environment


//---------------------------------------------------------------------------
// Construct an environment instance
//---------------------------------------------------------------------------
function Environment::new(input vUtopiaRx Rx[],
              input vUtopiaTx Tx[],
              input int numRx, numTx,
              input vCPU_T mif);
   this.Rx = new[Rx.size()];
   foreach (Rx[i]) this.Rx[i] = Rx[i];
   this.Tx = new[Tx.size()];
   foreach (Tx[i]) this.Tx[i] = Tx[i];
   this.numRx = numRx;
   this.numTx = numTx;
   this.mif = mif;

   cfg = new(numRx,numTx);

   if ($test$plusargs("ntb_random_seed")) begin
      int seed;
      $value$plusargs("ntb_random_seed=%d", seed);
      $display("Simulation run with random seed=%0d", seed);
   end
   else
     $display("Simulation run with default random seed");
   
endfunction : new


//---------------------------------------------------------------------------
// Randomize the configuration descriptor
//---------------------------------------------------------------------------
function void Environment::gen_cfg();
   assert(cfg.randomize());
   cfg.display();
endfunction : gen_cfg


//---------------------------------------------------------------------------
// Build the environment objects for this test
// Note that objects are built for every channel, even if they are not in use
// This prevents the bug when you use a null handle
//---------------------------------------------------------------------------
function void Environment::build();

   //cpu = new(mif, cfg);
   cpu = new(mif);

   gen = new[numRx];
   drv = new[numRx];
   gen2drv = new[numRx];
   drv2gen = new[numRx];
   //scb = new(cfg);
   scb = new(cfg);
   cov = new();
   
   foreach(gen[i]) begin
      gen2drv[i] = new();
      gen[i] = new(gen2drv[i], drv2gen[i], cfg.cells_per_chan[i], i);
      drv[i] = new(gen2drv[i], drv2gen[i], Rx[i], i);
   end

   mon = new[numTx];
   foreach (mon[i])
     mon[i] = new(Tx[i], i);

   // Connect the scoreboard with callbacks
   begin
      Scb_Driver_cbs sdc = new(scb);
      Scb_Monitor_cbs smc = new(scb);
      foreach (drv[i]) drv[i].cbsq.push_back(sdc);  // Add scb to every driver
      foreach (mon[i]) mon[i].cbsq.push_back(smc);  // Add scb to every monitor
   end

   // Connect coverage with callbacks
   begin
      Cov_Monitor_cbs smc = new(cov);
      foreach (mon[i]) mon[i].cbsq.push_back(smc);  // Add cov to every monitor
   end

endfunction : build


//---------------------------------------------------------------------------
// Start the transactors (generators, drivers, monitors) in the environment
// Channels that are not in use don't get started
//---------------------------------------------------------------------------
task Environment::run();
   int num_gen_running;

   // Let the CPU interface do its initialization before anyone else starts
   cpu.run();

   num_gen_running = numRx;

   // For each input RX channel, start generator and driver
   foreach(gen[i]) begin
      int j=i;		// Automatic variable to hold index in spawned threads
      fork
     begin
     if (cfg.in_use_Rx[j]) gen[j].run();	// Wait for generator to finish
        num_gen_running--;		// Decrement driver count
     end
     if (cfg.in_use_Rx[j]) drv[j].run();
      join_none
   end

   // For each output TX channel, start monitor
   foreach(mon[i]) begin
      int j=i;		// Automatic variable to hold index in spawned threads
      fork
     mon[j].run();
      join_none
   end

   wait_for_end();

endtask : run


//---------------------------------------------------------------------------
// Any post-run cleanup / reporting
//---------------------------------------------------------------------------
function void Environment::wrap_up();
   $display("@%0t: End of simulation, %0d error%s, %0d warning%s", 
        $time, cfg.nErrors, cfg.nErrors==1 ? "" : "s", cfg.nWarnings, cfg.nWarnings==1 ? "" : "s");
   scb.wrap_up;
   
endfunction : wrap_up


//---------------------------------------------------------------------------
// reset
//---------------------------------------------------------------------------

task Environment::reset();

  mif.BusMode <= 1'b0 ;
  mif.Addr    <= '0   ;
  mif.Sel     <= '1   ;
  mif.DataIn  <= '0   ;
  mif.Rd_DS   <= '1   ;
  mif.Wr_RW   <= '1   ;

  foreach(Rx[i]) begin
    Rx[i].cbr.data  <= 0   ;
    Rx[i].cbr.soc   <= 0   ;
    Rx[i].cbr.clav  <= 0   ;
  end
  
  foreach(Tx[i]) begin
    Tx[i].cbt.clav  <= 0   ;
  end

  @(posedge rst_n);

  repeat(15) @(posedge clk) ;

  mif.BusMode <= 1'b1    ;

  foreach(Rx[i]) begin
    Rx[i].cbr.clav  <= 1 ; 
  end

  foreach(Tx[i]) begin
    Tx[i].cbt.clav  <= 1   ;
  end
    
endtask: reset


//---------------------------------------------------------------------------
// wait_for_end
//---------------------------------------------------------------------------

task Environment::wait_for_end();
    
      fork : timeout_block
     begin
                  wait((cfg.cells_per_chan[0] == 0)||(cov.cov_done.triggered));
         end

         begin
            repeat (1_000_000) @(Rx[0].cbr);
            $display("@%0t: %m ERROR: Timeout while waiting for generators to finish", $time);
         end
      join_any
      disable timeout_block;

      repeat(5000) @(clk);

endtask: wait_for_end


`endif // ENVIRONMENT__SV
