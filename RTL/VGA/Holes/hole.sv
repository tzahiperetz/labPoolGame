


module	hole	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,

					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

parameter  int OBJECT_RADIUS = 25;
parameter  logic [7:0] OBJECT_COLOR = 8'b00000000; //black  
parameter 	logic	[10:0] centerX = 8'b00100000; //position on the screen 
parameter 	logic	[10:0] centerY = 8'b00100000;
 
int centerDist ;  
int maxDistSqure ;
logic insideBracket ; 

// Calculate object boundaries
assign centerDist = (pixelX-centerX)*(pixelX-centerX) + (pixelY-centerY)*(pixelY-centerY);
assign maxDistSqure = OBJECT_RADIUS * OBJECT_RADIUS;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b1; 
		drawingRequest	<=	1'b0;
	end
	else begin 
	
		insideBracket  = 	 ( centerDist <= maxDistSqure )  ; 
		
		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
		end 
			else begin  
			drawingRequest <= 1'b0 ;// transparent color 
		end 
		
	end
end 
endmodule 