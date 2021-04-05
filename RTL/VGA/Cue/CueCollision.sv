module CueCollision 	
 ( 
	input logic clk,
	input logic resetN,
	
	input 	int closeEdgeX, //position of the cue
	input 	int closeEdgeY,
	input 	int farEdgeX, 
	input 	int farEdgeY,
	input logic shoot,
	input		int  power,

	output	int  ball_vx_next,
	output	int  ball_vy_next,
	output logic  collision

  ) ;


// parameter power = 100;
  
const int POWER_MULTIPLIER=16;

logic shot_made;
logic shot_made_d;
logic	shot_made_pulse;
	
/*
always_comb begin
		
	ball_vx_next = ((closeEdgeX - farEdgeX) * power) / POWER_MULTIPLIER;
	ball_vy_next = ((closeEdgeY - farEdgeY) * power) / POWER_MULTIPLIER;
		
	end */
	
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		
		shot_made <= 1'b0;
		shot_made_d <= 1'b0;
		shot_made_pulse <= 1'b0;

	end
	else begin
		shot_made_d <= shot_made;
		ball_vx_next = ((closeEdgeX - farEdgeX) * power) / POWER_MULTIPLIER;
		ball_vy_next = ((closeEdgeY - farEdgeY) * power) / POWER_MULTIPLIER;
			
		if (shot_made == 1'b0 && shoot == 1'b1) 
			shot_made <= 1'b1;
		
		if(shot_made_d == 1'b0 && shot_made == 1'b1)
			shot_made_pulse <= 1'b1;
		else
			shot_made_pulse <= 1'b0;
		
	
	end
end

assign collision = shot_made_pulse;
 
endmodule

