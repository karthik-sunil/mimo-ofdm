`define COEFF_WIDTH 16
`define COMPLEX_WIDTH 8
`define COMPLEX_PRODUCT_WIDTH 32

`define I_EXP 8
`define I_MNT 23
`define I_DATA `I_EXP + `I_MNT + 1

// Number of input samples 
`define N 4

// Addressing bits
`define FFT_BITS $clog2(N)

`define FIXED_POINT_WIDTH 16
`define R 8

`define FIXED_POINT_MIN (-2**(`FIXED_POINT_WIDTH-1))
`define FIXED_POINT_MAX (2**(`FIXED_POINT_WIDTH-1)-1)

typedef struct packed {
    logic signed [`COMPLEX_WIDTH-1:0] r;
    logic signed [`COMPLEX_WIDTH-1:0] i;
} COMPLEX_T;

typedef struct packed {
    logic signed [`COMPLEX_PRODUCT_WIDTH-1:0] r;
    logic signed [`COMPLEX_PRODUCT_WIDTH-1:0] i;
} COMPLEX_PRODUCT_T;

typedef struct packed {
    logic [`I_DATA-1:0] r;
    logic [`I_DATA-1:0] i;
} COMPLEX_FP_T;

//NOTE: try to keep the COMPLEX_PRODUCT_WIDTH and FIXED_WIDTH the same as far as possible
typedef struct packed {
    logic signed [`FIXED_POINT_WIDTH-1:0] r; // Real part
    logic signed [`FIXED_POINT_WIDTH-1:0] i; // Imaginary part
} COMPLEX_FIXED_T;