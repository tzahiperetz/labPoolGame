module BallCollision_calc_logic	
 ( 
	input	int  ballAB_x, 
	input	int  ballAB_y,
	input	int  ballAB_vx,
	input	int  ballAB_vy,
	
	output 	int  AB_squre_dist,
	output 	int  AB_nxt_squre_dist,	
	output 	int  inter_x,
	output 	int  inter_y

  ) ;

// Calculating next velocity of 2 colliding balls.
// calculating (vector notations):
//	V1' = V1 - ( < V1-V2, X1-X2> / ||X1-X2||^2 ) * (X1-X2).
// as seen in elastic collision.
//USING MULTIPLIER for precision - assuming in/out positions are multiplied, velocity isn't.

int inner_prod;
	
//AB = X1 - X2
//ABv = V1 - V2
//inter = <V1-V2, X1-X2> * (X1-X2)	(this is calculated outside)
//AB_squre_dist = ||X1-X2||^2
//AB_nxt_squre_dist == ||(X1+V1) - (X2+V2)||^2
	
always_comb begin

	AB_squre_dist = ballAB_x*ballAB_x + ballAB_y*ballAB_y;
	AB_nxt_squre_dist = (ballAB_x+ballAB_vx)*(ballAB_x+ballAB_vx) + (ballAB_y+ballAB_vy)*(ballAB_x+ballAB_vy);	
	inner_prod = ((ballAB_vy * ballAB_y) + (ballAB_vx * ballAB_x))/4; // the (/4) is to avoid overflow.
	inter_x = ballAB_x * inner_prod;
	inter_y = ballAB_y * inner_prod;
	
	end
 
endmodule



module BallCollision_calc_mux
 ( 
	input logic clk,
	input logic resetN,
 
	input	int  ballAB_x, 
	input	int  ballAB_y,
	input	int  ballAB_vx,
	input	int  ballAB_vy,
	
	input	int  ballBC_x, 
	input	int  ballBC_y,
	input	int  ballBC_vx,
	input	int  ballBC_vy,	
	
	input	int  ballAC_x, 
	input	int  ballAC_y,
	input	int  ballAC_vx,
	input	int  ballAC_vy,
		
	input	int  ballAD_x, 
	input	int  ballAD_y,
	input	int  ballAD_vx,
	input	int  ballAD_vy,
	
	input	int  ballBD_x, 
	input	int  ballBD_y,
	input	int  ballBD_vx,
	input	int  ballBD_vy,
	
	input	int  ballCD_x, 
	input	int  ballCD_y,
	input	int  ballCD_vx,
	input	int  ballCD_vy,
	
	output 	int  AB_squre_dist,
	output 	int  AB_nxt_squre_dist,	
	output 	int  inter_x,
	output 	int  inter_y,
	
	output logic[3:0] collision
	

  ) ;

parameter N_COLLISIONS=3;
logic[3:0] count;


int  ballAB_x_wire;
int  ballAB_y_wire;
int  ballAB_vx_wire;
int  ballAB_vy_wire;

int  AB_squre_dist_wire;
int  AB_nxt_squre_dist_wire;
int  inter_x_wire;
int  inter_y_wire;


BallCollision_calc_logic calc(.ballAB_x(ballAB_x_wire),
										.ballAB_y(ballAB_y_wire),
										.ballAB_vx(ballAB_vx_wire),
										.ballAB_vy(ballAB_vy_wire),
										.AB_squre_dist(AB_squre_dist_wire),
										.AB_nxt_squre_dist(AB_nxt_squre_dist_wire),
										.inter_x(inter_x_wire),
										.inter_y(inter_y_wire)
										);
	

//since multiplication is expensive, we muliptly each collision's data in different cycles. then "hand it out" to them by Mux. 
always_comb begin
	
	case(count)
		4'b0000: begin
			ballAB_x_wire = ballAB_x;
			ballAB_y_wire = ballAB_y;
			ballAB_vx_wire = ballAB_vx;
			ballAB_vy_wire = ballAB_vy;
			collision = 4'b0011;
		end
		4'b0001: begin
			ballAB_x_wire = ballAC_x;
			ballAB_y_wire = ballAC_y;
			ballAB_vx_wire = ballAC_vx;
			ballAB_vy_wire = ballAC_vy;
			collision = 4'b0101;
		end
		4'b0010: begin
			ballAB_x_wire = ballBC_x;
			ballAB_y_wire = ballBC_y;
			ballAB_vx_wire = ballBC_vx;
			ballAB_vy_wire = ballBC_vy;
			collision = 4'b0110;
		end
		4'b0011: begin
			ballAB_x_wire = ballAD_x;
			ballAB_y_wire = ballAD_y;
			ballAB_vx_wire = ballAD_vx;
			ballAB_vy_wire = ballAD_vy;
			collision = 4'b1001;
		end
		4'b0100: begin
			ballAB_x_wire = ballBD_x;
			ballAB_y_wire = ballBD_y;
			ballAB_vx_wire = ballBD_vx;
			ballAB_vy_wire = ballBD_vy;
			collision = 4'b1010;
		end
		4'b0101: begin
			ballAB_x_wire = ballCD_x;
			ballAB_y_wire = ballCD_y;
			ballAB_vx_wire = ballCD_vx;
			ballAB_vy_wire = ballCD_vy;
			collision = 4'b1100;
		end
		default: begin
			ballAB_x_wire = ballAB_x;
			ballAB_y_wire = ballAB_y;
			ballAB_vx_wire = ballAB_vx;
			ballAB_vy_wire = ballAB_vy;
			collision = 4'b0011;
		end
	endcase

	AB_squre_dist = AB_squre_dist_wire;
	AB_nxt_squre_dist = AB_nxt_squre_dist_wire;
	inter_x = inter_x_wire;
	inter_y = inter_y_wire;

end	

always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin
		count <= 4'b0000;
	end
	else 	begin
		if (count == N_COLLISIONS-1)
			count <= 4'b0000;
		else
			count <= count + 1;
	
	end
end
 
endmodule

