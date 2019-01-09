module IO_registers
(input [3:0]		input_rf,
input				clk_200MHz,
input 			reset,
output reg[3:0]	 	rf_s
);

always @(posedge clk_200MHz)
begin
if (reset == 0)
begin
rf_s <= 0;
end

else rf_s <= input_rf;

end
endmodule
