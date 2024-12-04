module testbench;

logic clk, reset;
logic [31:0] a [0:3][0:3];
logic [31:0] Q [0:3][0:3];
logic [31:0] R[0:3][0:3];


QR_decomp4 qr(
	.clk(clk),
	.reset(reset), 
	.matrix(a),
	.Q_matrix(Q),
	.R_matrix(R)
);

always begin
	#10 clk = ~clk;
end

initial begin
	clk=1'b0;
	reset = 1'b1;
	a = '{
		'{32'h3F4eccb8, 32'h3F258efa, 32'h3F703872, 32'h3F6d8968},
		'{32'h3F65ec92, 32'h3DCB32B5, 32'h3F75C323, 32'h3EF368FA},
		'{32'h3E00F2C9, 32'h3E8CE1F0, 32'h3E19E4F7, 32'h3F493501},
		'{32'h3F67D3EE, 32'h3F0B746D, 32'h3F7735E6, 32'h3E0A8D9F}
	};
	
	#200 reset = 1'b0;
	// #30 
	// a = '{
	// 	'{32'h3F800000, 32'h3F229832, 32'h3Fba0934, 32'h3e809232},
	// 	'{32'h3F65E7B7, 32'h3F800000, 32'h3F76DCBA, 32'h3EF8A48B},
	// 	'{32'h3E060A92, 32'h3E8EFB55, 32'h3F800000, 32'h3F4CCD5A},
	// 	'{32'h3F68458F, 32'h3F0BD4B9, 32'h3F78E0E5, 32'h3F800000}
	// };
	
	#10000 $stop;


end

endmodule
