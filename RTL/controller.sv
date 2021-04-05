module controller
 ( 
					input	logic	clk,
					input	logic	resetN,
					input logic shot_made ,
					input logic all_balls_stopped ,
					input logic ball_white_in_hole ,
					input logic ball_red_in_hole ,
					input logic ball_blue_in_hole ,
					input logic ball_black_in_hole ,
					
					output logic gameOverFlag,
					output logic gameWinFlag,
					output logic [7:0] shots_counter,
					output logic resetCueN,
					output logic resetWhiteBallN,
					output logic cueEnable
);

enum logic [2:0] {idle ,ballMove , gameOver, cueMove , gameWin ,whiteIn} cur_st, nxt_st ; 
logic [7:0] counter ; //shot counter
logic redScored ;  //registers to save state of each ball.
logic blueScored ;  
logic blackScored ;
logic whiteScored ;

//switch states of StateMachine and save balls game state.
always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin
		cur_st = idle ;	
		counter = 8'b0;
		redScored = 1'b0 ;
		blueScored = 1'b0 ;
		blackScored = 1'b0 ;
		whiteScored = 1'b0 ;
			
	end
	else begin
	
		 cur_st = nxt_st ;
		if (shot_made == 1'b1) // shots counter
			counter = counter + 1 ;
		if (ball_red_in_hole == 1'b1)
			redScored = 1'b1 ;
		if (ball_blue_in_hole == 1'b1)
			blueScored = 1'b1 ;
		if (ball_black_in_hole == 1'b1)
			blackScored = 1'b1 ;		
		if (cur_st == whiteIn)
			whiteScored = 1'b0 ;	
		else if (ball_white_in_hole == 1'b1)
			whiteScored = 1'b1 ;		
		
	end	//else	
end //always
  
 
always_comb // Update next state and outputs
begin	

	nxt_st = cur_st ;	// default values
	gameOverFlag = 1'b0 ; 
	gameWinFlag = 1'b0 ;
	resetCueN = 1'b1 ;
	resetWhiteBallN = 1'b1 ;
	cueEnable = 1'b1 ;

	case (cur_st) 
	
		idle : begin
		 	nxt_st = cueMove ;
		end //idle
	
		cueMove : begin
			if (whiteScored == 1'b1) begin 
				if(redScored == 1'b1 && blueScored == 1'b1 && blackScored == 1'b1)
					nxt_st = gameOver; //white has gone in with the black ball
				else
					nxt_st = whiteIn; //white has gone in and needs to get out
			end	

			else if (blackScored == 1'b1) begin
				if(redScored == 1'b0 || blueScored == 1'b0)
					nxt_st = gameOver; //black has gone in but not last.
				else
					nxt_st = gameWin; //black has gone in last - win.
			end
		
			else if (shot_made) // last else nothnig changed on board
				nxt_st = ballMove ;
		end
				 
		whiteIn : begin
			resetWhiteBallN = 1'b0 ;	
			resetCueN = 1'b0 ;
			nxt_st = cueMove ;
		end
	
		ballMove : begin
			cueEnable = 1'b0;
			if(all_balls_stopped == 1'b1) begin
				cueEnable = 1'b1 ;
				resetCueN = 1'b0 ; //mili.
				nxt_st = cueMove;
			end
		end
			
		gameOver : begin
			gameOverFlag = 1'b1 ;
		end
							
		gameWin : begin
			gameWinFlag = 1'b1 ;					
		end
	
	endcase
	
end //always comb end

assign shots_counter = counter;

endmodule