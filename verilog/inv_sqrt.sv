module inv_sqrt();

// 16 bit
parameter MAGIC_CONSTANT_16 = 16'h59A8;
parameter THREE_HALVES_16 = 16'h3E00;

// 32 bit
parameter MAGIC_CONSTANT_32 = 32'h5F3759DF;
parameter THREE_HALVES_32 = 32'h3FC00000;

/*
 const float k3_2 = 1.5f;   // constant 3/2
    float x_2 = 0.5f * x;      // x/2 (reused a couple times)
    float y = x;
    int i = * ( int * ) &y;    // evil floating point bit hack
    i = 0x5f3759df - ( i>>1 ); // Initial approximation (WTF ?!?)
    y = * ( float * ) &i;
    y = y * ( k3_2 - ( x_2 * y * y );  // Newton iteration
*/

endmodule