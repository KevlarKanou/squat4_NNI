
module utopia1_atm_tx(
        input   wire                clk               ,
        input   wire                rst_n             ,

        output  reg                 soc               ,
        output  reg     [7:0]       data              ,
        output  reg                 en                ,
        input   wire                clav              ,

        input   wire                txreq             ,
        output  wire                txack             ,

        input   wire    [3:0]       uni_GFC           ,
        input   wire    [7:0]       uni_VPI           ,
        input   wire    [15:0]      uni_VCI           ,
        input   wire                uni_CLP           ,
        input   wire    [2:0]       uni_PT            ,
        input   wire    [7:0]       uni_HEC           ,
        input   wire    [8*48-1:0]  uni_Payload

    );

    ///////////////////////////////////////////////////
    reg        [5:0]      PayloadIndex  ;


    parameter   reset       = 4'h0 ,
                ready       = 4'h1 ,
                soc_frm     = 4'h2 ,
                vpi_vci     = 4'h3 ,
                vci         = 4'h4 ,
                vci_clp_pt  = 4'h5 ,
                hec         = 4'h6 ,
                payload	    = 4'h7 ,
                ack         = 4'h8 ,
                done        = 4'h9 ;

    reg        [3:0]      UtopiaStatus      ;
    /////////////////////////////////////////////////////

    always @(posedge clk, negedge rst_n)
        if (~rst_n)
            UtopiaStatus <= reset;
        else begin
            unique case (UtopiaStatus)
                reset     :
                    if(txreq )
                        UtopiaStatus <= ready        ;
                ready     :
                    if(clav)
                        UtopiaStatus <= soc_frm    ;
                soc_frm       :
                    if(clav)
                        UtopiaStatus <= vpi_vci    ;
                vpi_vci   :
                    if (clav)
                        UtopiaStatus <= vci        ;
                vci       :
                    if (clav)
                        UtopiaStatus <= vci_clp_pt ;
                vci_clp_pt:
                    if (clav)
                        UtopiaStatus <= hec        ;
                hec       :
                    if (clav)
                        UtopiaStatus <= payload    ;
                payload   :
                    if (clav) begin
                        if (PayloadIndex==47)
                            UtopiaStatus <= ack   ;
                    end
                ack       :
                    UtopiaStatus <= done          ;
                done      :
                    UtopiaStatus <= reset         ;
                default   :
                    UtopiaStatus <= reset         ;
            endcase
        end

    wire     s_state_ready = (UtopiaStatus == ready)  ;

    assign   txack = (UtopiaStatus == ack)      ;

    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            soc <= 0  ;
        else
            soc <= clav & (UtopiaStatus == soc_frm)      ;

    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            en <= 0;
        else if( (UtopiaStatus == reset) || (UtopiaStatus == ack) || (UtopiaStatus == done))
            en <= 0;
        else
            en <= clav      ;

    reg [48*8-1:0] uni_Payload_reg ;
    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            uni_Payload_reg <= 'h0;
        else if(s_state_ready)
            uni_Payload_reg <= uni_Payload;


    always @(posedge clk or negedge rst_n)
        if (~rst_n)
            data <= 8'h00;
        else begin
            unique case (UtopiaStatus)
                soc_frm        :
                    if (clav)
                        data <= {uni_GFC, uni_VPI[7:4]};
                vpi_vci    :
                    if (clav)
                        data <= {uni_VPI[3:0],
                                 uni_VCI[15:12]
                                };
                vci        :
                    if (clav)
                        data <= uni_VCI[11:4];
                vci_clp_pt :
                    if (clav)
                        data <= {uni_VCI[3:0],
                                 uni_CLP, uni_PT};
                hec        :
                    if (clav)
                        data <= uni_HEC;
                payload    :
                    if (clav) begin
                        data <= uni_Payload_reg[7:0];
                        uni_Payload_reg[48*8-1:0] <={8'h00,uni_Payload_reg[48*8-1:8]} ;
                    end
                default    :
                    data <= 8'h00 ;
            endcase
        end

    always_ff @(posedge clk, negedge rst_n)
        if (~rst_n)
               PayloadIndex <= 0;
        else if(UtopiaStatus == payload) begin
            if(clav)
                PayloadIndex <= PayloadIndex + 1 ;
        end
        else
            PayloadIndex <= 0;

endmodule
