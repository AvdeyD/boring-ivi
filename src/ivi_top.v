
module ivi_top(
	reset,
	polarity,
	inclk0,
	input_rf,
	regime,
	anode_activate,
	cpm,
	led_out,
	mmcn
);


input wire	reset;
input wire	polarity;
input wire	inclk0;
input wire	[3:0] input_rf;
input wire	[2:0] regime;
output wire	[3:0] anode_activate;
output wire	[22:0] cpm;
output wire	[7:0] led_out;
output wire	[2:0] mmcn;

wire	clk_200MHz;
wire	access;
wire	[3:0] rf;
wire	c1;
wire	end_measurement_for_cpm;
wire	[21:0] result_for_cpm;
wire	[19:0] result_for_indicators;
wire	[1:0] three_leds;
wire	[18:0] q;
wire	end_measurement_for_convertor;
wire	[4:0] mic_001;
wire	[4:0] mic_010;
wire	[4:0] mic_100;
wire	[4:0] mil_001;
wire	[4:0] mil_010;
wire	[4:0] mil_100;
wire	[4:0] n_001;
wire	[4:0] n_010;
wire	[4:0] n_100;





ivi_i	ivi_i_inst(
	.clk_200MHz(clk_200MHz),
	.reset(reset),
	.polarity(polarity),
	.access(access),
	.regime(regime),
	.rf(rf),
	.end_measurement(end_measurement_for_convertor),
	.mic_001(mic_001),
	.mic_010(mic_010),
	.mic_100(mic_100),
	.mil_001(mil_001),
	.mil_010(mil_010),
	.mil_100(mil_100),
	.n_001(n_001),
	.n_010(n_010),
	.n_100(n_100));


PLL_ivi	PLL_ivi_inst(
	.inclk0(inclk0),
	.c0(clk_200MHz),
	.c1(c1));


counter	counter_inst(
	.clock(c1),
	.q(q));


CPM_output	CPM_output_inst(
	.clk_200MHz(clk_200MHz),
	.reset(reset),
	.end_measurement(end_measurement_for_cpm),
	.result_for_cpm(result_for_cpm),
	.access(access),
	.cpm(cpm));


IO_registers	IO_registers_inst(
	.clk_200MHz(clk_200MHz),
	.reset(reset),
	.input_rf(input_rf),
	.rf_s(rf));


indicator_controller	indicator_controller_inst(
	.clk_200MHz(clk_200MHz),
	.reset(reset),
	.displayed_number(result_for_indicators),
	.mmcn_leds_in(three_leds),
	.one_indicator_time(q),
	.anode_activate(anode_activate),
	.led_out(led_out),
	.mmcn(mmcn));


convertor_res	convertor_res_inst(
	.clk_200MHz(clk_200MHz),
	.reset(reset),
	.end_measurement_in(end_measurement_for_convertor),
	.mic_001(mic_001),
	.mic_010(mic_010),
	.mic_100(mic_100),
	.mil_001(mil_001),
	.mil_010(mil_010),
	.mil_100(mil_100),
	.n_001(n_001),
	.n_010(n_010),
	.n_100(n_100),
	.end_measurement_out(end_measurement_for_cpm),
	.result_for_cpm(result_for_cpm),
	.result_for_indicators(result_for_indicators),
	.three_leds(three_leds));


endmodule
