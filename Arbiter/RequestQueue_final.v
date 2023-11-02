/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : S-2021.06-SP3
// Date      : Fri Oct 13 18:00:52 2023
/////////////////////////////////////////////////////////////


module RequestQueue ( reset, clock, R0, R1, G0, G1 );
  input reset, clock, R0, R1;
  output G0, G1;
  wire   N19, N20, n5, n15, n16, n17, n18;
  wire   [1:0] current_state;
  wire   [1:0] next_state;

  DLH_X1 next_state_reg_0_ ( .G(n5), .D(N19), .Q(next_state[0]) );
  DLH_X1 next_state_reg_1_ ( .G(n5), .D(N20), .Q(next_state[1]) );
  DFFR_X1 current_state_reg_0_ ( .D(next_state[0]), .CK(clock), .RN(reset), 
        .Q(current_state[0]) );
  DFFR_X1 current_state_reg_1_ ( .D(next_state[1]), .CK(clock), .RN(reset), 
        .Q(current_state[1]), .QN(n18) );
  INV_X1 U20 ( .A(R1), .ZN(n17) );
  NOR2_X2 U21 ( .A1(current_state[0]), .A2(n18), .ZN(G1) );
  NOR3_X1 U22 ( .A1(current_state[1]), .A2(R0), .A3(current_state[0]), .ZN(n15) );
  AND2_X1 U23 ( .A1(n15), .A2(R1), .ZN(N20) );
  NAND2_X1 U24 ( .A1(n15), .A2(n17), .ZN(n5) );
  AND3_X2 U25 ( .A1(R0), .A2(current_state[0]), .A3(n18), .ZN(G0) );
  NOR2_X1 U26 ( .A1(R0), .A2(current_state[0]), .ZN(n16) );
  AOI211_X1 U27 ( .C1(current_state[0]), .C2(n17), .A(current_state[1]), .B(
        n16), .ZN(N19) );
endmodule

