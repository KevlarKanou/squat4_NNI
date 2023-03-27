
`ifndef _INCL_DEFINITIONS
`define _INCL_DEFINITIONS

/*
  Cell Formats
*/
/* UNI Cell Format */
typedef struct packed {
  bit        [3:0]  GFC;
  bit        [7:0]  VPI;
  bit        [15:0] VCI;
  bit               CLP;
  bit        [2:0]  PT;
  bit        [7:0]  HEC;
  bit [0:47] [7:0]  Payload;
} uniType;

/* NNI Cell Format */
typedef struct packed {
  bit        [11:0] VPI;
  bit        [15:0] VCI;
  bit               CLP;
  bit        [2:0]  PT;
  bit        [7:0]  HEC;
  bit [0:47] [7:0]  Payload;
} nniType;

/* Test View Cell Format (Payload Section) */
typedef struct packed {
  bit [0:4]  [7:0] Header;
  bit [0:3]  [7:0] PortID;
  bit [0:3]  [7:0] CellID;
  bit [0:39] [7:0] Padding;
} tstType;

/*
  Union of UNI / NNI / Test View / ByteStream
*/
typedef union packed {
  uniType uni;
  nniType nni;
  tstType tst;
  bit [0:52] [7:0] Mem;
} ATMCellType;

/*
  Cell Rewriting and Forwarding Configuration
*/
typedef struct packed {
  bit [`TxPorts-1:0] FWD;
  bit [11:0] VPI;
} CellCfgType;

`endif // _INCL_DEFINITIONS
