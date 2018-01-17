/*
 Test for iCEblink 40-LP1k board
 */
module top (
	    
	input  clk,
	output LD1,
	output LD2,
	output LD3,
	output LD4,
);
   
   localparam BITS = 4;
   localparam LOG2DELAY = 16; //Controls delay
   
   reg [BITS+LOG2DELAY-1:0] dcounter = 0;
   reg 		       slowClock = 0;
   reg [BITS-1:0]      counter = 0;      
   reg [BITS-1:0]      outcnt = 0;
   reg [BITS-1:0]      rotate = 4'b0001;
   
   always @(posedge clk) 
     begin
	if (!dcounter)
	  slowClock <= !slowClock;

	dcounter <= dcounter + 1;
     end

   always @(posedge slowClock)
     begin
	outcnt <= counter;
	counter <= counter + 1;
     end
   
   assign {LD1, LD2, LD3, LD4} = outcnt;
endmodule
