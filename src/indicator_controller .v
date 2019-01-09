
module indicator_controller 
( 	input 		clk_200MHz,
	input 		reset,
	input	[18:0] 	one_indicator_time,						// counter input
	input	[1:0] 	mmcn_leds_in,			// mil, micro & nano indicator's input data
	input [19:0] 	displayed_number,		// input data
	output reg [7:0]	led_out, 				// output of the seven-segment indicator
	output reg [3:0] anode_activate,			// anode output
	output reg [2:0] mmcn);				// mil, micro & nano output
	reg	[1:0] 	led_activating_counter;			
	reg 	[4:0] 	led_bsd;							
	reg	[19:0] 	clk_100Hz;						
	reg 	[19:0] 	displayed_number_var;			
	reg	[1:0] 	mmcn_leds_var;						

 always @(posedge clk_200MHz)
	begin
		if (reset == 0)	displayed_number_var = 0;
		if(one_indicator_time == 19'b1000000000000000000)		// Copy data to variable
			begin
			mmcn_leds_var = mmcn_leds_in;				
			displayed_number_var = displayed_number;
			end
	end 
  
 always @(posedge clk_200MHz)
	begin																		// Dynamic indicators change		
		if(clk_100Hz>=999999)
			begin 
			clk_100Hz = 0;
			led_activating_counter = led_activating_counter + 2'b01;
			end
		else clk_100Hz = clk_100Hz + 20'b0000000000000000001;
	end

always @(posedge clk_200MHz)
   begin
        case(led_activating_counter)										// indicator selection
		  2'b00: begin
			anode_activate = 4'b1000; 					
			led_bsd [4:0] = displayed_number_var[19:15];
		
			case(led_bsd)
			5'b00000: led_out = 8'b10000001; // "0"     
			5'b00001: led_out = 8'b11001111; // "1" 
      		5'b00010: led_out = 8'b10010010; // "2" 
       		5'b00011: led_out = 8'b10000110; // "3" 
      		5'b00100: led_out = 8'b11001100; // "4" 
			5'b00101: led_out = 8'b10100100; // "5" 
			5'b00110: led_out = 8'b10100000; // "6" 
			5'b00111: led_out = 8'b10001111; // "7" 
			5'b01000: led_out = 8'b10000000; // "8"     
			5'b01001: led_out = 8'b10000100; // "9" 
			5'b10000: led_out = 8'b00000001; // "0."     
			5'b10001: led_out = 8'b01001111; // "1." 
			5'b10010: led_out = 8'b00010010; // "2." 
			5'b10011: led_out = 8'b00000110; // "3." 
			5'b10100: led_out = 8'b01001100; // "4." 
			5'b10101: led_out = 8'b00100100; // "5." 
			5'b10110: led_out = 8'b00100000; // "6." 
			5'b10111: led_out = 8'b00001111; // "7." 
			5'b11000: led_out = 8'b00000000; // "8."     
			5'b11001: led_out = 8'b00000100; // "9." 
			default:  led_out = 8'b10000001; // "0"
        	endcase	
         end
			
        2'b01: begin
            anode_activate = 4'b0100; 
            led_bsd [4:0] = displayed_number_var[14:10];
			
            case(led_bsd)
			5'b00000: led_out = 8'b10000001; // "0"     
			5'b00001: led_out = 8'b11001111; // "1" 
      		5'b00010: led_out = 8'b10010010; // "2" 
       		5'b00011: led_out = 8'b10000110; // "3" 
      		5'b00100: led_out = 8'b11001100; // "4" 
			5'b00101: led_out = 8'b10100100; // "5" 
			5'b00110: led_out = 8'b10100000; // "6" 
			5'b00111: led_out = 8'b10001111; // "7" 
			5'b01000: led_out = 8'b10000000; // "8"     
			5'b01001: led_out = 8'b10000100; // "9" 
			5'b10000: led_out = 8'b00000001; // "0."     
			5'b10001: led_out = 8'b01001111; // "1." 
			5'b10010: led_out = 8'b00010010; // "2." 
			5'b10011: led_out = 8'b00000110; // "3." 
			5'b10100: led_out = 8'b01001100; // "4." 
			5'b10101: led_out = 8'b00100100; // "5." 
			5'b10110: led_out = 8'b00100000; // "6." 
			5'b10111: led_out = 8'b00001111; // "7." 
			5'b11000: led_out = 8'b00000000; // "8."     
			5'b11001: led_out = 8'b00000100; // "9." 
			default:  led_out = 8'b10000001; // "0"
        	endcase	
         end
			
        2'b10: begin
            anode_activate = 4'b0010; 
            led_bsd  [4:0] = displayed_number_var[9:5];
				
        	 case(led_bsd)
			5'b00000: led_out = 8'b10000001; // "0"     
			5'b00001: led_out = 8'b11001111; // "1" 
      		5'b00010: led_out = 8'b10010010; // "2" 
       		5'b00011: led_out = 8'b10000110; // "3" 
      		5'b00100: led_out = 8'b11001100; // "4" 
			5'b00101: led_out = 8'b10100100; // "5" 
			5'b00110: led_out = 8'b10100000; // "6" 
			5'b00111: led_out = 8'b10001111; // "7" 
			5'b01000: led_out = 8'b10000000; // "8"     
			5'b01001: led_out = 8'b10000100; // "9" 
			5'b10000: led_out = 8'b00000001; // "0."     
			5'b10001: led_out = 8'b01001111; // "1." 
			5'b10010: led_out = 8'b00010010; // "2." 
			5'b10011: led_out = 8'b00000110; // "3." 
			5'b10100: led_out = 8'b01001100; // "4." 
			5'b10101: led_out = 8'b00100100; // "5." 
			5'b10110: led_out = 8'b00100000; // "6." 
			5'b10111: led_out = 8'b00001111; // "7." 
			5'b11000: led_out = 8'b00000000; // "8."     
			5'b11001: led_out = 8'b00000100; // "9." 
			default:  led_out = 8'b10000001; // "0"
        	endcase	
         end
			
        2'b11: begin
            anode_activate = 4'b0001; 
            led_bsd [4:0] = displayed_number_var[4:0];
				
   		 case(led_bsd)
			5'b00000: led_out = 8'b10000001; // "0"     
			5'b00001: led_out = 8'b11001111; // "1" 
      		5'b00010: led_out = 8'b10010010; // "2" 
       		5'b00011: led_out = 8'b10000110; // "3" 
      		5'b00100: led_out = 8'b11001100; // "4" 
			5'b00101: led_out = 8'b10100100; // "5" 
			5'b00110: led_out = 8'b10100000; // "6" 
			5'b00111: led_out = 8'b10001111; // "7" 
			5'b01000: led_out = 8'b10000000; // "8"     
			5'b01001: led_out = 8'b10000100; // "9" 
			5'b10000: led_out = 8'b00000001; // "0."     
			5'b10001: led_out = 8'b01001111; // "1." 
			5'b10010: led_out = 8'b00010010; // "2." 
			5'b10011: led_out = 8'b00000110; // "3." 
			5'b10100: led_out = 8'b01001100; // "4." 
			5'b10101: led_out = 8'b00100100; // "5." 
			5'b10110: led_out = 8'b00100000; // "6." 
			5'b10111: led_out = 8'b00001111; // "7." 
			5'b11000: led_out = 8'b00000000; // "8."     
			5'b11001: led_out = 8'b00000100; // "9." 
			default:  led_out = 8'b10000001; // "0"
        	endcase	
         end	
	     default: begin
				anode_activate = 4'b0001; 
				led_bsd = displayed_number[4:0];
			   end
				
        endcase 
   end

always @(posedge clk_200MHz)		
	begin
	
		case (mmcn_leds_var)	
		2'b11:
		     	begin
				mmcn = 3'b100;
		     	end
		2'b10:
		    	 begin
				mmcn = 3'b010;
		     	 end
		2'b01:
			 begin
				mmcn = 3'b111;
		      end
		2'b00:
			begin
				mmcn = 3'b001;
		     	end
		default:
			begin
				mmcn = 3'b111;
		    	end	
		endcase
	end
endmodule

