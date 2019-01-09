
module ivi_i
(input 		clk_200MHz,
input [3:0]	rf,				// signal for measure and sync signal										
input [2:0] 	regime,			// regime choice			
input			reset,
input 		polarity,							
input			access,							
output reg	[4:0] mil_100,			// hundreds of milliseconds	
output reg	[4:0] mil_010,			// tens of  milliseconds
output reg	[4:0] mil_001,			// units of milliseconds	
output reg	[4:0] mic_100,			// micro			
output reg	[4:0] mic_010,
output reg	[4:0] mic_001,								
output reg	[4:0] n_100,			// nano				
output reg	[4:0] n_010,
output reg	[4:0] n_001,								
output reg       end_measurement
);
			
reg [3:0]		delay_counter;
reg [4:0]		mil_100_var;
reg [4:0]		mil_010_var;
reg [4:0] 		mil_001_var;
reg [4:0] 		mic_100_var;
reg [4:0] 		mic_010_var;
reg [4:0] 		mic_001_var;
reg [4:0] 		n_100_var;
reg [4:0] 		n_010_var;				
reg [4:0] 		n_001_var;							
reg 			sinc_var;								
reg [2:0] 		Duration_x;	
reg [2:0] 		Period_x;
reg [2:0] 		Delay_x;								
reg [1:0] 		Duration_z;							
reg [1:0] 		sync_front;				
reg [2:0] 		signal_1_front;
reg [2:0] 		signal_2_front;				 
reg [4:0]	 	nanosec_storage;
reg			access_var;								
always @(posedge clk_200MHz)

	begin
	
	if (reset == 0)
	
		begin					
		mil_100 <= 0;
		mil_010 <= 0;
		mil_001 <= 0;
		mic_100 <= 5'b00110;							
		mic_010 <= 5'b00101;
		mic_001 <= 5'b00111;
		n_100 <= 5'b01000;
		n_010 <= 5'b00000;
		n_001 <= 5'b00000;
		mil_100_var <= 0;
		mil_010_var <= 0;
		mil_001_var <= 0;
		mic_100_var <= 0;
		mic_010_var <= 0;
		mic_001_var <= 0;
		n_100_var <= 0;
		n_010_var <= 0;
		n_001_var <= 0;
		Duration_x <= 0;
		Period_x <= 0;
		Delay_x <= 0;
		Duration_z <= 0;
		end_measurement <= 1;
		sync_front <= 0;
		signal_1_front <= 0;
		signal_2_front <= 0;
		nanosec_storage <= 0;
		delay_counter <= 4'b1111;
		access_var <= 0;
		end

	else 
	
		begin	
		sync_front <= {sync_front[0], sinc_var};		
		signal_1_front <= {signal_1_front[1:0], rf[0]};		
		signal_2_front <= {signal_2_front[1:0], rf[1]};
		
		if (polarity) sinc_var <= rf[2];										
		else sinc_var <= rf[3];
		
		if(access == 1) access_var <= 0;
		
		else 
		
			begin
			access_var <= 1;
			mil_100_var <= 0;
			mil_010_var <= 0;
			mil_001_var <= 0;
			mic_100_var <= 0;
			mic_010_var <= 0;
			mic_001_var <= 0;
			n_100_var <= 0;
			n_010_var <= 0;
			n_001_var <= 0;
			end_measurement <= 0;
			Duration_x <= 0;
			Period_x <= 0;
			Delay_x <= 0;
			Duration_z <= 0;
			delay_counter <= 4'b1111;
			nanosec_storage <= 0;
			end
			
		if(access_var == 0)
		
			begin
			
				case (regime)								
			
			3'b011:											
				begin		
				
				if (sync_front == 2'b01) 
				
					begin
					if (Duration_x == 0) Duration_x <= 1;																
					end
				
				if (signal_1_front == 3'b011)						
					begin
					if (Duration_x == 1)	Duration_z <= 1;							
					end	
																							
				if (Duration_z == 1)	
				
					begin		
					
					if(signal_1_front == 3'b110)
						begin					
						nanosec_storage <= n_001_var;
						delay_counter <= 0;
						Duration_x <= 3;
						Duration_z <= 0;
						end
					else n_001_var <= n_001_var + 5'b00001;
					
					end			
																							
																			
				if (delay_counter < 4'b0110) delay_counter <= delay_counter + 4'b0001;												
														
				if (delay_counter == 4'b0110)	
				
					begin
					mil_100 <= mil_100_var;
					mil_010 <= mil_010_var;
					mil_001 <= mil_001_var;
					mic_100 <= mic_100_var;
					mic_010 <= mic_010_var;
					mic_001 <= mic_001_var;
					n_100 <= n_100_var;
					n_010 <= n_010_var;
					if (nanosec_storage == 0) n_001 <= 5'b00101;
					else n_001 <= 0;
					end_measurement <= 1;
					delay_counter <= 4'b0111;
					end	
					
				end		
				
			3'b101:											
				begin
			
				if (sync_front == 2'b01)
				
					begin
					if (Period_x == 0) Period_x <= 1;																						
					end
						
				if (Period_x == 1)
				
					begin
					
						if (signal_1_front == 3'b111)	
						
						begin
						Period_x <= 2;
						end	
						
					end			
				
				if (Period_x == 2)
				
					begin
					n_001_var <= n_001_var + 5'b00001;
					if (signal_1_front == 3'b000) Period_x <= 3;
					end
				
				if (Period_x == 3) 
				
					begin
					n_001_var <= n_001_var + 5'b00001;
					if (signal_1_front == 3'b111) Period_x <= 4;
					end			
				
				if (Period_x == 4)
				
					begin
					delay_counter <= 0;
					Period_x <= 5;	
					nanosec_storage <= n_001_var;														
					end
				
				if (delay_counter < 4'b0110) delay_counter <= delay_counter + 4'b0001; 												
					
				if (delay_counter == 4'b0110)		
				
					begin
					mil_100 <= mil_100_var;
					mil_010 <= mil_010_var;
					mil_001 <= mil_001_var;
					mic_100 <= mic_100_var;
					mic_010 <= mic_010_var;
					mic_001 <= mic_001_var;
					n_100 <= n_100_var;
					n_010 <= n_010_var;
					if (nanosec_storage == 0) n_001 <= 5'b00101;
					else n_001 <= 0;
					end_measurement <= 1;
					delay_counter <= 4'b0111;
					end		
					
				end						
						
		3'b110:											
			begin			
					
				if (sync_front == 2'b01) 
				
					begin
					if (Delay_x == 0) Delay_x <= 1;
					end
					
				if (signal_1_front == 3'b011)
				
					begin
					if (Delay_x == 1)	Delay_x <= 2;			
					end
						
				if (Delay_x == 2)	
				
					begin
					
					if (signal_2_front == 3'b011)
						begin
						nanosec_storage <= n_001_var;
						delay_counter <= 4'b0001;
						Delay_x <= 3;
						end
						
					else n_001_var <= n_001_var + 5'b00001;
					
					end	
					
				if (delay_counter < 4'b0110) delay_counter <= delay_counter + 4'b0001; 								
				
				if (delay_counter == 4'b0110)
				
					begin
					mil_100 <= mil_100_var;
					mil_010 <= mil_010_var;
					mil_001 <= mil_001_var;
					mic_100 <= mic_100_var;
					mic_010 <= mic_010_var;
					mic_001 <= mic_001_var;
					n_100 <= n_100_var;
					n_010 <= n_010_var;
					if (nanosec_storage == 0) n_001 <= 5'b00101;
					else n_001 <= 0;
					end_measurement <= 1;
					delay_counter <= 4'b0111;
					end	
					
				end
				
		endcase
	
	
				if (n_001_var > 0)
				
					begin
					n_001_var <= 0;
					n_010_var <= n_010_var + 5'b00001;
					end
					
				if (n_010_var > 9)
				
					begin
					n_010_var <= 0;
					n_100_var <= n_100_var + 5'b00001;
					end
					
				if (n_100_var > 9)
				
					begin
					n_100_var <= 0;
					mic_001_var <= mic_001_var + 5'b00001;
					end
					
				if (mic_001_var > 9)
				
					begin
					mic_001_var <= 0;
					mic_010_var <= mic_010_var + 5'b00001;
					end
					
				if (mic_010_var > 9)
				
					begin
					mic_010_var <= 0;
					mic_100_var <= mic_100_var + 5'b00001;
					end
					
				if (mic_100_var>9)
				
					begin
					mic_100_var <= 0;
					mil_001_var <= mil_001_var + 5'b00001;
					end
					
				if (mil_001_var > 9)
				
					begin
					mil_001_var <= 0;
					mil_010_var <= mil_010_var + 5'b00001;
					end
					
				if (mil_010_var > 9)
				
					begin
					mil_010_var <= 0;
					mil_100_var <= mil_100_var + 5'b00001;
					end	
					
				if (mil_100_var > 9)	mil_100_var <= 0;
		end			
end
end	

endmodule



