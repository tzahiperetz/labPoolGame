//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	objects_mux	(	
					input		logic	clk,
					input		logic	resetN,
					// ballA 
					input		logic	[7:0] ballA_VGA, // two set of inputs per unit
					input		logic	ballA_DrawingRequest,
					// ballB
					input		logic	[7:0] ballB_VGA, // two set of inputs per unit
					input		logic	ballB_DrawingRequest,
					// ballC
					input		logic	[7:0] ballC_VGA, // two set of inputs per unit
					input		logic	ballC_DrawingRequest,
					// ballD
					input		logic	[7:0] ballD_VGA, // two set of inputs per unit
					input		logic	ballD_DrawingRequest,
					// Cue
					input 	logic [7:0] cue_VGA,
					input 	logic cue_DrawingRequest,
					//holes
					input 	logic [7:0] holes_VGA,
					input 	logic holes_DrawingRequest ,
					//powerbar
					input 	logic [7:0] powerBar_VGA,
					input 	logic powerBar_DrawingRequest ,
					//numbersA
					input 	logic [7:0] numbersA_VGA,
					input 	logic numbersA_DrawingRequest ,
					//numbersB
					input 	logic [7:0] numbersB_VGA,
					input 	logic numbersB_DrawingRequest ,
					//imoji
					input 	logic [7:0] imoji_VGA,
					input 	logic imoji_DrawingRequest ,
					//tryagain
					input 	logic [7:0] tryagain_VGA,
					input 	logic tryagain_DrawingRequest ,
					//yourscoreis 
					input 	logic [7:0] yourscoreis_VGA,
					input 	logic yourscoreis_DrawingRequest ,
					//yourscoreis 
					input 	logic [7:0] youwin_VGA,
					input 	logic youwin_DrawingRequest ,
					
					
					// background 
					input		logic	[7:0] backGroundRGB, 

					output	logic	[7:0] redOut, // full 24 bits color output
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
					
);

logic [7:0] tmpRGB;


assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};

//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (ballB_DrawingRequest == 1'b1 )   
			tmpRGB <= ballB_VGA;  //first priority
		else if (ballA_DrawingRequest == 1'b1 ) 
			tmpRGB <= ballA_VGA;
		else if (ballC_DrawingRequest == 1'b1 ) 
			tmpRGB <= ballC_VGA;
		else if (ballD_DrawingRequest == 1'b1 ) 
			tmpRGB <= ballD_VGA;
		else if (cue_DrawingRequest == 1'b1 )
			tmpRGB <= cue_VGA;
		else if (holes_DrawingRequest == 1'b1 )
			tmpRGB <= holes_VGA;
		else if (powerBar_DrawingRequest == 1'b1 )
			tmpRGB <= powerBar_VGA;
		else if (numbersA_DrawingRequest == 1'b1 )
			tmpRGB <= numbersA_VGA;
		else if (numbersB_DrawingRequest == 1'b1 )
			tmpRGB <= numbersB_VGA;
		else if (imoji_DrawingRequest == 1'b1 )
			tmpRGB <= imoji_VGA;
		else if (tryagain_DrawingRequest == 1'b1 )
			tmpRGB <= tryagain_VGA;
		else if (yourscoreis_DrawingRequest == 1'b1 )
			tmpRGB <= yourscoreis_VGA;
		else if (youwin_DrawingRequest == 1'b1 )
			tmpRGB <= youwin_VGA;
			
		
			else
			tmpRGB <= backGroundRGB ; // last priority 
		end ; 
	end

endmodule


