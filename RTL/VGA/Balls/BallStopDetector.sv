
module BallStopDetector
 ( 

	input	int  ballA_vx,
	input	int  ballA_vy,

	input	int  ballB_vx,
	input	int  ballB_vy,	

	input	int  ballC_vx,
	input	int  ballC_vy,

	input	int  ballD_vx,
	input	int  ballD_vy,

	input logic ballA_enable,
	input logic ballB_enable,
	input logic ballC_enable,
	input logic ballD_enable,
		
	output logic balls_have_stoped
	

  ) ;

logic ballStopA;
logic ballStopB;
logic ballStopC;
logic ballStopD;

//test if all balls in game have stopped.  
always_comb begin
	
	ballStopA = ((ballA_vx==0 && ballA_vy==0) || ballA_enable==0);
	ballStopB = ((ballB_vx==0 && ballB_vy==0) || ballB_enable==0);
	ballStopC = ((ballC_vx==0 && ballC_vy==0) || ballC_enable==0);
	ballStopD = ((ballD_vx==0 && ballD_vy==0) || ballD_enable==0);
	
	balls_have_stoped = ballStopA && ballStopB && ballStopC && ballStopD ;
	
end	

 
endmodule

