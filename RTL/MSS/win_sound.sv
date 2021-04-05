//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	win_sound	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic start_of_frame,
					
					input		logic	win_tone,

					output	logic	[3:0] tone_key,
					output 	logic sound_enable
					
);

//given the signal "win_tone", this module will produce the notes for
//A C major chord ("win sound")

parameter N_FRAMES_SPEED = 6; //speed of music - lower = faster.
const logic[3:0] DO = 4'b0000; //keypad notes.
const logic[3:0] MI = 4'b0100;
const logic[3:0] SOL = 4'b0111;

logic [7:0] frame_counter;
enum logic [1:0] {s_idle, s_win1, s_win2, s_win3} cur_st, nxt_st;


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		cur_st <= s_idle;
		frame_counter <= 8'b0;
	end
	else begin
		if(cur_st != nxt_st) //reset counter every note change.
			frame_counter <= 8'b0;
		else begin
			if (start_of_frame)
					frame_counter <= frame_counter+1;	
		end
		cur_st <= nxt_st;
	end
end

always_comb 
begin
	nxt_st = cur_st; //default;
	sound_enable = 1'b0;
	tone_key = DO;
	case (cur_st)
					
		s_idle: begin
			if(win_tone)
				nxt_st = s_win1;
		end 
			
		s_win1: begin
			tone_key = DO;
			if(frame_counter == N_FRAMES_SPEED)
				nxt_st = s_win2;
			else
				sound_enable = 1'b1;
		end
		
		s_win2: begin
			tone_key = MI;
			if(frame_counter == N_FRAMES_SPEED)
				nxt_st = s_win3;
			else
				sound_enable = 1'b1;		
		end
		
		s_win3: begin
			tone_key = SOL;
			if(frame_counter == N_FRAMES_SPEED)
				nxt_st = s_idle;
			else
				sound_enable = 1'b1;		
		end
	endcase	
							
end

endmodule


