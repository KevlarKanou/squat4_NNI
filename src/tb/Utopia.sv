
`include "../src/env/definitions.sv" 

interface Utopia(input bit clk);

parameter int IfWidth = 8;

bit    soc, en, clav;
logic [IfWidth - 1 : 0] data ;


modport TopReceive(
        input   data, soc, clav,
		output en );
		
modport TopTransmit(
        output data, soc, en,
		input  clav );		


//clocking cbr @(negedge clk);
clocking cbr @(posedge clk);
	default input #1ns output #1ns;
        input   en;
        output  data, soc, clav;
endclocking : cbr

modport TB_Rx (clocking cbr);


clocking cbt @(negedge clk);
//clocking cbt @(posedge clk);
        input  soc, en, data;
	output clav ;
endclocking : cbt

modport TB_Tx (clocking cbt);
		

endinterface


typedef virtual Utopia vUtopia;
typedef virtual Utopia.TB_Rx vUtopiaRx;
typedef virtual Utopia.TB_Tx vUtopiaTx;
