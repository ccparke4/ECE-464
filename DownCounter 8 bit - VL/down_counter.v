/*module************************************
*
* NAME:  8 bit down-counter
*
* DESCRIPTION:
*  downcounter with zero flag and synchronous clear
*
* NOTES:
*   (a) Redesign the module in the tutorial as an 8 bit down-counter. In addition, add\
*   the input divide-by-two. Whenever divide-by-two is high and
*   latch is low and dec is low (both dec and divide-by-two will never be high at the same time), 
*   divide the current contents of the counter by 2 (by doing a right shift). e.g.
* REVISION HISTORY
*    Date     Programmer    Description
*    7/10/97  P. Franzon    ece520-specific version
*    9/19/23  T. Parker     ece464-Homework 3
*M*/

/*======Declarations===============================*/

module counter (clock, in, latch, dec, divide_by_two, zero);


/*-----------Inputs--------------------------------*/

input       clock;  /* clock */
input [7:0] in;  /* input initial count */
input       latch;  /* `latch input' */
input       dec;   /* decrement */
input       divide_by_two;  /* divides contents of counter by 2 */

/*-----------Outputs--------------------------------*/

output      zero;  /* zero flag */

/*----------------Nets and Registers----------------*/
/*---(See input and output for unexplained variables)---*/

reg [7:0] value;       /* current count value */
wire      zero;

// Count Flip-flops with input multiplexor
always@(posedge clock)
  begin  // begin-end not actually need here as there is only one statement
    if(latch) value <= in;
    else if (!zero && !dec && divide_by_two) value <= value >> 1;
    else if (dec && !zero) value <= value - 1'b1;  
  end


// combinational logic for zero flag
assign zero = ~|value;

endmodule /* counter */




