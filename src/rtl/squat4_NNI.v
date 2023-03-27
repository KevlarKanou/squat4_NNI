
module squat4_NNI (
        input   wire               clk                   ,
        input   wire               rst_n                 ,


        input   wire               BusMode               ,
        input   wire   [11:0]      Addr                  ,
        input   wire               Sel                   ,
        input   wire   [15:0]      DataIn                ,
        input   wire               Rd_DS                 ,
        input   wire               Wr_RW                 ,
        output  wire   [15:0]      DataOut               ,
        output  wire               Rdy_Dtack             ,


        input   wire               rx0_soc               ,
        input   wire   [7:0]       rx0_data              ,
        input   wire               rx0_clav              ,
        output  wire               rx0_en                ,

        input   wire               rx1_soc               ,
        input   wire   [7:0]       rx1_data              ,
        input   wire               rx1_clav              ,
        output  wire               rx1_en                ,

        input   wire               rx2_soc               ,
        input   wire   [7:0]       rx2_data              ,
        input   wire               rx2_clav              ,
        output  wire               rx2_en                ,

        input   wire               rx3_soc               ,
        input   wire   [7:0]       rx3_data              ,
        input   wire               rx3_clav              ,
        output  wire               rx3_en                ,

        output  wire               tx0_soc               ,
        output  wire   [7:0]       tx0_data              ,
        output  wire               tx0_en                ,
        input   wire               tx0_clav              ,

        output  wire               tx1_soc               ,
        output  wire   [7:0]       tx1_data              ,
        output  wire               tx1_en                ,
        input   wire               tx1_clav              ,

        output  wire               tx2_soc               ,
        output  wire   [7:0]       tx2_data              ,
        output  wire               tx2_en                ,
        input   wire               tx2_clav              ,

        output  wire               tx3_soc               ,
        output  wire   [7:0]       tx3_data              ,
        output  wire               tx3_en                ,
        input   wire               tx3_clav
    );

    /////////////////////////////////////////////////////////////////////////

    wire                rx0_rxreq          ;
    wire                rx0_rxack          ;

    wire    [11:0]      rx0_nni_VPI        ;
    wire    [15:0]      rx0_nni_VCI        ;
    wire                rx0_nni_CLP        ;
    wire    [2:0]       rx0_nni_PT         ;
    wire    [7:0]       rx0_nni_HEC        ;
    wire    [8*48-1:0]  rx0_nni_Payload    ;

    utopia1_atm_rx u_utopia1_atm_rx0(
        //ports
        .clk         		( clk         		    ),
        .rst_n       		( rst_n       		    ),
        .soc         		( rx0_soc         		),
        .data        		( rx0_data        		),
        .clav        		( rx0_clav        		),
        .en          		( rx0_en          		),
        .rxreq       		( rx0_rxreq       		),
        .rxack       		( rx0_rxack       		),
        .nni_VPI     		( rx0_nni_VPI     		),
        .nni_VCI     		( rx0_nni_VCI     		),
        .nni_CLP     		( rx0_nni_CLP     		),
        .nni_PT      		( rx0_nni_PT      		),
        .nni_HEC     		( rx0_nni_HEC     		),
        .nni_Payload 		( rx0_nni_Payload 		)
    );

    wire                rx1_rxreq          ;
    wire                rx1_rxack          ;

    wire    [11:0]      rx1_nni_VPI        ;
    wire    [15:0]      rx1_nni_VCI        ;
    wire                rx1_nni_CLP        ;
    wire    [2:0]       rx1_nni_PT         ;
    wire    [7:0]       rx1_nni_HEC        ;
    wire    [8*48-1:0]  rx1_nni_Payload    ;

    utopia1_atm_rx u_utopia1_atm_rx1(
        //ports
        .clk         		( clk         		    ),
        .rst_n       		( rst_n       		    ),
        .soc         		( rx1_soc         		),
        .data        		( rx1_data        		),
        .clav        		( rx1_clav        		),
        .en          		( rx1_en          		),
        .rxreq       		( rx1_rxreq       		),
        .rxack       		( rx1_rxack       		),
        .nni_VPI     		( rx1_nni_VPI     		),
        .nni_VCI     		( rx1_nni_VCI     		),
        .nni_CLP     		( rx1_nni_CLP     		),
        .nni_PT      		( rx1_nni_PT      		),
        .nni_HEC     		( rx1_nni_HEC     		),
        .nni_Payload 		( rx1_nni_Payload 		)
    );

    wire                rx2_rxreq          ;
    wire                rx2_rxack          ;

    wire    [11:0]      rx2_nni_VPI        ;
    wire    [15:0]      rx2_nni_VCI        ;
    wire                rx2_nni_CLP        ;
    wire    [2:0]       rx2_nni_PT         ;
    wire    [7:0]       rx2_nni_HEC        ;
    wire    [8*48-1:0]  rx2_nni_Payload    ;

    utopia1_atm_rx u_utopia1_atm_rx2(
        //ports
        .clk         		( clk         		    ),
        .rst_n       		( rst_n       		    ),
        .soc         		( rx2_soc         		),
        .data        		( rx2_data        		),
        .clav        		( rx2_clav        		),
        .en          		( rx2_en          		),
        .rxreq       		( rx2_rxreq       		),
        .rxack       		( rx2_rxack       		),
        .nni_VPI     		( rx2_nni_VPI     		),
        .nni_VCI     		( rx2_nni_VCI     		),
        .nni_CLP     		( rx2_nni_CLP     		),
        .nni_PT      		( rx2_nni_PT      		),
        .nni_HEC     		( rx2_nni_HEC     		),
        .nni_Payload 		( rx2_nni_Payload 		)
    );

    wire                rx3_rxreq          ;
    wire                rx3_rxack          ;

    wire    [11:0]      rx3_nni_VPI        ;
    wire    [15:0]      rx3_nni_VCI        ;
    wire                rx3_nni_CLP        ;
    wire    [2:0]       rx3_nni_PT         ;
    wire    [7:0]       rx3_nni_HEC        ;
    wire    [8*48-1:0]  rx3_nni_Payload    ;

    utopia1_atm_rx u_utopia1_atm_rx3(
        //ports
        .clk         		( clk         		    ),
        .rst_n       		( rst_n       		    ),
        .soc         		( rx3_soc         		),
        .data        		( rx3_data        		),
        .clav        		( rx3_clav        		),
        .en          		( rx3_en          		),
        .rxreq       		( rx3_rxreq       		),
        .rxack       		( rx3_rxack       		),
        .nni_VPI     		( rx3_nni_VPI     		),
        .nni_VCI     		( rx3_nni_VCI     		),
        .nni_CLP     		( rx3_nni_CLP     		),
        .nni_PT      		( rx3_nni_PT      		),
        .nni_HEC     		( rx3_nni_HEC     		),
        .nni_Payload 		( rx3_nni_Payload 		)
    );

    /////////////////////////////////////////////////////////////////////////

    wire                tx0_txreq       ;
    wire                tx0_txack       ;

    wire    [3:0]       tx0_uni_GFC     ;   
    wire    [7:0]       tx0_uni_VPI     ;
    wire    [15:0]      tx0_uni_VCI     ;
    wire                tx0_uni_CLP     ;
    wire    [2:0]       tx0_uni_PT      ;
    wire    [7:0]       tx0_uni_HEC     ;
    wire    [8*48-1:0]  tx0_uni_Payload ;

    utopia1_atm_tx u_utopia1_atm_tx0(
        //ports
        .clk         		( clk         		),
        .rst_n       		( rst_n       		),
        .soc         		( tx0_soc         	),
        .data        		( tx0_data        	),
        .en          		( tx0_en          	),
        .clav        		( tx0_clav        	),
        .txreq       		( tx0_txreq       	),
        .txack       		( tx0_txack       	),
        .uni_GFC     		( tx0_uni_GFC     	),
        .uni_VPI     		( tx0_uni_VPI     	),
        .uni_VCI     		( tx0_uni_VCI     	),
        .uni_CLP     		( tx0_uni_CLP     	),
        .uni_PT      		( tx0_uni_PT      	),
        .uni_HEC     		( tx0_uni_HEC     	),
        .uni_Payload 		( tx0_uni_Payload 	)
    );

    wire                tx1_txreq       ;
    wire                tx1_txack       ;

    wire    [3:0]       tx1_uni_GFC     ;   
    wire    [7:0]       tx1_uni_VPI     ;
    wire    [15:0]      tx1_uni_VCI     ;
    wire                tx1_uni_CLP     ;
    wire    [2:0]       tx1_uni_PT      ;
    wire    [7:0]       tx1_uni_HEC     ;
    wire    [8*48-1:0]  tx1_uni_Payload ;

    utopia1_atm_tx u_utopia1_atm_tx1(
        //ports
        .clk         		( clk         		),
        .rst_n       		( rst_n       		),
        .soc         		( tx1_soc         	),
        .data        		( tx1_data        	),
        .en          		( tx1_en          	),
        .clav        		( tx1_clav        	),
        .txreq       		( tx1_txreq       	),
        .txack       		( tx1_txack       	),
        .uni_GFC     		( tx1_uni_GFC     	),
        .uni_VPI     		( tx1_uni_VPI     	),
        .uni_VCI     		( tx1_uni_VCI     	),
        .uni_CLP     		( tx1_uni_CLP     	),
        .uni_PT      		( tx1_uni_PT      	),
        .uni_HEC     		( tx1_uni_HEC     	),
        .uni_Payload 		( tx1_uni_Payload 	)
    );

    wire                tx2_txreq       ;
    wire                tx2_txack       ;

    wire    [3:0]       tx2_uni_GFC     ;   
    wire    [7:0]       tx2_uni_VPI     ;
    wire    [15:0]      tx2_uni_VCI     ;
    wire                tx2_uni_CLP     ;
    wire    [2:0]       tx2_uni_PT      ;
    wire    [7:0]       tx2_uni_HEC     ;
    wire    [8*48-1:0]  tx2_uni_Payload ;

    utopia1_atm_tx u_utopia1_atm_tx2(
        //ports
        .clk         		( clk         		),
        .rst_n       		( rst_n       		),
        .soc         		( tx2_soc         	),
        .data        		( tx2_data        	),
        .en          		( tx2_en          	),
        .clav        		( tx2_clav        	),
        .txreq       		( tx2_txreq       	),
        .txack       		( tx2_txack       	),
        .uni_GFC     		( tx2_uni_GFC     	),
        .uni_VPI     		( tx2_uni_VPI     	),
        .uni_VCI     		( tx2_uni_VCI     	),
        .uni_CLP     		( tx2_uni_CLP     	),
        .uni_PT      		( tx2_uni_PT      	),
        .uni_HEC     		( tx2_uni_HEC     	),
        .uni_Payload 		( tx2_uni_Payload 	)
    );

    wire                tx3_txreq       ;
    wire                tx3_txack       ;

    wire    [3:0]       tx3_uni_GFC     ;   
    wire    [7:0]       tx3_uni_VPI     ;
    wire    [15:0]      tx3_uni_VCI     ;
    wire                tx3_uni_CLP     ;
    wire    [2:0]       tx3_uni_PT      ;
    wire    [7:0]       tx3_uni_HEC     ;
    wire    [8*48-1:0]  tx3_uni_Payload ;

    utopia1_atm_tx u_utopia1_atm_tx3(
        //ports
        .clk         		( clk         		),
        .rst_n       		( rst_n       		),
        .soc         		( tx3_soc         	),
        .data        		( tx3_data        	),
        .en          		( tx3_en          	),
        .clav        		( tx3_clav        	),
        .txreq       		( tx3_txreq       	),
        .txack       		( tx3_txack       	),
        .uni_GFC     		( tx3_uni_GFC     	),
        .uni_VPI     		( tx3_uni_VPI     	),
        .uni_VCI     		( tx3_uni_VCI     	),
        .uni_CLP     		( tx3_uni_CLP     	),
        .uni_PT      		( tx3_uni_PT      	),
        .uni_HEC     		( tx3_uni_HEC     	),
        .uni_Payload 		( tx3_uni_Payload 	)
    );

    /////////////////////////////////////////////////////////////////////////

    wire                  fwd_rden   ;
    wire         [7:0]    fwd_addr   ;
    wire         [15:0]   fwd_data   ;

    FwdLkp u_FwdLkp(
        //ports
        .clk       		( clk       		),
        .rst_n     		( rst_n     		),

        .BusMode   		( BusMode   		),
        .Addr      		( Addr      		),
        .Sel       		( Sel       		),
        .DataIn    		( DataIn    		),
        .Rd_DS     		( Rd_DS     		),
        .Wr_RW     		( Wr_RW     		),
        .DataOut   		( DataOut   		),
        .Rdy_Dtack 		( Rdy_Dtack 		),

        .fwd_rden  		( fwd_rden  		),
        .fwd_addr  		( fwd_addr  		),
        .fwd_data  		( fwd_data  		)
    );

    /////////////////////////////////////////////////////////////////////////

    arbitor u_arbitor(
        //ports
        .clk             		( clk             		),
        .rst_n           		( rst_n           		),

        .fwd_rden        		( fwd_rden        		),
        .fwd_addr        		( fwd_addr        		),
        .fwd_data        		( fwd_data        		),

        .rx0_rxreq       		( rx0_rxreq       		),
        .rx0_rxack       		( rx0_rxack       		),
        .rx0_nni_VPI     		( rx0_nni_VPI     		),
        .rx0_nni_VCI     		( rx0_nni_VCI     		),
        .rx0_nni_CLP     		( rx0_nni_CLP     		),
        .rx0_nni_PT      		( rx0_nni_PT      		),
        .rx0_nni_HEC     		( rx0_nni_HEC     		),
        .rx0_nni_Payload 		( rx0_nni_Payload 		),

        .rx1_rxreq       		( rx1_rxreq       		),
        .rx1_rxack       		( rx1_rxack       		),
        .rx1_nni_VPI     		( rx1_nni_VPI     		),
        .rx1_nni_VCI     		( rx1_nni_VCI     		),
        .rx1_nni_CLP     		( rx1_nni_CLP     		),
        .rx1_nni_PT      		( rx1_nni_PT      		),
        .rx1_nni_HEC     		( rx1_nni_HEC     		),
        .rx1_nni_Payload 		( rx1_nni_Payload 		),

        .rx2_rxreq       		( rx2_rxreq       		),
        .rx2_rxack       		( rx2_rxack       		),
        .rx2_nni_VPI     		( rx2_nni_VPI     		),
        .rx2_nni_VCI     		( rx2_nni_VCI     		),
        .rx2_nni_CLP     		( rx2_nni_CLP     		),
        .rx2_nni_PT      		( rx2_nni_PT      		),
        .rx2_nni_HEC     		( rx2_nni_HEC     		),
        .rx2_nni_Payload 		( rx2_nni_Payload 		),

        .rx3_rxreq       		( rx3_rxreq       		),
        .rx3_rxack       		( rx3_rxack       		),
        .rx3_nni_VPI     		( rx3_nni_VPI     		),
        .rx3_nni_VCI     		( rx3_nni_VCI     		),
        .rx3_nni_CLP     		( rx3_nni_CLP     		),
        .rx3_nni_PT      		( rx3_nni_PT      		),
        .rx3_nni_HEC     		( rx3_nni_HEC     		),
        .rx3_nni_Payload 		( rx3_nni_Payload 		),

        .tx0_txreq       		( tx0_txreq       		),
        .tx0_txack       		( tx0_txack       		),
        .tx0_uni_GFC     		( tx0_uni_GFC     		),
        .tx0_uni_VPI     		( tx0_uni_VPI     		),
        .tx0_uni_VCI     		( tx0_uni_VCI     		),
        .tx0_uni_CLP     		( tx0_uni_CLP     		),
        .tx0_uni_PT      		( tx0_uni_PT      		),
        .tx0_uni_HEC     		( tx0_uni_HEC     		),
        .tx0_uni_Payload 		( tx0_uni_Payload 		),

        .tx1_txreq       		( tx1_txreq       		),
        .tx1_txack       		( tx1_txack       		),
        .tx1_uni_GFC     		( tx1_uni_GFC     		),
        .tx1_uni_VPI     		( tx1_uni_VPI     		),
        .tx1_uni_VCI     		( tx1_uni_VCI     		),
        .tx1_uni_CLP     		( tx1_uni_CLP     		),
        .tx1_uni_PT      		( tx1_uni_PT      		),
        .tx1_uni_HEC     		( tx1_uni_HEC     		),
        .tx1_uni_Payload 		( tx1_uni_Payload 		),

        .tx2_txreq       		( tx2_txreq       		),
        .tx2_txack       		( tx2_txack       		),
        .tx2_uni_GFC     		( tx2_uni_GFC     		),
        .tx2_uni_VPI     		( tx2_uni_VPI     		),
        .tx2_uni_VCI     		( tx2_uni_VCI     		),
        .tx2_uni_CLP     		( tx2_uni_CLP     		),
        .tx2_uni_PT      		( tx2_uni_PT      		),
        .tx2_uni_HEC     		( tx2_uni_HEC     		),
        .tx2_uni_Payload 		( tx2_uni_Payload 		),

        .tx3_txreq       		( tx3_txreq       		),
        .tx3_txack       		( tx3_txack       		),
        .tx3_uni_GFC     		( tx3_uni_GFC     		),
        .tx3_uni_VPI     		( tx3_uni_VPI     		),
        .tx3_uni_VCI     		( tx3_uni_VCI     		),
        .tx3_uni_CLP     		( tx3_uni_CLP     		),
        .tx3_uni_PT      		( tx3_uni_PT      		),
        .tx3_uni_HEC     		( tx3_uni_HEC     		),
        .tx3_uni_Payload 		( tx3_uni_Payload 		)
    );

endmodule
