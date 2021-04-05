//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	back_ground_draw	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic	[7:0]	BG_RGB
);

const int	xFrameSize	=	639;
const int	yFrameSize	=	479;
const int 	innerFrame = 25;
const int 	outterFrame = 32;
const int	bracketOffset =	10;

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;

localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;// bitmap of a light color

assign BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR ;	 
	end 
	else begin
	
	// defaults 
		greenBits <= 3'b110 ; 
		redBits <= 3'b010 ;
		blueBits <= LIGHT_COLOR;
					
	// draw the yellow borders 
		if (pixelX <= innerFrame || pixelY <= innerFrame  || pixelX >= (xFrameSize-innerFrame) || pixelY >= (yFrameSize-innerFrame))
			begin 
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR ;	
				blueBits <= LIGHT_COLOR ;	// 3rd bit will be truncked
			end
		else if (pixelX <= outterFrame || pixelY <= outterFrame  || pixelX >= (xFrameSize-outterFrame) || pixelY >= (yFrameSize-outterFrame))
		begin
				redBits <= 3'b001 ;	
				greenBits <= 3'b010 ;
				blueBits <= 2'b00 ;

		end
	end; 	
end 

endmodule

