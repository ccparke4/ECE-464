/* 
HW6 DUT
---------
NAME: TREY PARKER - ECE 464
DATE: 10/19/2023 - 12:21PM
VERSION : 01.g
----------


Notes:
- Template dut.v that interfaces with the test_fixture provided
- interfacing dut file with SRAM (test fixture)
*/
//---------------------------------------------------------------------------
// DUT 
//---------------------------------------------------------------------------
module MyDesign(
//-------------------------------s_--------------------------------------------
//System signals
  input wire reset_n                      , // synchronous reset - active low : drives logic into known state
  input wire clk                          , // clock : drives FFs in design

//---------------------------------------------------------------------------
//Control signals : indicate to te test fixture the state of the dut

  input wire dut_valid                    , // synchronous valid - active high  : part of hand shake between test_fixture and dut.
                                            // Valid signals that a valid I/P can be computed from SRAM

  output wire dut_ready                   , // synchronous ready - active high  : Signals dut is ready to receive new I/P from SRAM

//---------------------------------------------------------------------------
//q_state_output SRAM interface
  output wire         sram_write_enable  ,  // sync enable active high
  output wire [15:0]  sram_write_address ,  // sync waddr data
  output wire [31:0]  sram_write_data    ,  // sync wdata data
  output wire [15:0]  sram_read_address  ,  // sync raddr data
  input  wire [31:0]  sram_read_data        // sync rdata data



);

//---------------------------------------------------------------------------
//q_state_output SRAM interface
  reg        sram_write_enable_r;
  reg [15:0] sram_write_address_r;
  reg [31:0] sram_write_data_r;
  reg [15:0] sram_read_address_r; 
  reg        compute_complete;
  reg [1:0]  compute_state;


// This is test sub for the DW_fp_add, do not change any of the inputs to the
// param list for the DW_fp_add, you will only need one DW_fp_add

// synopsys translate_off
  shortreal test_val;
  assign test_val = $bitstoshortreal(sum_r); 
  // This is a helper val for seeing the 32bit flaot value, you can repicate 
  // this for any signal, but keep it between the translate_off and
  // translate_on 
// synopsys translate_on

  wire  [31:0] sum_w;
  reg   [31:0] sum_r;
  reg   [31:0] in;
  wire  [7:0] status;

/* DW_fp_add:
floating point component that ADDS TWO FLOATING POINT VALUES( a and b) to produce FLOATING POINT SUM (z)
Note: follows IEEE-754 standard for single precision 32-bit
*/
  DW_fp_add  #(         
    .sig_width        (23),
    .exp_width        (8),
    .ieee_compliance  (3)
  ) fp_add_mod (                          // pin name | Width (param. above)        | Dir | Function
    .a                (sum_r),            // a        | sig_width + exp_width + 1'b | I/P | input data
    .b                (in),               // b        | sig_width + exp_width + 1'b | I/P | input data
    .rnd              (3'd0),             // z        | sig_width + exp_width + 1'b | O/P | a + b
    .z                (sum_w), 
    .status           (status));

/* DW_fp_mac:
- floating point component that performs the multiply and add operation.
- Sums up a floating-point PRODUCT of input a and b to input c (ab+c) to produce a floating-point MULTIPLY and add result z
*/

// instance of DW_fp_mac
/*
DW_fp_mac #(inst_sig_width, inst_exp_width, inst_ieee_compliance) 
U1(                                                                 // pin name | Width (explicit override param. above) | Dir | Function
  .a(inst_a),                                                       // a        | exp_width + sig_width + 1'b            | I/P | Multiplier
  .b(inst_b),                                                       // b        | exp_width + sig_width + 1'b            | I/P | Multiplicand
  .c(inst_c),                                                       // c        | exp_width + sig_width + 1'b            | I/P | Addend
  .rnd(inst_rnd),                                                   // rnd      | 3 bits                                 | I/P | Rounding mode (look at Datapath Floatin) 
  .z(z_inst),                                                       // z        | exp_width + sig_width + 1'b            | O/P | MAC result (a * b + c)
  .status(status_inst)
);
*/
// one hot FSM state encoding
/*
localparam s0 = 13'b0000000000000;    
localparam s1 = 13'b0000000000010;
localparam s2 = 13'b0000000000100;
localparam s3 = 13'b0000000001000;
localparam s_load = 13'b0000000010000;
localparam s_compute_init = 13'b0000000100000;
localparam s_compute_ready = 13'b0000001000000;
localparam s4 = 13'b0000010000000;
localparam s5 = 13'b0000100000000;
localparam s6 = 13'b0001000000000;
localparam s7 = 13'b0010000000000;
localparam s8 = 13'b0100000000000;
localparam s9 = 13'b100000000000;
*/

// standard encoding

localparam s0 = 5'b00000;    
localparam s1 = 5'b00001;
localparam s2 = 5'b00010;
localparam s3 = 5'b00011;
localparam s4 = 5'b00100;
localparam s5 = 5'b00101;
localparam s6 = 5'b00110;
localparam s7 = 5'b00111;
localparam s8 = 5'b01000;
localparam s9 = 5'b01001;
localparam s_load = 5'b10000;
localparam s_compute_init = 5'b11000;
localparam s_compute_ready = 5'b11001;


// decrement counter for size of array
reg [31:0] array_size;
// state control
reg [8:0] current_state;     // reg for current state of FSM
reg [8:0] next_state;        // reg for next state of FSM
// mux control lines
reg [1:0] array_size_sel;    // select line for mux that controls array_size register
reg [1:0] read_address_sel;  // select line for mux that controls sram_read_address_r  
reg [1:0] write_data_sel;    // select line for mux that controls sram_write_data_r
reg [1:0] write_address_sel; // select line for mux that controls sram_write_address_r

reg ready_signal;             // reg to dut_ready in






// reg declerations
always @(posedge clk or negedge reset_n) begin
if(!reset_n) 
  current_state <= 9'b0;     // reset to know state
else
  current_state <= next_state;  
end

always @(*) begin
  casex(current_state)


  s0 : begin                      //x0000
      array_size_sel = 2'b11;      // set address to dont care value
      write_data_sel = 2'b0;      // dont write init (known state reset)
      read_address_sel =  2'b10;    // hold address
      write_address_sel = 2'b0;   // 
      sram_write_enable_r = 1'b0;  // 
      ready_signal = 1'b1;        // DUT is in READY state
      
      compute_complete = 1'b0;    // misc
      compute_state = 2'b0;       // no data yet
      
       if(dut_valid)        // check if dut data is valid  (handshake)
        next_state = s1;
      else
        next_state = s0;
      
  end 
  s1 : begin                      //0002
      array_size_sel = 2'b0;      // try to get signal
      write_data_sel = 2'b0;      // 2
      read_address_sel = 2'b00; // 0
      write_address_sel = 2'b10;   // set write address to read
      sram_write_enable_r = 1'b0;   // 
      ready_signal = 1'b0;         // not ready in process init

      compute_complete = 1'b0;    // !done compute 
      compute_state = 2'b00;      // keep adder low
      next_state = s2;  
      
      
  end
  
  s2 : begin                   
      array_size_sel = 2'b0;                // attempy to read array
      write_data_sel = 2'b0;                // dont write
      read_address_sel = 2'b0;              // set address low (or dont care state)
      write_address_sel = 2'b00;            // set write address to read
      sram_write_enable_r  = 1'b0;           // dont enable
      ready_signal = 1'b0;                   // keep low 
     
      compute_state = 2'b01;                // attempt to init calc
      next_state = s3;              
      
    
    
  end 
  s3 : begin                    
      array_size_sel = 2'b0;       // read in array attempt
      write_data_sel = 2'b0;      // dont write
      read_address_sel = 2'b01;   // read aaddress and increment
      write_address_sel = 2'b0;   // set write address to read address         
      sram_write_enable_r  = 1'b0;// not ready to write       
      ready_signal = 1'b0;        // not ready state             
      compute_state = 2'b00;      // hold accumulate vals low
      next_state = s_load;
  end
// delay states in FSM ensures no racethrough or invalid signal assignment. (check/buffer states)
  s_load : begin
    
    array_size_sel = 2'b01;      // read in array size
    write_data_sel = 2'b0;
    read_address_sel = 2'b01;    // hold address
    sram_write_enable_r = 1'b0; 
    write_address_sel = 2'b0; // set write address to read
    ready_signal = 1'b0;
    compute_state = 2'b10;      // initial accumulate data
         
    next_state = s_compute_init;
  end

  s_compute_init : begin
    array_size_sel = 2'b01;     // decrement array size
    write_data_sel = 2'b00;     
    read_address_sel = 2'b01;   // increment address   
    write_address_sel = 2'b0;   // set write address to read           
    sram_write_enable_r  = 1'b0;             
    ready_signal = 1'b0;                     
    compute_state = 2'b01;     // acc
     
    next_state = s_compute_ready;
  end

  s_compute_ready : begin
    array_size_sel = 2'b01;     // decrement array 
    write_data_sel = 2'b00;     
    read_address_sel = 2'b01;   // increment address   
    write_address_sel = 2'b0;    // set write address to read        
    sram_write_enable_r  = 1'b0;    
    ready_signal = 1'b0;                    
    compute_state = 2'b01;        // acc
     
    next_state = s4;
  end
  

        
      
      
  

  s4: begin                     // x0010
  
      array_size_sel = 2'b01;           // decrement array
      write_data_sel = 2'b00;           // data not ready for write
      read_address_sel = 2'b01;         // inc read addr
      write_address_sel = 2'b01;           // inc write address
      sram_write_enable_r  = 1'b0;         // dont enable write
      ready_signal = 1'b0;                 // not ready
      compute_complete = 1'b0;            // not done
      compute_state = 2'b01;              // start normal init'ed accum
      next_state = s5;
      
      
  end
  
  s5 : begin                    
      array_size_sel = 2'b01;             // 
      write_data_sel = 2'b0;              // 
      read_address_sel = 2'b01;           // inc read addr
      write_address_sel = 2'b0;           // hold write low
      sram_write_enable_r  = 1'b0;        // not ready to write
      ready_signal = 1'b0;                // not ready -> in process
      compute_complete = 1'b0;            // misc signal
      compute_state = 2'b01;              // compute acc

      if(array_size == 32'b11)          // reapeat state until ready to begin write process
        next_state = s6;
      else
        next_state = s5;            
  end
  
  s6 : begin 
      array_size_sel = 2'b01;   //  decrement array
      write_data_sel = 2'b0;               // set write data to accumulate
      read_address_sel = 2'b01;             // inc read address 
      write_address_sel = 2'b01;            // increment write w read base
      sram_write_enable_r  = 1'b0;         // not ready for write
      ready_signal = 1'b0;                  // not ready
      compute_complete = 1'b0;
      compute_state = 2'b01;              // continue accumulate (last vals)

      if(array_size == 32'b10)            // check for ready to write cases
        next_state = s7;                  // ready to write -> next
      else
        next_state = s6;                  // FSM state repeat
  end
  s7 : begin              
      array_size_sel = 2'b10;                // hold array size
      write_data_sel = 2'b10;                 // set write data to accumulate
      read_address_sel = 2'b10;              //  hold read address 
      write_address_sel = 2'b01;            //  increment write address with read base
      sram_write_enable_r  = 1'b1;          // enable write
      ready_signal = 1'b0;                   // not ready 
      compute_complete = 1'b0;
      compute_state = 2'b10;            // continue accumulate
      next_state = s8;
  end
  s8 : begin
      array_size_sel = 2'b10;      // hold array size
      write_data_sel = 2'b01;      // set wrrite to accumulate
      read_address_sel = 2'b10;    // hold read
      write_address_sel = 2'b10;   // hold write
      sram_write_enable_r  = 1'b1; // enable write to regs
      ready_signal = 1'b0;          // not ready
      compute_complete =1'b1;      // extra signal to indicate compute completion
      
      compute_state = 2'b0;        // reset accumulate regs

      next_state = s0;
  end
  
  default : begin
      array_size_sel = 2'b10;      // hold array size
      write_data_sel = 2'b00;      // set write data == 0
      read_address_sel = 2'b10;    // hold read address for safety case
      write_address_sel = 2'b0;    //  reset address
      sram_write_enable_r  = 1'b0; //  stop write
      ready_signal = 1'b0;         // not ready for next read/write
      compute_complete = 1'b0;
      compute_state = 2'b0;
      next_state = s0;
  end

  
  endcase
end

// data path
/// array size register

always @(posedge clk) begin

  if(array_size_sel == 2'b0)
  begin
    array_size <= sram_read_data;
    // flag when array size retrieved
    
  end
  else if(array_size_sel == 2'b01)
    array_size <= array_size - 32'b1;

  else if (array_size_sel <= 2'b10)
    array_size <= array_size;
  
  else if (array_size_sel <= 2'b11)
    array_size <= 32'bx;
    
  
end


// a and b regs accumulate
always @(posedge clk)begin
  if(compute_state == 2'b00)
  begin
    in <= 0;
    sum_r <=0;      // last edit 514p
  end
  else if(compute_state == 2'b01)
  begin
    in <= sram_read_data; 
    sum_r <= sram_read_data + in;
  end
  else if(compute_state == 2'b10)
  begin
    //in <= sram_read_data;
    sum_r <= sum_w + in;
    
  end
end


// write accumulate reg
always @(posedge clk ) begin

  if(write_data_sel == 2'b0)
      sram_write_data_r <= 32'b0;

  else if(write_data_sel == 2'b01)
    
    sram_write_data_r <= sum_w;

  else if(write_data_sel == 2'b10)
    
    sram_write_data_r <= sum_w;

  if(sram_write_enable_r == 1'b1)
    sram_write_data_r <= sum_w;
  else 
    sram_write_data_r <= 32'b0;
  
end
// assign input to "next module" write data
assign sram_write_data = sram_write_data_r;


// assign write enable to mod
assign sram_write_enable = sram_write_enable_r;
// read address reg
always @(posedge clk) begin

  if(read_address_sel == 2'b0)
    sram_read_address_r <= 16'b0;

  else if(read_address_sel == 2'b01)
    sram_read_address_r <= sram_read_address_r + 16'b1;

  else if(read_address_sel == 2'b10)
    sram_read_address_r <= sram_read_address_r;

  else if(read_address_sel == 2'b11)
    sram_read_address_r <= 16'bx;

end
// assign module add to signal
assign sram_read_address = sram_read_address_r;

// write address reg
always @(posedge clk) begin
  if(write_address_sel == 2'b0)
    sram_write_address_r <= sram_read_address_r;

  else if(write_address_sel == 2'b01)
    sram_write_address_r <= sram_write_address_r + 16'b1;

  else if(write_address_sel == 2'b10)
    sram_write_address_r <= 16'b0;
end

assign sram_write_address = sram_write_address_r;


assign dut_ready = ready_signal;




  

  

endmodule

