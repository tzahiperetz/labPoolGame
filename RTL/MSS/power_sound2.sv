//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	power_sound2	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic start_of_frame,
					
					input		logic	enable_music,

					output	logic	[3:0] tone_key,
					output 	logic sound_enable
					
);
//given the input "enable_music" play GOT music.
parameter N_FRAMES_SPEED = 6; //low number = fast playing.
const logic[3:0] DO = 4'b0000;
const logic[3:0] DO_DIEZ = 4'b0001;
const logic[3:0] RE_DIEZ = 4'b0011;
const logic[3:0] FA = 4'b0101;
const logic[3:0] DONT_CARE = 4'b1111;

const logic[2:0] N_EIGHTS = 3'b101; 

//this is actually our "sheet music" to play.
//every entry is 1 eighth long.
logic[0:7] [3:0] sheet_music= {

FA,
FA,
DO,
DO,
DO_DIEZ,
RE_DIEZ,
DONT_CARE,
DONT_CARE

};

logic [7:0] frame_counter; //slow clock
logic [2:0] tone_count;		//which note to play.


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		tone_count <= 3'b000;
		frame_counter <= 8'b0;
	end
	else begin
		if (start_of_frame) begin
			if(frame_counter == N_FRAMES_SPEED) begin
				frame_counter <= 8'b0;
				if(tone_count == N_EIGHTS)
					tone_count <= 0;
				else
					tone_count <= tone_count + 1;
			end
			else 
				frame_counter <= frame_counter+1;
		end	
	end
end

assign tone_key = sheet_music[tone_count];
assign sound_enable = enable_music;
							

endmodule


