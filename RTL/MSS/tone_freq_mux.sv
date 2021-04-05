//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	tone_freq_mux	(	
					
					input		logic	sound_enable1,
					input		logic	sound_enable2,
					input	logic	[9:0] tone_freq1,
					input	logic	[9:0] tone_freq2,

					output 	logic sound_enable,
					output	logic	[9:0] tone_freq
					
					
);


always_comb 
begin
	sound_enable = sound_enable1 || sound_enable2;
	if(sound_enable1) 
		tone_freq = tone_freq1;
	else if(sound_enable2)
		tone_freq = tone_freq2;
	else
		tone_freq = tone_freq1;
							
end

endmodule


