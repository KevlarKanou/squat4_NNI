`ifndef CPU_IFC__SV
`define CPU_IFC__SV 


`include "../src/env/definitions.sv"  // include external definitions

interface cpu_ifc;
  logic        BusMode;
  logic [7:0]  Addr;
  logic        Sel;
  CellCfgType  DataIn;
  CellCfgType  DataOut;
  logic        Rd_DS;
  logic        Wr_RW;
  logic        Rdy_Dtack;

  modport Peripheral (input  BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW,
		      output DataOut, Rdy_Dtack);

  modport Test (output BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW,
		input  DataOut, Rdy_Dtack);

endinterface : cpu_ifc

typedef virtual cpu_ifc vCPU;
typedef virtual cpu_ifc.Test vCPU_T;


`endif // CPU_IFC__SV
