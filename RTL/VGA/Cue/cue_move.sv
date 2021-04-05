//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module	cue_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input logic start_frame,
					
					input logic[10:0] ballX,
					input logic[10:0] ballY,
					
					input logic rotate_clockwise, 
					input logic rotate_anticlockwise, 
					
					
					output 	int closeEdgeX, //position of the ball on screen 
					output 	int closeEdgeY,
					output 	int farEdgeX, 
					output 	int farEdgeY
					
);


// a module used to generate the cue trajectory.
// calculation the 2 points (edges) defining our cue.
// close edge and far edge of the white ball.
parameter int OBJECT_RADIUS = 16;

const int LENGTH = OBJECT_RADIUS*8; // 2^7
const int ANGLE_MULTIPLIER = 16384; //2^14
const int MULTIPLIER = 64;
const int SIN_5 = 1428;
const int COS_5 = 16322;
const int ANGLE_MOVE = 5;


int closeEdgeX_tmp; //_tmp vars are just high precision values registers.
int closeEdgeY_tmp;
int farEdgeX_tmp;
int farEdgeY_tmp;

int ballX_ext; //_ext for signe extended.
int ballY_ext;

int angle ; // defined as int
logic [2:0] slow_factor; //slowing down the movement of the cue (signal from keyboard is too fast)

	
// position calculate 
always_ff@(posedge clk or negedge resetN)
begin

	
	if(!resetN) //at reset - cue is at 180 deg.
	begin //distance between close and far is 6*Radius
		closeEdgeX_tmp		<= - 2*OBJECT_RADIUS * MULTIPLIER;
		closeEdgeY_tmp		<= 0;
		farEdgeX_tmp		<= - LENGTH * MULTIPLIER;
		farEdgeY_tmp		<= 0;
		ballX_ext <= {21'b0, ballX};
		ballY_ext <= {21'b0, ballY};
		angle <= 180 ;
		slow_factor <= 3'b000;

	end
	else begin	 //calculate the position in relative to (0,0)		
	
		if ((rotate_clockwise || rotate_anticlockwise) && start_frame) begin
		
			slow_factor <= slow_factor + 1;
			
			if(slow_factor == 3'b000) begin

				if (rotate_clockwise ) begin //rotate 5 deg clockwise
					angle <= angle + ANGLE_MOVE;
					closeEdgeX_tmp <=  (( (closeEdgeX_tmp*COS_5) - (closeEdgeY_tmp*SIN_5) ) / ANGLE_MULTIPLIER);
					closeEdgeY_tmp <= ( ( (closeEdgeX_tmp*SIN_5) + (closeEdgeY_tmp*COS_5) ) / ANGLE_MULTIPLIER);
					farEdgeX_tmp <=  ((( (farEdgeX_tmp*COS_5) - (farEdgeY_tmp*SIN_5) ) / ANGLE_MULTIPLIER));
					farEdgeY_tmp <=  (( (farEdgeX_tmp*SIN_5) + (farEdgeY_tmp*COS_5) ) / ANGLE_MULTIPLIER);

				end
					
				else if  (rotate_anticlockwise ) begin //rotate 5 deg anti-clockwise
					if(angle == 0)
						angle <= 360 - ANGLE_MOVE;
					else
						angle <= angle - ANGLE_MOVE;
						
					closeEdgeX_tmp <=  (( (closeEdgeX_tmp*COS_5) + (closeEdgeY_tmp*SIN_5) ) / ANGLE_MULTIPLIER);
					closeEdgeY_tmp <= ( ( -(closeEdgeX_tmp*SIN_5) + (closeEdgeY_tmp*COS_5) ) / ANGLE_MULTIPLIER);
					farEdgeX_tmp <=  ((( (farEdgeX_tmp*COS_5) + (farEdgeY_tmp*SIN_5) ) / ANGLE_MULTIPLIER));
					farEdgeY_tmp <=  (( -(farEdgeX_tmp*SIN_5) + (farEdgeY_tmp*COS_5) ) / ANGLE_MULTIPLIER);
				end

			end
		
			else if (angle == 360) begin //2 "elses" for correcting calculation errors (caused by limited precision)
				angle <= 0;
				closeEdgeX_tmp		<= 2*OBJECT_RADIUS * MULTIPLIER;
				closeEdgeY_tmp		<= 0;
				farEdgeX_tmp		<= LENGTH * MULTIPLIER;
				farEdgeY_tmp		<= 0;
			end
			else if ( angle == 180) begin
				closeEdgeX_tmp		<= - 2*OBJECT_RADIUS * MULTIPLIER;
				closeEdgeY_tmp		<= 0;
				farEdgeX_tmp		<= - LENGTH * MULTIPLIER;
				farEdgeY_tmp		<= 0;
			end	
				  		
		end
	end
end

//add the offset to the cue position, given by the ball position.
assign closeEdgeX = ballX_ext  + (closeEdgeX_tmp / MULTIPLIER);
assign closeEdgeY = ballY_ext + (closeEdgeY_tmp / MULTIPLIER);
assign farEdgeX = ballX_ext + (farEdgeX_tmp / MULTIPLIER);
assign farEdgeY = ballY_ext + (farEdgeY_tmp / MULTIPLIER);


endmodule
