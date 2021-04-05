//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	cue_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input 	int closeEdgeX, //position of the ball on screen 
					input 	int closeEdgeY,
					input 	int farEdgeX, 
					input 	int farEdgeY,
					
					input logic cue_enable,
					
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

parameter  int OBJECT_RADIUS = 16;
parameter int WIDTH = 4;
parameter  logic [7:0] OBJECT_COLOR = 8'hE0 ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel
const int LENGTH = OBJECT_RADIUS*8;
const int SQUARE_LENGTH = LENGTH*LENGTH;
const int SQUARE_WIDTH = WIDTH*WIDTH;
const int SQURE_CENTER_LENGTH = SQUARE_LENGTH / 4;
 
logic insideBracket ;
int center_dist_square;
int line_dist_square;

int Xab;//temporary names for intemidiate calculations.
int Yab;
int XaYb;
int XbYa;
int dist_inter;
int pixelY_ext;
int pixelX_ext;
int centerX;
int centerY;

// Calculate object boundaries (see formula in report)
always_comb begin //close is B far is A
	pixelX_ext = {21'b0, pixelX};
	pixelY_ext = {21'b0, pixelY};
	Xab = farEdgeX - closeEdgeX;
	Yab = farEdgeY - closeEdgeY;
	XaYb = farEdgeX * closeEdgeY;
	XbYa = farEdgeY * closeEdgeX;
	dist_inter = Yab*pixelX_ext - Xab*pixelY_ext + XaYb - XbYa;
	line_dist_square = (dist_inter*dist_inter) / SQUARE_LENGTH;
	
	centerX = closeEdgeX+Xab/2;
	centerY = closeEdgeY+Yab/2;
	center_dist_square = (pixelX_ext-centerX)*(pixelX_ext-centerX) + (pixelY_ext-centerY)*(pixelY_ext-centerY);
	
end

//inside bracket if the pixel is withing "WIDTH" of the line (defined by 2 points), and within "CENTER_LENGTH" from center of the cue.
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
	end
	else begin 
		if (cue_enable) 
			insideBracket  = 	 ( line_dist_square <= SQUARE_WIDTH && center_dist_square<=SQURE_CENTER_LENGTH)  ; 
		else
			insideBracket = 1'b0;
		
		if (insideBracket ) // test if it is inside the rectangle 
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