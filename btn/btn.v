/*
 Test for iCEblink 40-LP1k board
 Each LED is controlled by a button press
 
 btn1 --> led1
 btn2 --> led2
 btn3 --> led3
 btn4 --> led4
 
 The buttons aren't debounced, some LEDs
 might flicker or light up by magic.
 */
module top (
	    
	input  clk,
	output LD1,
	output LD2,
	output LD3,
	output LD4,
	inout  BTN1,
	inout  BTN2,
	inout  BTN3,
	inout  BTN4
);
   
   localparam BITS = 4;
   localparam LOG2DELAY = 16; //Controls delay

   reg 	       LD1_stat = 1'b0;
   reg 	       LD2_stat = 1'b0;
   reg 	       LD3_stat = 1'b0;
   reg 	       LD4_stat = 1'b0;
   
   reg 	       BTN1_sample = 1'b0;	       
   reg 	       prev_BTN1_sample = 1'b0;	       
   
   reg 	       BTN2_sample = 1'b0;	       
   reg 	       prev_BTN2_sample = 1'b0;	       
   
   reg 	       BTN3_sample = 1'b0;	       
   reg 	       prev_BTN3_sample = 1'b0;	       
   
   reg 	       BTN4_sample = 1'b0;	       
   reg 	       prev_BTN4_sample = 1'b0;	       
   
   reg 	       btn_stat = 1'b0;
   reg 	       prev_btn_stat = 1'b0;
   reg 	       btn_sample;
   reg 	       prev_btn_sample;
   
   wire        BTN1_changed;	       
   wire        BTN2_changed;	       
   wire        BTN3_changed;	       
   wire        BTN4_changed;	       
   
   reg [BITS+LOG2DELAY-1:0] dcounter = 20'b0;
   reg 			    slowClock = 0;
   
   always @(posedge clk) 
     begin
	if (!dcounter)
	  slowClock <= !slowClock;
	
	dcounter <= dcounter + 1;
     end
   
   assign btn_sample = dcounter[18];	

   assign BTN1 = ((btn_sample) ? 1'bZ : 1'b0);
   assign BTN2 = ((btn_sample) ? 1'bZ : 1'b0);
   assign BTN3 = ((btn_sample) ? 1'bZ : 1'b0);
   assign BTN4 = ((btn_sample) ? 1'bZ : 1'b0);

   always @(posedge clk)
     begin
	if (~btn_sample)
	  btn_stat <= 1'b0;
	else
	  btn_stat <= (BTN1 | BTN2 | BTN3 | BTN4) & ~prev_btn_stat;
     end

   always @(posedge clk)
     begin
	if (~btn_sample)
	  prev_btn_stat <= 1'b0;
	else
	  prev_btn_stat <= btn_stat;
     end
   
   always @(posedge clk)
     begin
	if (btn_stat)
	  begin
	     BTN1_sample <= ~BTN1;
	     BTN2_sample <= ~BTN2;
	     BTN3_sample <= ~BTN3;
	     BTN4_sample <= ~BTN4;
	     
	     prev_BTN1_sample <= BTN1_sample;
	     prev_BTN2_sample <= BTN2_sample;
	     prev_BTN3_sample <= BTN3_sample;
	     prev_BTN4_sample <= BTN4_sample;	     
	  end
     end
   
   assign BTN1_changed = (BTN1_sample & !prev_BTN1_sample);
   assign BTN2_changed = (BTN2_sample & !prev_BTN2_sample);
   assign BTN3_changed = (BTN3_sample & !prev_BTN3_sample);
   assign BTN4_changed = (BTN4_sample & !prev_BTN4_sample);
   
   always @(posedge clk)
     begin
	if (BTN1_changed)
	  LD1 <= ~LD1;
	else	
	  if (BTN2_changed)
	    LD2 <= ~LD2;
	  else
	    if (BTN3_changed)
	      LD3 <= ~LD3;
	    else
	      if (BTN4_changed)
		LD4 <= ~LD4;	
     end
   
   // assign {LD1, LD2, LD3, LD4} = {LD1_stat, LD2_stat, LD3_stat, LD4_stat};
   
endmodule
