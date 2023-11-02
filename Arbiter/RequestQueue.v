module RequestQueue(reset,clock,R0,R1,G0,G1);

input reset;        // reset signal
input clock;        // clock signal
input R0;           // arbiter request line 1
input R1;           // arbiter request line 2

output reg G0;          // grant line 1
output reg G1;          // grant line 2

reg [1:0] current_state;      // current state register
reg [1:0] next_state;         // next state register

parameter [1:0] IDLE = 2'b00;          // idle state
parameter [1:0] GRANT_R0 = 2'b01;      // wait state for receiving g0 from r0 signal
parameter [1:0] GRANT_R1 = 2'b10;      // wait state for receiving g1 from r1 signal

always @(posedge clock or negedge reset)
    begin
        if(!reset) current_state <= IDLE;
        else current_state <= next_state;             
    end

// FSM waits for the inputs to go low then transmits after the request signal goes low
always @(*)
    begin 
        G0 = 0;
        G1 = 0;
        case (current_state)
        IDLE:
        begin 
            if(current_state == GRANT_R1) G1 = 1;
            if((R0 & R1) | (R0)) next_state = GRANT_R0;
            else if(R1) next_state = GRANT_R1;  
            end

        GRANT_R0:
        begin
            
            // G0 = 1;    // G0 channel transmit
            if(R0) G0 = 1;
            if(R1) next_state = GRANT_R0;
            else next_state = IDLE;            
            end

        GRANT_R1:
        begin
            G1 = 1;   // G1 channel transmit
            next_state = IDLE;      // always idle (x1)            
            end

        default: next_state = IDLE;
        endcase
        

    end

endmodule
