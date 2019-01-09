
module CPM_output											
( 	input 		clk_200MHz,
	input 		reset,
	input			end_measurement,				
	input	[21:0] 	result_for_cpm,				// input data
	output reg [22:0] 	cpm,								// binary decimal code out
	output reg  		access);							// start next measure 

	reg [21:0]		cpm_var;							
	reg [10:0] 	counter_10mc;  			


always @(posedge clk_200MHz)
	begin
		if (reset==0)
			begin
			cpm  <= 0;
			counter_10mc <= 0;
			access <= 1;
			end
		else
			begin
				if (end_measurement) 
					begin
					cpm_var  <= result_for_cpm;			
					access <= 0;
					if (counter_10mc == 0) counter_10mc <= 1;								
					if(counter_10mc == 1)  cpm [21:0] <= cpm_var;							 			
					if (counter_10mc == 100) cpm [22] <= 1; 	
					if (counter_10mc == 11'b11111111110)
						begin
						cpm [22] <= 0;			
						counter_10mc <= 0;			
						access <= 1;
						end
					if (counter_10mc > 0) counter_10mc <= counter_10mc + 11'b00000000001; 
					end
			end
	end		

endmodule

