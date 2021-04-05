module BallInHole
 ( 
	input	logic  ballA_req, 
	input	logic  ballB_req,
	input	logic  ballC_req, 
	input	logic  ballD_req,
	
	input logic  hole1_req,
	input logic  hole2_req,
	input logic  hole3_req,
	input logic  hole4_req,
	input logic  hole5_req,
	input logic  hole6_req,

	output	logic	ballA_scored,
	output	logic	ballB_scored,
	output	logic	ballC_scored,
	output	logic	ballD_scored
  ) ;

  logic hole_req;

 //test if a ball is colliding with any hole.
always_comb begin
	hole_req = hole1_req || hole2_req || hole3_req || hole4_req || hole5_req || hole6_req ;
	
	ballA_scored = ballA_req && hole_req;
	ballB_scored = ballB_req && hole_req;
	ballC_scored = ballC_req && hole_req;
	ballD_scored = ballD_req && hole_req;
	
end			
		
endmodule 