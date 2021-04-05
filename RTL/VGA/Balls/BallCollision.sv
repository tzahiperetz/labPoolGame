module BallCollision 	
 ( 
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,
 
	input	int  ballA_x, 
	input	int  ballA_y,
	input	int  ballA_vx,
	input	int  ballA_vy,
	input	int  ballB_x, 
	input	int  ballB_y,
	input	int  ballB_vx,
	input	int  ballB_vy,
	
	input logic ballA_draw_req,
	input logic ballB_draw_req,
	
	input 	int  AB_squre_dist,
	input 	int  AB_nxt_squre_dist,	
	input 	int  inter_x,
	input 	int  inter_y,
	input logic[3:0] collision_select,
	
	output logic collision,
	
	output	int  ballA_vx_next,
	output	int  ballA_vy_next,
	output	int  ballB_vx_next,
	output	int  ballB_vy_next,
	
	output int ABx,
	output int ABy,
	output int ABvx,
	output int ABvy
	

  ) ;

// Calculating next velocity of 2 colliding balls.
// calculating (vector notations):
//	V1' = V1 - ( < V1-V2, X1-X2> / ||X1-X2||^2 ) * (X1-X2).
// as seen in elastic collision.
//USING MULTIPLIER for precision - assuming in/out positions are multiplied, velocity isn't.

//AB = X1 - X2
//ABv = V1 - V2
//inter = <V1-V2, X1-X2> * (X1-X2)	(this is calculated outside)
//norm = ||X1-X2||^2 (const value)
//sub = inter / norm 
  
parameter RADIUS_P = 16; //ball radius must be power of 2
parameter COLLISION_SEL = 4'b0000; //signature of collision.
const int MULTIPLIER=64;
const int RADIUS = RADIUS_P*MULTIPLIER;
const int norm = RADIUS*RADIUS;

const int RADIUS_SQURE = RADIUS*RADIUS*4 + 1;


int sub_x;
int sub_y;

int inter_x_reg; //calculation registers to save (given by calc module)
int inter_y_reg;
int AB_squre_dist_reg;
int AB_nxt_squre_dist_reg;



logic[2:0] delay;
const logic[2:0] MAX_DELAY = 3'b100;

//get calculations from the calc module.
always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin
		inter_x_reg <= 0;
		inter_y_reg <= 0;
		AB_squre_dist_reg <= 0;
		AB_nxt_squre_dist_reg <= 0;
	end
	else begin
		if(collision_select == COLLISION_SEL) begin
			inter_x_reg <= inter_x;
			inter_y_reg <= inter_y;
			AB_squre_dist_reg <= AB_squre_dist;
			AB_nxt_squre_dist_reg <= AB_nxt_squre_dist;
		end
	end
end


//calculate next velocity of colliding balls.
always_comb begin

	ABx = ballA_x-ballB_x;
	ABy = ballA_y-ballB_y;
	ABvx = ballA_vx-ballB_vx;
	ABvy = ballA_vy-ballB_vy;
	
	sub_x = (inter_x_reg / norm);
	sub_y = (inter_y_reg / norm);
	ballA_vx_next = ballA_vx - sub_x;
	ballB_vx_next = ballB_vx + sub_x;
	ballA_vy_next = ballA_vy - sub_y;
	ballB_vy_next = ballB_vy + sub_y;

	
end
	
	

//	detect a collision between ball A and ball B.
//see report for more information about the conditions for collision.
always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin
		collision <= 1'b0;
		delay <= 0;
	end
	else 	begin
	
		collision <= 0; //default
			
		// collision while moving towards each other
		//AB_squre_dist = ||X1-X2||^2
		//AB_nxt_squre_dist == ||(X1+V1) - (X2+V2)||^2
		if (delay==0 && ( (AB_squre_dist_reg <= RADIUS_SQURE) || (ballA_draw_req && ballB_draw_req) )
				&& (AB_nxt_squre_dist_reg <= AB_squre_dist_reg) ) begin

			collision <= 1'b1 ;
			delay <= delay + 1;
		end
			
		else if (startOfFrame==1'b1) begin
			if (delay != 0) begin
				if(delay == MAX_DELAY)
					delay <= 0;
				else
					delay <= delay + 1;
			end
		end
		
		
	end

end
 
endmodule

