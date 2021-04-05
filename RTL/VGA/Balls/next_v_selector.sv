//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module	next_v_selector	(	
 
					input	logic	collision1,  
					input logic collision2,
					input	logic	collision3,  
					input logic collision4,
					input int nxt_vx_1,
					input int nxt_vy_1,
					input int nxt_vx_2,
					input int nxt_vy_2,
					input int nxt_vx_3,
					input int nxt_vy_3,
					input int nxt_vx_4,
					input int nxt_vy_4,					
					
					
					output logic collision,
					output int nxt_vx,
					output int nxt_vy
					
);


// a module used to select a ball velocity (calculation in some collision module). if collision signal is '0', 
//default velocity will be selected in ball move module.  

always_comb begin

	if (collision1) begin
		nxt_vx = nxt_vx_1;
		nxt_vy = nxt_vy_1;
	end
	else if (collision2) begin
		nxt_vx = nxt_vx_2;
		nxt_vy = nxt_vy_2;
	end
	else if (collision3) begin
		nxt_vx = nxt_vx_3;
		nxt_vy = nxt_vy_3;
	end
	else if (collision4) begin
		nxt_vx = nxt_vx_4;
		nxt_vy = nxt_vy_4;
	end
	else begin
		nxt_vx = 0;
		nxt_vy = 0;
	end

end

assign collision = (collision1 || collision2 || collision3 || collision4);

endmodule
