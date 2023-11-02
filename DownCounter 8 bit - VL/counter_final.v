/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : S-2021.06-SP3
// Date      : Wed Sep 20 12:43:42 2023
/////////////////////////////////////////////////////////////


module counter ( clock, in, latch, dec, divide_by_two, zero );
  input [7:0] in;
  input clock, latch, dec, divide_by_two;
  output zero;
  wire   n19, n36, n115, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n191, n192, n193, n194, n195, n196, n197, n198,
         n199, n200, n201, n202, n203, n204, n205, n206, n207, n208, n209,
         n210, n211, n212, n213, n214, n215, n216, n217, n218, n219, n220,
         n221, n222, n223, n224, n225, n226, n227, n228, n229, n230, n231,
         n232, n233, n234, n235, n236, n237, n238, n239, n240, n241, n242,
         n243, n244, n245, n246, n247, n248, n249, n250, n251;
  wire   [7:1] value;

  DFF_X2 value_reg_0_ ( .D(n172), .CK(clock), .Q(n244), .QN(n115) );
  DFF_X1 value_reg_2_ ( .D(n170), .CK(clock), .Q(n249), .QN(n36) );
  DFF_X1 value_reg_3_ ( .D(n173), .CK(clock), .Q(value[3]), .QN(n248) );
  DFF_X1 value_reg_7_ ( .D(n19), .CK(clock), .Q(value[7]) );
  DFF_X1 value_reg_5_ ( .D(n171), .CK(clock), .Q(n246), .QN(n250) );
  DFF_X1 value_reg_1_ ( .D(n167), .CK(clock), .Q(value[1]), .QN(n247) );
  DFF_X1 value_reg_6_ ( .D(n168), .CK(clock), .Q(n245) );
  DFF_X1 value_reg_4_ ( .D(n169), .CK(clock), .Q(value[4]), .QN(n251) );
  NAND2_X2 U79 ( .A1(n198), .A2(n197), .ZN(n168) );
  CLKBUF_X3 U80 ( .A(n189), .Z(zero) );
  AND2_X2 U81 ( .A1(n174), .A2(n204), .ZN(n238) );
  AND2_X2 U82 ( .A1(n115), .A2(n36), .ZN(n182) );
  BUF_X2 U83 ( .A(latch), .Z(n237) );
  AND2_X1 U84 ( .A1(n233), .A2(n180), .ZN(n193) );
  INV_X1 U85 ( .A(latch), .ZN(n217) );
  INV_X1 U86 ( .A(dec), .ZN(n204) );
  AND3_X1 U87 ( .A1(n184), .A2(n183), .A3(n221), .ZN(n189) );
  AND3_X1 U88 ( .A1(n182), .A2(n250), .A3(n251), .ZN(n184) );
  INV_X1 U89 ( .A(n193), .ZN(n181) );
  INV_X1 U90 ( .A(n175), .ZN(n174) );
  AND2_X1 U91 ( .A1(n178), .A2(n177), .ZN(n239) );
  INV_X1 U92 ( .A(n232), .ZN(n235) );
  INV_X1 U93 ( .A(n214), .ZN(n194) );
  INV_X1 U94 ( .A(in[1]), .ZN(n206) );
  INV_X1 U95 ( .A(n191), .ZN(n186) );
  AND2_X1 U96 ( .A1(n212), .A2(n245), .ZN(n213) );
  INV_X1 U97 ( .A(n249), .ZN(n226) );
  INV_X1 U98 ( .A(n239), .ZN(n179) );
  INV_X1 U99 ( .A(n238), .ZN(n211) );
  NAND2_X1 U100 ( .A1(n217), .A2(divide_by_two), .ZN(n175) );
  AOI22_X1 U101 ( .A1(n238), .A2(n245), .B1(n237), .B2(in[5]), .ZN(n188) );
  NOR2_X1 U102 ( .A1(latch), .A2(dec), .ZN(n176) );
  NAND2_X1 U103 ( .A1(n176), .A2(n175), .ZN(n233) );
  NAND2_X1 U104 ( .A1(n217), .A2(dec), .ZN(n234) );
  INV_X1 U105 ( .A(n234), .ZN(n212) );
  NOR2_X1 U106 ( .A1(value[3]), .A2(value[1]), .ZN(n178) );
  AND2_X1 U107 ( .A1(n251), .A2(n182), .ZN(n177) );
  NAND2_X1 U108 ( .A1(n212), .A2(n179), .ZN(n180) );
  NAND2_X1 U109 ( .A1(n181), .A2(n246), .ZN(n187) );
  NOR2_X1 U110 ( .A1(n245), .A2(value[7]), .ZN(n183) );
  AND2_X1 U111 ( .A1(n247), .A2(n248), .ZN(n221) );
  NOR2_X1 U112 ( .A1(n189), .A2(n234), .ZN(n240) );
  INV_X1 U113 ( .A(n240), .ZN(n199) );
  NAND2_X1 U114 ( .A1(n239), .A2(n250), .ZN(n185) );
  NOR2_X1 U115 ( .A1(n199), .A2(n185), .ZN(n191) );
  NAND3_X1 U116 ( .A1(n188), .A2(n187), .A3(n186), .ZN(n171) );
  OR2_X1 U117 ( .A1(n191), .A2(n245), .ZN(n196) );
  NAND2_X1 U118 ( .A1(n212), .A2(n246), .ZN(n192) );
  NAND2_X1 U119 ( .A1(n193), .A2(n192), .ZN(n214) );
  NAND2_X1 U120 ( .A1(n194), .A2(n245), .ZN(n195) );
  NAND2_X1 U121 ( .A1(n196), .A2(n195), .ZN(n198) );
  AOI22_X1 U122 ( .A1(n238), .A2(value[7]), .B1(n237), .B2(in[6]), .ZN(n197)
         );
  NAND2_X1 U123 ( .A1(n199), .A2(n115), .ZN(n201) );
  NAND2_X1 U124 ( .A1(n233), .A2(n244), .ZN(n200) );
  NAND2_X1 U125 ( .A1(n201), .A2(n200), .ZN(n203) );
  AOI22_X1 U126 ( .A1(n238), .A2(value[1]), .B1(n237), .B2(in[0]), .ZN(n202)
         );
  NAND2_X1 U127 ( .A1(n203), .A2(n202), .ZN(n172) );
  AOI22_X1 U128 ( .A1(divide_by_two), .A2(n204), .B1(dec), .B2(n115), .ZN(n218) );
  NAND2_X1 U129 ( .A1(n218), .A2(value[1]), .ZN(n205) );
  NAND2_X1 U130 ( .A1(n205), .A2(n217), .ZN(n208) );
  NAND2_X1 U131 ( .A1(n237), .A2(n206), .ZN(n207) );
  NAND2_X1 U132 ( .A1(n208), .A2(n207), .ZN(n210) );
  AND2_X1 U133 ( .A1(n247), .A2(n115), .ZN(n209) );
  NAND2_X1 U134 ( .A1(n240), .A2(n209), .ZN(n227) );
  OAI211_X1 U135 ( .C1(n226), .C2(n211), .A(n210), .B(n227), .ZN(n167) );
  OAI21_X1 U136 ( .B1(n214), .B2(n213), .A(value[7]), .ZN(n216) );
  NAND2_X1 U137 ( .A1(n237), .A2(in[7]), .ZN(n215) );
  NAND2_X1 U138 ( .A1(n216), .A2(n215), .ZN(n19) );
  NAND2_X1 U139 ( .A1(n240), .A2(value[1]), .ZN(n220) );
  NAND2_X1 U140 ( .A1(n218), .A2(n217), .ZN(n219) );
  AND2_X1 U141 ( .A1(n220), .A2(n219), .ZN(n225) );
  AOI22_X1 U142 ( .A1(n238), .A2(value[4]), .B1(n237), .B2(in[3]), .ZN(n224)
         );
  NAND2_X1 U143 ( .A1(n182), .A2(n221), .ZN(n232) );
  OAI21_X1 U144 ( .B1(n226), .B2(n248), .A(n232), .ZN(n222) );
  NAND2_X1 U145 ( .A1(n240), .A2(n222), .ZN(n223) );
  OAI211_X1 U146 ( .C1(n225), .C2(n248), .A(n224), .B(n223), .ZN(n173) );
  NAND2_X1 U147 ( .A1(n225), .A2(n249), .ZN(n229) );
  NAND2_X1 U148 ( .A1(n227), .A2(n226), .ZN(n228) );
  NAND2_X1 U149 ( .A1(n229), .A2(n228), .ZN(n231) );
  AOI22_X1 U150 ( .A1(n238), .A2(value[3]), .B1(n237), .B2(in[2]), .ZN(n230)
         );
  NAND2_X1 U151 ( .A1(n231), .A2(n230), .ZN(n170) );
  OAI21_X1 U152 ( .B1(n235), .B2(n234), .A(n233), .ZN(n236) );
  NAND2_X1 U153 ( .A1(n236), .A2(value[4]), .ZN(n243) );
  AOI22_X1 U154 ( .A1(n238), .A2(n246), .B1(in[4]), .B2(n237), .ZN(n242) );
  NAND2_X1 U155 ( .A1(n240), .A2(n239), .ZN(n241) );
  NAND3_X1 U156 ( .A1(n243), .A2(n242), .A3(n241), .ZN(n169) );
endmodule

