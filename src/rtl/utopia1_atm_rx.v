
module utopia1_atm_rx(
        input   wire                clk                ,
        input   wire                rst_n              ,

        input   wire                soc                ,
        input   wire    [7:0]       data               ,
        input   wire                clav               ,
        output  reg                 en                 ,

        output  reg                 rxreq              ,
        input   wire                rxack              ,

        output  reg     [11:0]      nni_VPI            ,
        output  reg     [15:0]      nni_VCI            ,
        output  reg                 nni_CLP            ,
        output  reg     [2:0]       nni_PT             ,
        output  reg     [7:0]       nni_HEC            ,
        output  reg     [8*48-1:0]  nni_Payload
    );

    ///////////////////////////////////////////////////

    reg        [5:0]       PayloadIndex   ;

    ///////////////////////////////////////////////////

    parameter   reset      = 4'h0   ,
                soc_frm    = 4'h1   ,
                vpi_vci    = 4'h2   ,
                vci        = 4'h3   ,
                vci_clp_pt = 4'h4   ,
                hec        = 4'h5   ,
                payload    = 4'h6   ,
                req        = 4'h7   ,
                ack        = 4'h8   ;

    reg    [3:0]           UtopiaStatus ;

    always @(posedge clk, negedge rst_n)
        if (~rst_n) begin
            rxreq          <= 0;
            en             <= 0;
            UtopiaStatus   <= reset;
        end
        else begin
            case (UtopiaStatus)
                reset       :  begin
                    rxreq         <= 0    ;
                    UtopiaStatus  <= soc_frm  ;
                    en            <= 1    ;
                end
                soc_frm         :
                    if (soc && clav) begin
                        nni_VPI[11:4] <= data;
                        UtopiaStatus  <= vpi_vci;
                        //Rx.en <= 0;
                    end
                vpi_vci     :
                    if (clav) begin
                        {nni_VPI[3:0],
                         nni_VCI[15:12]} <= data;
                        UtopiaStatus     <= vci;
                    end
                vci         :
                    if (clav) begin
                        nni_VCI[11:4]    <= data;
                        UtopiaStatus     <= vci_clp_pt;
                    end
                vci_clp_pt  :
                    if (clav) begin
                        {nni_VCI[3:0], nni_CLP,
                         nni_PT}         <= data    ;
                        UtopiaStatus     <= hec     ;
                    end
                hec         :
                    if (clav) begin
                        nni_HEC          <= data    ;
                        UtopiaStatus     <= payload ;
                        PayloadIndex     <= 0       ;
                    end
                payload     :
                    if (clav) begin
                        //uni_Payload[PayloadIndex*8 +7:PayloadIndex*8] <= data;
                        nni_Payload <= {data,nni_Payload[48*8-1:8]};
                        if (PayloadIndex==47) begin
                            UtopiaStatus <= req;
                            en <= 0;
                        end
                        PayloadIndex <= PayloadIndex + 1;
                    end
                req         : begin
                    UtopiaStatus <= ack   ;
                    rxreq        <= 1     ;
                end
                ack         :
                    if(rxack) begin
                        UtopiaStatus <= reset ;
                        rxreq        <= 0     ;
                        en        <= 1     ;
                    end
                default     :
                    UtopiaStatus <= reset;
            endcase
        end



endmodule
