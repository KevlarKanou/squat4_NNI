`include "../src/env/definitions.sv"

typedef class NNI_cell;

class UNI_cell;
   // Physical fields
   rand bit        [3:0]  GFC;
   rand bit        [7:0]  VPI;
   rand bit        [15:0] VCI;
   rand bit               CLP;
   rand bit        [2:0]  PT;
        bit        [7:0]  HEC;
   rand bit [0:47] [7:0]  Payload;

   // Meta-data fields
   static bit [7:0] syndrome[0:255];
   static bit syndrome_not_generated = 1;

   extern function new();

   // extern function void post_randomize();
   // extern function void generate_syndrome();
   // extern function bit [7:0] hec (bit [31:0] hdr);
   // extern virtual function void pack(output ATMCellType to);
   // extern function NNI_cell to_NNI(input bit [11:0] nni_VPI);
   // extern function UNI_cell copy();

   extern function void uni_hec();
   extern virtual function bit compare(input UNI_cell cmp);
   extern virtual function void unpack(input ATMCellType from);
   extern function void generate_syndrome();
   extern function bit [7:0] hec (bit [31:0] hdr);

   extern virtual function void display(input string prefix="");

endclass : UNI_cell



//-----------------------------------------------------------------------------
function UNI_cell::new();
   if (syndrome_not_generated)
     generate_syndrome();
endfunction : new


// //-----------------------------------------------------------------------------
// // Compute the HEC value after all other data has been chosen
// function void UNI_cell::post_randomize();
//    HEC = hec({GFC, VPI, VCI, CLP, PT});
// endfunction : post_randomize


// //---------------------------------------------------------------------------
// // Generate the syndome array, used to compute HEC
// function void UNI_cell::generate_syndrome();
//    bit [7:0] sndrm;
//    for (int i = 0; i < 256; i = i + 1 ) begin
//       sndrm = i;
//       repeat (8) begin
//          if (sndrm[7] === 1'b1)
//            sndrm = (sndrm << 1) ^ 8'h07;
//          else
//            sndrm = sndrm << 1;
//       end
//       syndrome[i] = sndrm;
//    end
//    syndrome_not_generated = 0;
// endfunction : generate_syndrome

// //---------------------------------------------------------------------------
// // Function to compute the HEC value
// function bit [7:0] UNI_cell::hec (bit [31:0] hdr);
//    hec = 8'h00;
//    repeat (4) begin
//       hec = syndrome[hec ^ hdr[31:24]];
//       hdr = hdr << 8;
//    end
//    hec = hec ^ 8'h55;
// endfunction : hec


// function void UNI_cell::pack(output ATMCellType to);
//    to.uni.GFC     = this.GFC;
//    to.uni.VPI     = this.VPI;
//    to.uni.VCI     = this.VCI;
//    to.uni.CLP     = this.CLP;
//    to.uni.PT      = this.PT;
//    to.uni.HEC     = this.HEC;
//    to.uni.Payload = this.Payload;
//    //$write("Packed: "); foreach (to.Mem[i]) $write("%x ", to.Mem[i]); $display;
// endfunction : pack


// // Generate a NNI cell from an UNI cell - used in scoreboard
// function NNI_cell UNI_cell::to_NNI(input bit [11:0] nni_VPI);
//    NNI_cell copy;
   
//    copy = new();
   
//    copy.VPI     = nni_VPI     ;   // NNI has wider VPI
//    copy.VCI     = this.VCI;
//    copy.CLP     = this.CLP;
//    copy.PT      = this.PT;
//    copy.HEC     = this.HEC;
//    copy.Payload = this.Payload;
   
//    copy.nni_hec();
   
//    return copy;
   
// endfunction : to_NNI

// function UNI_cell UNI_cell::copy();
  
//    UNI_cell uni_copy = new();
   
//    uni_copy.GFC     = this.GFC;
//    uni_copy.VPI     = this.VPI;
//    uni_copy.VCI     = this.VCI;
//    uni_copy.CLP     = this.CLP;
//    uni_copy.PT      = this.PT;
//    uni_copy.HEC     = this.HEC;
//    uni_copy.Payload = this.Payload;
   
//    return(uni_copy);
   
// endfunction : copy

//-----------------------------------------------------------------------------
// Compute the HEC value after all other data has been chosen
function void UNI_cell::uni_hec();
   HEC = hec({GFC, VPI, VCI, CLP, PT});
endfunction : uni_hec

function bit UNI_cell::compare(input UNI_cell cmp);
   if (this.GFC != cmp.GFC)         return 0;
   if (this.VPI != cmp.VPI)         return 0;
   if (this.VCI != cmp.VCI)         return 0;
   if (this.CLP != cmp.CLP)         return 0;
   if (this.PT  != cmp.PT)          return 0;
   if (this.HEC != cmp.HEC)         return 0;
   if (this.Payload != cmp.Payload) return 0;
   return 1;

endfunction : compare

function void UNI_cell::unpack(input ATMCellType from);
   this.GFC     = from.uni.GFC;
   this.VPI     = from.uni.VPI;
   this.VCI     = from.uni.VCI;
   this.CLP     = from.uni.CLP;
   this.PT      = from.uni.PT;
   this.HEC     = from.uni.HEC;
   this.Payload = from.uni.Payload;
endfunction : unpack

//---------------------------------------------------------------------------
// Generate the syndome array, used to compute HEC
function void UNI_cell::generate_syndrome();
   bit [7:0] sndrm;
   for (int i = 0; i < 256; i = i + 1 ) begin
      sndrm = i;
      repeat (8) begin
         if (sndrm[7] === 1'b1)
           sndrm = (sndrm << 1) ^ 8'h07;
         else
           sndrm = sndrm << 1;
      end
      syndrome[i] = sndrm;
   end
   syndrome_not_generated = 0;
endfunction : generate_syndrome

//---------------------------------------------------------------------------
// Function to compute the HEC value
function bit [7:0] UNI_cell::hec (bit [31:0] hdr);
   hec = 8'h00;
   repeat (4) begin
      hec = syndrome[hec ^ hdr[31:24]];
      hdr = hdr << 8;
   end
   hec = hec ^ 8'h55;
endfunction : hec

// function void UNI_cell::display(input string prefix);
//    ATMCellType p;

//    $display("%sUNI  GFC=%x, VPI=%x, VCI=%x, CLP=%b, PT=%x, HEC=%x, Payload[0]=%x",
// 	    prefix, GFC, VPI, VCI, CLP, PT, HEC, Payload[0]);
//    this.pack(p);
//    $write("%s", prefix);
//    foreach (p.Mem[i]) $write("%x ", p.Mem[i]); $display;
//    //$write("%sUNI Payload=%x %x %x %x %x %x ...",
//    //	  prefix, Payload[0], Payload[1], Payload[2], Payload[3], Payload[4], Payload[5]);
//    //foreach(Payload[i]) $write(" %x", Payload[i]);
//    $display;
// endfunction : display

function void UNI_cell::display(input string prefix);
   ATMCellType p;

   $display("%sUNI GFC=%x, VPI=%x, VCI=%x, CLP=%b, PT=%x, HEC=%x, Payload[0]=%x",
	    prefix, GFC, VPI, VCI, CLP, PT, HEC, Payload[0]);

   //this.pack(p);
   $write("%s", prefix);
   foreach (p.Mem[i]) $write("%x ", p.Mem[i]); $display;
   //$write("%sUNI Payload=%x %x %x %x %x %x ...",
   $display;

endfunction : display

/////////////////////////////////////////////////////////////////////////////
// NNI Cell Format
/////////////////////////////////////////////////////////////////////////////
class NNI_cell ;
   // Physical fields
   rand bit        [11:0] VPI;
   rand bit        [15:0] VCI;
   rand bit               CLP;
   rand bit        [2:0]  PT;
        bit        [7:0]  HEC;
   rand bit [0:47] [7:0]  Payload;

   // Meta-data fields
   static bit [7:0] syndrome[0:255];
   static bit syndrome_not_generated = 1;

   extern function new();

   // extern function void nni_hec();
   // extern virtual function bit compare(input NNI_cell cmp);
   // extern virtual function void unpack(input ATMCellType from);
   // extern function void generate_syndrome();
   // extern function bit [7:0] hec (bit [31:0] hdr);

   extern function void post_randomize();
   extern function void generate_syndrome();
   extern function bit [7:0] hec (bit [31:0] hdr);
   extern virtual function void pack(output ATMCellType to);
   extern function UNI_cell to_UNI(input bit [7:0] uni_VPI);

   extern function NNI_cell copy();
   extern virtual function void display(input string prefix="");
   
   
endclass : NNI_cell


function NNI_cell::new();
   if (syndrome_not_generated)
     generate_syndrome();
endfunction : new


// //-----------------------------------------------------------------------------
// // Compute the HEC value after all other data has been chosen
// function void NNI_cell::nni_hec();
//    HEC = hec({VPI, VCI, CLP, PT});
// endfunction : nni_hec


// function bit NNI_cell::compare(input NNI_cell cmp);
//    if (this.VPI != cmp.VPI)         return 0;
//    if (this.VCI != cmp.VCI)         return 0;
//    if (this.CLP != cmp.CLP)         return 0;
//    if (this.PT  != cmp.PT)          return 0;
//    if (this.HEC != cmp.HEC)         return 0;
//    if (this.Payload != cmp.Payload) return 0;
//    return 1;

// endfunction : compare


// function void NNI_cell::unpack(input ATMCellType from);
//    this.VPI     = from.nni.VPI;
//    this.VCI     = from.nni.VCI;
//    this.CLP     = from.nni.CLP;
//    this.PT      = from.nni.PT;
//    this.HEC     = from.nni.HEC;
//    this.Payload = from.nni.Payload;
// endfunction : unpack

// //---------------------------------------------------------------------------
// // Generate the syndome array, used to compute HEC
// function void NNI_cell::generate_syndrome();
//    bit [7:0] sndrm;
//    for (int i = 0; i < 256; i = i + 1 ) begin
//       sndrm = i;
//       repeat (8) begin
//          if (sndrm[7] === 1'b1)
//            sndrm = (sndrm << 1) ^ 8'h07;
//          else
//            sndrm = sndrm << 1;
//       end
//       syndrome[i] = sndrm;
//    end
//    syndrome_not_generated = 0;
// endfunction : generate_syndrome

// //---------------------------------------------------------------------------
// // Function to compute the HEC value
// function bit [7:0] NNI_cell::hec (bit [31:0] hdr);
//    hec = 8'h00;
//    repeat (4) begin
//       hec = syndrome[hec ^ hdr[31:24]];
//       hdr = hdr << 8;
//    end
//    hec = hec ^ 8'h55;
// endfunction : hec

//---------------------------------------------------------------------------
// 随机生成NNI报文后，计算HEC
function void NNI_cell::post_randomize();
   HEC = hec({VPI, VCI, CLP, PT});
endfunction : post_randomize

//---------------------------------------------------------------------------
// Generate the syndome array, used to compute HEC
function void NNI_cell::generate_syndrome();
   bit [7:0] sndrm;
   for (int i = 0; i < 256; i = i + 1 ) begin
      sndrm = i;
      repeat (8) begin
         if (sndrm[7] === 1'b1)
           sndrm = (sndrm << 1) ^ 8'h07;
         else
           sndrm = sndrm << 1;
      end
      syndrome[i] = sndrm;
   end
   syndrome_not_generated = 0;
endfunction : generate_syndrome

//---------------------------------------------------------------------------
// Function to compute the HEC value
function bit [7:0] NNI_cell::hec (bit [31:0] hdr);
   hec = 8'h00;
   repeat (4) begin
      hec = syndrome[hec ^ hdr[31:24]];
      hdr = hdr << 8;
   end
   hec = hec ^ 8'h55;
endfunction : hec

function void NNI_cell::pack(output ATMCellType to);
   to.nni.VPI     = this.VPI;
   to.nni.VCI     = this.VCI;
   to.nni.CLP     = this.CLP;
   to.nni.PT      = this.PT;
   to.nni.HEC     = this.HEC;
   to.nni.Payload = this.Payload;
   //$write("Packed: "); foreach (to.Mem[i]) $write("%x ", to.Mem[i]); $display;
endfunction : pack

function NNI_cell NNI_cell::copy();
  
   NNI_cell nni_copy = new();
   
   nni_copy.VPI     = this.VPI;
   nni_copy.VCI     = this.VCI;
   nni_copy.CLP     = this.CLP;
   nni_copy.PT      = this.PT;
   nni_copy.HEC     = this.HEC;
   nni_copy.Payload = this.Payload;
   
   return(nni_copy);
   
endfunction : copy

// Generate a NNI cell from an UNI cell - used in scoreboard
function UNI_cell NNI_cell::to_UNI(input bit [7:0] uni_VPI);
   UNI_cell copy;
   
   copy = new();
   
   copy.GFC     = 4'b0;
   copy.VPI     = uni_VPI;
   copy.VCI     = this.VCI;
   copy.CLP     = this.CLP;
   copy.PT      = this.PT;
   copy.HEC     = this.HEC;
   copy.Payload = this.Payload;
   
   copy.uni_hec();
   
   return copy;
   
endfunction : to_UNI

// function void NNI_cell::display(input string prefix);
//    ATMCellType p;

//    $display("%sNNI , VPI=%x, VCI=%x, CLP=%b, PT=%x, HEC=%x, Payload[0]=%x",
// 	    prefix, VPI, VCI, CLP, PT, HEC, Payload[0]);

//    //this.pack(p);
//    $write("%s", prefix);
//    foreach (p.Mem[i]) $write("%x ", p.Mem[i]); $display;
//    //$write("%sUNI Payload=%x %x %x %x %x %x ...",
//    $display;

// endfunction : display

function void NNI_cell::display(input string prefix);
   ATMCellType p;

   $display("%sNNI  VPI=%x (FWD[%d]), VCI=%x, CLP=%b, PT=%x, HEC=%x, Payload[0]=%x",
	    prefix, VPI, VPI[7:0], VCI, CLP, PT, HEC, Payload[0]);
   this.pack(p);
   $write("%s", prefix);
   foreach (p.Mem[i]) $write("%x ", p.Mem[i]); $display;
   //$write("%sUNI Payload=%x %x %x %x %x %x ...",
   //	  prefix, Payload[0], Payload[1], Payload[2], Payload[3], Payload[4], Payload[5]);
   //foreach(Payload[i]) $write(" %x", Payload[i]);
   $display;
endfunction : display