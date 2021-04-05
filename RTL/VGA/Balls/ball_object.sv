//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	ball_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input 	logic	[10:0] centerX, //position on the screen 
					input 	logic	[10:0] centerY,
					
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

parameter  int OBJECT_RADIUS = 16;
parameter  logic [7:0] OBJECT_COLOR = 8'b11111110; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int centerDist ;  
int maxDistSqure ;
logic insideBracket ; 

// Calculate object boundaries
assign centerDist = (pixelX-centerX)*(pixelX-centerX) + (pixelY-centerY)*(pixelY-centerY);
assign maxDistSqure = OBJECT_RADIUS * OBJECT_RADIUS;


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
	end
	else begin 
	 
		insideBracket  = 	 ( centerDist <= maxDistSqure )  ; 
		
		if (insideBracket ) // test if it is inside the circle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
		end 
		
		else begin  
			RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest <= 1'b0 ;// transparent color 
		end 
		
	end
end 
endmodule 