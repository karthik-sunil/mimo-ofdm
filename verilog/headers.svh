parameter COEFF_WIDTH = 16;
parameter  COMPLEX_WIDTH = 8;
parameter  COMPLEX_PRODUCT_WIDTH = 40;

// Number of input samples 
parameter N=4;

// Addressing bits
parameter FFT_BITS=$clog2(N);

typedef struct packed {
    logic signed [COMPLEX_WIDTH-1:0] r;
    logic signed [COMPLEX_WIDTH-1:0] i;
} complex_t;

typedef struct packed {
    logic signed [COMPLEX_PRODUCT_WIDTH-1:0] r;
    logic signed [COMPLEX_PRODUCT_WIDTH-1:0] i;
} complex_product_t;
