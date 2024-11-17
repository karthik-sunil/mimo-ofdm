parameter COEFF_WIDTH = 16;
parameter  COMPLEX_WIDTH = 8;
parameter  COMPLEX_PRODUCT_WIDTH = 16;

parameter I_EXP = 8;
parameter I_MNT = 23;
parameter I_DATA = I_EXP + I_MNT + 1;

parameter FIXED_POINT_WIDTH = 16;
parameter R = 8;

parameter signed FIXED_POINT_MIN = -2**(FIXED_POINT_WIDTH-1);
parameter signed FIXED_POINT_MAX = 2**(FIXED_POINT_WIDTH-1)-1;

parameter CLOCK_PERIOD = 10;

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

typedef struct packed {
    logic [I_DATA-1:0] r;
    logic [I_DATA-1:0] i;
} complex_fp_t;
