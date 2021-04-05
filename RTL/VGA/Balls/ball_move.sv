//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module	ball_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic collision,
					input int nxt_vx,
					input int nxt_vy,
					input logic enable_toggle, //when '1' ball dissapears.
					output	logic	[10:0]	centerX,// output the top left corner 
					output	logic	[10:0]	centerY,
					output int ball_x,
					output int ball_y,
					output int ball_vx,
					output int ball_vy,
					output logic ball_enable
					
);


// a module used to generate a ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 100;
parameter int INITIAL_Y_SPEED = 90;
parameter int RADIUS = 16;
parameter int FRICTION_FACTOR = 32;


const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int InnerFrame = 32 * MULTIPLIER;
const int	x_FRAME_SIZE	=	(639-RADIUS) * MULTIPLIER -InnerFrame;
const int	y_FRAME_SIZE	=	(479-RADIUS) * MULTIPLIER -InnerFrame;
const int RADIUS_MUL = RADIUS * MULTIPLIER;
const logic[7:0] MAX_COUNT = 8'd4;

int fric_x, fric_y; //friction
int Xspeed, centerX_tmp; // local parameters 
int Yspeed, centerY_tmp;
logic [7:0] friction_count; //slower clock
logic enable_reg;

//friction_calculation
always_comb begin
		fric_y = (Yspeed / FRICTION_FACTOR);
		fric_x = (Xspeed / FRICTION_FACTOR);
	if(Xspeed>0) begin
		fric_x = fric_x + 1;
	end
	else if(Xspeed<0) begin
		fric_x = fric_x - 1;				
	end
	
	if(Yspeed>0) begin
		fric_y = fric_y + 1;							
	end
	else if(Yspeed<0) begin
		fric_y = fric_y - 1;								
	end

end

// speed calculation  

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		Xspeed	<= INITIAL_X_SPEED;
		Yspeed	<= INITIAL_Y_SPEED;
	end
	else 	begin
	
			if (collision == 1'b1) begin // hit other ball
				Xspeed <= nxt_vx;
				Yspeed <= nxt_vy;
			end
			else if ((centerX_tmp <= RADIUS_MUL + InnerFrame) && (Xspeed < 0) ) // hit left border while moving right
				Xspeed <= -Xspeed ; 	
				
			else if ( (centerX_tmp >= x_FRAME_SIZE) && (Xspeed > 0 )) // hit right border while moving left
				Xspeed <= -Xspeed ;
				
			else if ((centerY_tmp <= RADIUS_MUL + InnerFrame ) && (Yspeed < 0 )) // hit top border heading up
				Yspeed <= -Yspeed ; 
			
			else if ( ( centerY_tmp >= y_FRAME_SIZE) && (Yspeed > 0 )) //hit bottom border heading down 
				Yspeed <= -Yspeed ; 
			
			else begin //no collision
				if (startOfFrame == 1'b1) begin
					if(friction_count == MAX_COUNT) begin
						friction_count <= 0;	
						
						if(Xspeed)
							Xspeed <= Xspeed - fric_x;
					
						if(Yspeed)
							Yspeed <= Yspeed - fric_y;
					end
					
					else
						friction_count <= friction_count +1;
					
				end
			end
			
	end
end


// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		centerX_tmp	<= INITIAL_X * MULTIPLIER;
		centerY_tmp	<= INITIAL_Y * MULTIPLIER;

	end
	else begin
		if (startOfFrame == 1'b1) begin // perform only 30 times per second 
			centerX_tmp  <= centerX_tmp + Xspeed; 
			centerY_tmp  <= centerY_tmp + Yspeed;
		end
	end
end

//enable ball sync
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		enable_reg = 1'b1;
	end
	else begin
		if (enable_toggle == 1'b1)
			enable_reg = 1'b0;
	end
end

assign ball_enable = enable_reg; 


//get a better (64 times) resolution using integer   
assign 	centerX = centerX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	centerY = centerY_tmp / MULTIPLIER ;
assign	ball_x = centerX_tmp;
assign	ball_y = centerY_tmp;
assign	ball_vx = Xspeed;
assign	ball_vy = Yspeed;


endmodule
