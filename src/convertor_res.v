
module convertor_res						
(	input				 			clk_200MHz,
	input 			 			reset,		
	input			[4:0] 		mil_100,														
	input			[4:0] 		mil_010,
	input 		[4:0] 		mil_001,														
	input 		[4:0] 		mic_100,
	input 		[4:0] 		mic_010,
	input 		[4:0] 		mic_001,
	input 		[4:0] 		n_100,
	input 		[4:0] 		n_010,
	input 		[4:0] 		n_001,														
	output reg 	[19:0] 		result_for_indicators,														
	output reg 	[21:0]		result_for_cpm,													
	output reg 	[1:0] 		three_leds,													
	output reg 					end_measurement_out,															
	input 						end_measurement_in);															


always @(posedge clk_200MHz )

	begin	
	
		if (reset==0) three_leds = 2'b01;

		else 
		
		begin	
			
		if (end_measurement_in == 0) end_measurement_out = 0;	
		
		if (end_measurement_in)
		
		begin
		
		result_for_cpm [21:20] = mic_100 [1:0];	
		result_for_cpm [19:16] = mic_010 [3:0];
		result_for_cpm [15:12] = mic_001 [3:0];
		result_for_cpm [11:8] = n_100 [3:0];
		result_for_cpm [7:4] = n_010 [3:0];
		result_for_cpm [3:0] = n_001 [3:0];	
		end_measurement_out = 1;
		
		if (mil_100 > 0)
		
		begin
			result_for_indicators [19:15] = mil_100 & 5'b01111;
			result_for_indicators [14:10] = mil_010 & 5'b01111;
			result_for_indicators [9:5] = mil_001 | 5'b10000;
			result_for_indicators [4:0] = mic_100 & 5'b01111;
			three_leds [1:0] = 2'b11;
		end
		
			else 
			
			begin	
			
				if (mil_010 > 0)
				
				begin
				result_for_indicators [19:15] = mil_010&5'b01111;
				result_for_indicators [14:10] = mil_001|5'b10000;
				result_for_indicators [9:5] = mic_100&5'b01111;
				result_for_indicators [4:0] = mic_010&5'b01111;
				three_leds [1:0] = 2'b11;
				end
				
				else
			
				begin	
				
					if (mil_001 > 0)
					
					begin
					result_for_indicators [19:15] = mil_001|5'b10000;
					result_for_indicators [14:10] = mic_100&5'b01111;
					result_for_indicators [9:5] = mic_010&5'b01111;
					result_for_indicators [4:0] = mic_001&5'b01111;
					three_leds [1:0] = 2'b11;
					end
					
				else 
				
					begin	
					
						if (mic_100 > 0)
						
						begin
						result_for_indicators [19:15] = mic_100&5'b01111;
						result_for_indicators [14:10] = mic_010&5'b01111;
						result_for_indicators [9:5] = mic_001|5'b10000;
						result_for_indicators [4:0] = n_100&5'b01111;
						three_leds [1:0] = 2'b10;
						end
						
					else 
					
						begin
						
							if (mic_010 > 0)
							
							begin
							result_for_indicators [19:15] = mic_010&5'b01111;
							result_for_indicators [14:10] = mic_001|5'b10000;
							result_for_indicators [9:5] = n_100&5'b01111;
							result_for_indicators [4:0] = n_010&5'b01111;
							three_leds [1:0] = 2'b10;
							end
							
						else
						
							begin	
							
							if (mic_001 > 0)
							
								begin
								result_for_indicators [19:15] = mic_001|5'b10000;
								result_for_indicators [14:10] = n_100&5'b01111;
								result_for_indicators [9:5] = n_010&5'b01111;
								result_for_indicators [4:0] = n_001&5'b01111;
								three_leds [1:0] = 2'b10;
								end
								
							else 
							
								begin
								result_for_indicators [19:15] = 0;
								result_for_indicators [14:10] = n_100&5'b01111;
								result_for_indicators [9:5] = n_010|&5'b01111;
								result_for_indicators [4:0] = n_001&5'b01111;
								three_leds [1:0] = 2'b00;
								end
								
							end
							end	
						end		
					end		
				end		
			end		
		end				
	end		
  
endmodule

