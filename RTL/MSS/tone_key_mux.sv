//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	tone_key_mux	(	
					
					input		logic	sound_enable1,
					input		logic	sound_enable2,
					input	logic	[3:0] tone_key1,
					input	logic	[3:0] tone_key2,

					output 	logic sound_enable,
					output	logic	[3:0] tone_key
								
);


always_comb 
begin
	sound_enable = sound_enable1 || sound_enable2;
	if(sound_enable1) 
		tone_key = tone_key1;
	else if(sound_enable2)
		tone_key = tone_key2;
	else
		tone_key = tone_key1;
							
end

endmodule


