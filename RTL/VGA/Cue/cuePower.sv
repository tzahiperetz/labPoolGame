module cuePower
 ( 
	input logic clk,
	input logic resetN,
	input logic startOfFrame,
	input	logic spacePressed, 
	input logic spacePressedOff,

	output	int	power
  ) ;

  
const int POWER_MAX=120;
const int POWER_MIN=2;

logic startOfFrame_d ; //startOfFrame_delayed
logic spacePressed_d ; //spacePressed_delayed
logic[1:0] flag; // counting direction



always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		power	<= 1;
		startOfFrame_d <= 0 ;
		flag <= 0 ;
	end
	else begin
		startOfFrame_d  <= startOfFrame ; // generate a delay of one clock 
		spacePressed_d  <= spacePressed ;
		
		if (power == (POWER_MAX-2)) begin
			flag <= 2 ;
			end
		if (power == POWER_MIN) begin
			flag <= 0 ;
			end
		
		if (spacePressed ==1'b1 && startOfFrame_d == 1'b1 && startOfFrame == 1'b0  && (power < POWER_MAX)) begin // perform only 30 times per second 
			power  <= power + 1-flag; 
		end
		if (spacePressed_d==1'b0 && spacePressed==1'b1) begin
			power <= 1 ;
			flag <= 0 ;
		end
		end
	end
  
 endmodule 