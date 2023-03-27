`timescale 1ns/1ns

//`define SYNTHESIS	// conditional compilation flag for synthesis
//`define FWDALL		// conditional compilation flag to forward cells

`define TxPorts 4  // set number of transmit ports
`define RxPorts 4  // set number of receive ports


module top;

    parameter int NumRx = `RxPorts;
    parameter int NumTx = `TxPorts;

    logic rst_n, clk;

    // System Clock and Reset
    initial begin
        rst_n = 1;
        #500
        rst_n = 0;
        #500
        rst_n = 1;

    end

    initial begin
        clk = 0;
        forever 
            #5ns clk = ~clk;
    end


    Utopia Rx[0:NumRx-1] (clk);	// NumRx x Level 1 Utopia Rx Interface
    Utopia Tx[0:NumTx-1] (clk);	// NumTx x Level 1 Utopia Tx Interface
    cpu_ifc mif();	  // Intel-style Utopia parallel management interface
        
    squat4_NNI squat(			
                    .clk                 ( clk                    ), 
                    .rst_n               ( rst_n                  ),	
                    
                    .BusMode             ( mif.BusMode            ),
                    .Addr                ( mif.Addr               ), 
                    .Sel                 ( mif.Sel                ), 
                    .DataIn              ( mif.DataIn             ), 
                    .Rd_DS               ( mif.Rd_DS              ), 
                    .Wr_RW               ( mif.Wr_RW              ),
                    .DataOut             ( mif.DataOut            ), 
                    .Rdy_Dtack           ( mif.Rdy_Dtack          ),
                    
                    .rx0_soc             ( Rx[0].soc              ),
                    .rx0_data            ( Rx[0].data             ),
                    .rx0_clav            ( Rx[0].clav             ),
                    .rx0_en              ( Rx[0].en               ),
                    
                    .rx1_soc             ( Rx[1].soc              ),
                    .rx1_data            ( Rx[1].data             ),
                    .rx1_clav            ( Rx[1].clav             ),
                    .rx1_en              ( Rx[1].en               ),
                    
                    .rx2_soc             ( Rx[2].soc              ),
                    .rx2_data            ( Rx[2].data             ),
                    .rx2_clav            ( Rx[2].clav             ),
                    .rx2_en              ( Rx[2].en               ),
                
                    .rx3_soc             ( Rx[3].soc              ),
                    .rx3_data            ( Rx[3].data             ),
                    .rx3_clav            ( Rx[3].clav             ),
                    .rx3_en              ( Rx[3].en               ),
                    
                    .tx0_soc             ( Tx[0].soc              ),
                    .tx0_data            ( Tx[0].data             ),
                    .tx0_en              ( Tx[0].en               ),
                    .tx0_clav            ( Tx[0].clav             ),
                
                    .tx1_soc             ( Tx[1].soc              ),
                    .tx1_data            ( Tx[1].data             ),
                    .tx1_en              ( Tx[1].en               ),
                    .tx1_clav            ( Tx[1].clav             ),
                
                    .tx2_soc             ( Tx[2].soc              ),
                    .tx2_data            ( Tx[2].data             ),
                    .tx2_en              ( Tx[2].en               ),
                    .tx2_clav            ( Tx[2].clav             ),
                    
                    .tx3_soc             ( Tx[3].soc              ),
                    .tx3_data            ( Tx[3].data             ),
                    .tx3_en              ( Tx[3].en               ),
                    .tx3_clav            ( Tx[3].clav             )
                    );	// DUT
                    
    test  #(NumRx, NumTx) t1(Rx, Tx, mif, clk, rst_n);	// Test




    initial begin

            $vcdpluson; 
        $timeformat(-9, 1, "ns", 10);
        //$fsdbDumpvars;
        
    end


endmodule : top
