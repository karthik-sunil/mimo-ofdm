logic signed [COEFF_WIDTH-1:0] twiddle_factors_real [N/2-1:0];
logic signed [COEFF_WIDTH-1:0] twiddle_factors_imag [N/2-1:0];

assign twiddle_factors_real[0] = 256;
assign twiddle_factors_real[1] = 181;
assign twiddle_factors_real[2] = 0;
assign twiddle_factors_real[3] = -181;

assign twiddle_factors_imag[0] = 0;
assign twiddle_factors_imag[1] = -181;
assign twiddle_factors_imag[2] = -256;
assign twiddle_factors_imag[3] = -181;