

module	rectangle_bar	(	
					input		logic	clk,
					input		logic	resetN,
					input 	int power,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					output	logic	drawing_request,
					output	logic	[7:0]	RGBOUT
);

logic [7:0] OBJECT_COLOR_A = 8'b11100000; // rectangle frame
parameter  logic [7:0] OBJECT_COLOR_B = 8'b11111110; 
logic [7:0] OBJECT_COLOR_C = 8'b10000000; // 
logic [7:0] OBJECT_COLOR = 8'b00000000; //black  
parameter  logic [7:0] OBJECT_COLOR_D = 8'b11100110; 



logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;

localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;// bitmap of a light color

assign RGBOUT =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 

always_ff@(posedge clk or negedge resetN)
begin


if(!resetN) begin
	drawing_request <= 1'b0;
	redBits <= DARK_COLOR ;	
	greenBits <= DARK_COLOR  ;	
	blueBits <= DARK_COLOR ;
end
else begin
	
//=========rectangle frame ============================
	
if ((((pixelY >= 5) && (pixelY <= 10)) && ((pixelX >= 70) && (pixelX <= 190))) ||
 (((pixelY >= 20) && (pixelY <= 25)) && ((pixelX >= 70) && (pixelX <= 190))) ||
 (((pixelY >= 10) && (pixelY <= 20)) && ((pixelX >= 70) && (pixelX <= 75))) ||
 (((pixelY >= 10) && (pixelY <= 20)) && ((pixelX >= 190) && (pixelX <= 190))))
	begin
		redBits <= DARK_COLOR ;	
		greenBits <= DARK_COLOR ;	
		blueBits <= DARK_COLOR ;
		drawing_request	<=	1'b1;
	end
//========= internal color =============================
	
else if (((pixelY >= 10) && (pixelY <= 20)) && ((pixelX >= 70) && (pixelX <= 70+power)))
	begin
	greenBits <= 3'b000 ;
	blueBits <= 2'b00 ;
	drawing_request <=	1'b1 ;
	if ((power >= 0) && (power < 15))
				redBits <= 3'b001 ;	
	if ((power >= 15) && (power < 30))
				redBits <= 3'b010 ;
	if ((power >= 30) && (power < 45))
				redBits <= 3'b011 ;
	if ((power >= 45) && (power < 60))
				redBits <= 3'b100 ;
	if ((power >= 60) && (power < 75))
				redBits <= 3'b101 ;
	if ((power >= 75) && (power < 90))
				redBits <= 3'b110 ;
	if ((power >= 90) && (power < 105))
				redBits <= 3'b111 ;
	if ((power >= 105) && (power < 120))
				redBits <= 3'b111 ;

	end

else begin
	drawing_request	<=	1'b0;
	end

end
end 

endmodule



