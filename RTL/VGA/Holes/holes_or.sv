//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	holes_or	(	
	
					// holeA
					input 	logic [7:0] holeA_VGA,
					input 	logic holeA_DrawingRequest ,
					
					// holeB
					input 	logic [7:0] holeB_VGA,
					input 	logic holeB_DrawingRequest ,
					
					// holeC
					input 	logic [7:0] holeC_VGA,
					input 	logic holeC_DrawingRequest ,
					
					// holeD
					input 	logic [7:0] holeD_VGA,
					input 	logic holeD_DrawingRequest ,
				
					// holeE
					input 	logic [7:0] holeE_VGA,
					input 	logic holeE_DrawingRequest ,
				
					// holeF
					input 	logic [7:0] holeF_VGA,
					input 	logic holeF_DrawingRequest ,
		

					output	logic	drawingRequest,
					output	logic	[7:0]	 RGBout 
					
);

assign drawingRequest = ( holeA_DrawingRequest || holeB_DrawingRequest || holeC_DrawingRequest ||
									holeD_DrawingRequest || holeE_DrawingRequest || holeF_DrawingRequest ) ;
								

assign RGBout = ( holeA_VGA || holeB_VGA || holeC_VGA || holeD_VGA || holeE_VGA || holeF_VGA) ;
								
		
endmodule


