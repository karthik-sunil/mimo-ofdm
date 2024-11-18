//    Quake III Fast Inverse Square Root

    const float k3_2 = 1.5f;   // constant 3/2
    float x_2 = 0.5f * x;      // x/2 (reused a couple times)
    float y = x;
    int i_ff = * ( int * ) &y;    // evil floating point bit hack
    i_ff = 0x5f3759df - ( i_ff>>1 ); // Initial approximation (WTF ?!?)
    y = * ( float * ) &i_ff;
    y = y * ( k3_2 - ( x_2 * y * y );  // Newton iteration

