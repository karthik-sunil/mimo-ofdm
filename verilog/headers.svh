// FFT Size
parameter N=8;

parameter  COEFF_WIDTH = 16;
parameter  COMPLEX_WIDTH = 8;
parameter  COMPLEX_PRODUCT_WIDTH = 32;

parameter I_EXP = 8;
parameter I_MNT = 23;
parameter I_DATA = I_EXP + I_MNT + 1;

// Addressing bits
parameter FFT_BITS=$clog2(N);

parameter FIXED_POINT_WIDTH = 32;
parameter R = 8;

parameter signed FIXED_POINT_MIN = -2**(FIXED_POINT_WIDTH-1);
parameter signed FIXED_POINT_MAX = 2**(FIXED_POINT_WIDTH-1)-1;

parameter CLOCK_PERIOD = 10;

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

//NOTE: try to keep the COMPLEX_PRODUCT_WIDTH and FIXED_WIDTH the same as far as possible
typedef struct packed {
    logic signed [FIXED_POINT_WIDTH-1:0] r; // Real part
    logic signed [FIXED_POINT_WIDTH-1:0] i; // Imaginary part
} complex_fixed_t;