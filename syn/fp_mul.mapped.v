/////////////////////////////////////////////////////////////
// Created by: Synopsys Design Compiler(R)
// Version   : V-2023.12-SP5
// Date      : Tue Nov 12 13:34:59 2024
/////////////////////////////////////////////////////////////


module fp_mul ( clk, reset, enable, idataA, idataB, odata, out_valid );
  input [31:0] idataA;
  input [31:0] idataB;
  output [31:0] odata;
  input clk, reset, enable;
  output out_valid;
  wire   N0, N1, N2, N3, N4, idataA_sig_ff, idataB_sig_ff, out_valid_stage_1,
         N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19,
         N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33,
         N34, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47,
         N48, N49, N50, N51, N52, N53, N54, N55, N56, N57, N58, N59, N60, N61,
         N62, N63, N64, N65, N66, N67, N68, N69, product_sig, product_sig_ff,
         out_valid_stage_2, N70, N71, N72, N73, N74, N75, N76, N77, N78, N79,
         N80, N81, N82, N83, N84, N85, N86, N87, N88, N89, N90, N91, N92, N93,
         N94, N95, N96, N97, N98, N99, N100, N101, N102, N103, N104, N105,
         N106, N107, N108, N109, N110, N111, N112, N113, N114, N115, N116,
         N117, N118, N119, N120, N121, N122, N123, N124, N125, N126, N127,
         N128, N129, N130, odata_sig_ff, N131, N132, N133, N134, N135, N136,
         N137, N138, N139, N140, N141, N142, N143, N144, N145, N146, N147,
         N148, N149, N150, N151, N152, N153, N154, N155, N156, N157, N158,
         N159, N160, N161, N162, N163, N164, N165, N166, N167, N168, N169,
         N170, N171, N172, N173, N174, N175, N176, N177, N178, N179, N180,
         N181, N182, N183, N184, N185, N186, N187, N188, net17, net18, net19,
         net20, net21, net22, net23, net24, net25, net26, net27, net28, net29,
         net30, net31, net32, net33, net34, net35, net36, net37, net38, net39;
  wire   [7:0] idataA_exp_ff;
  wire   [23:0] idataA_mat_ff;
  wire   [7:0] idataB_exp_ff;
  wire   [23:0] idataB_mat_ff;
  wire   [8:0] product_exp;
  wire   [47:23] product_mat;
  wire   [8:0] product_exp_ff;
  wire   [47:23] product_mat_ff;
  wire   [7:0] odata_exp;
  wire   [22:0] odata_mat;
  wire   [7:0] odata_exp_ff;
  wire   [22:0] odata_mat_ff;

  \**SEQGEN**  out_valid_stage_1_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(N37), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        out_valid_stage_1), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_sig_ff_reg ( .clear(1'b0), .preset(1'b0), .next_state(N5), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(idataA_sig_ff), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  idataA_exp_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N13), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_exp_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_exp_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N12), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_exp_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_exp_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N11), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_exp_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_exp_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N10), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_exp_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_exp_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N9), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_exp_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_exp_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N8), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_exp_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_exp_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N7), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_exp_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_exp_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N6), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_exp_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_23_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N37), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_22_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N36), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_21_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N35), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_20_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N34), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_19_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N33), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_18_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N32), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_17_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N31), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_16_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N30), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N29), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N28), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N27), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N26), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N25), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N24), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N23), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N22), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N21), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N20), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N19), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N18), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N17), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N16), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N15), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataA_mat_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N14), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataA_mat_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_sig_ff_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        N38), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_sig_ff), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_exp_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N46), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_exp_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_exp_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N45), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_exp_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_exp_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N44), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_exp_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_exp_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N43), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_exp_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_exp_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N42), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_exp_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_exp_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N41), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_exp_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_exp_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N40), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_exp_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_exp_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N39), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_exp_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_23_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N37), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_22_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N69), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_21_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N68), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_20_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N67), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_19_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N66), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_18_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N65), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_17_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N64), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_16_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N63), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N62), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N61), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N60), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N59), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N58), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N57), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N56), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N55), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N54), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N53), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N52), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N51), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N50), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N49), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N48), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  idataB_mat_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N47), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        idataB_mat_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_valid_stage_2_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(N105), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(out_valid_stage_2), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_sig_ff_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        N70), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_sig_ff), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N79), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N78), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N77), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N76), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N75), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N74), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N73), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N72), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_exp_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N71), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_exp_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_47_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N104), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(product_mat_ff[47]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_46_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N103), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(product_mat_ff[46]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_45_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N102), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(product_mat_ff[45]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_44_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N101), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(product_mat_ff[44]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_43_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N100), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(product_mat_ff[43]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_42_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N99), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[42]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_41_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N98), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[41]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_40_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N97), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[40]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_39_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N96), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[39]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_38_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N95), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[38]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_37_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N94), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[37]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_36_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N93), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[36]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_35_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N92), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[35]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_34_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N91), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[34]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_33_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N90), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[33]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_32_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N89), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[32]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_31_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N88), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_30_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N87), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_29_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N86), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_28_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N85), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_27_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N84), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_26_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N83), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_25_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N82), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_24_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N81), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  product_mat_ff_reg_23_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N80), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        product_mat_ff[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_valid_stage_3_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(N163), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(out_valid), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_sig_ff_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        N131), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_sig_ff), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_exp_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N139), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_exp_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_exp_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N138), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_exp_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_exp_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N137), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_exp_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_exp_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N136), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_exp_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_exp_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N135), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_exp_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_exp_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N134), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_exp_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_exp_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N133), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_exp_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_exp_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N132), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_exp_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_22_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N162), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_21_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N161), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_20_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N160), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_19_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N159), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_18_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N158), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_17_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N157), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_16_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N156), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N155), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N154), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N153), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N152), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N151), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N150), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(odata_mat_ff[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N149), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N148), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N147), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N146), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N145), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N144), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N143), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N142), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N141), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  odata_mat_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N140), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        odata_mat_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  LT_UNS_OP lt_107 ( .A(product_exp_ff), .B({1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1}), .Z(N164) );
  GTECH_OR2 C274 ( .A(idataB_exp_ff[6]), .B(idataB_exp_ff[7]), .Z(N172) );
  GTECH_OR2 C275 ( .A(idataB_exp_ff[5]), .B(N172), .Z(N173) );
  GTECH_OR2 C276 ( .A(idataB_exp_ff[4]), .B(N173), .Z(N174) );
  GTECH_OR2 C277 ( .A(idataB_exp_ff[3]), .B(N174), .Z(N175) );
  GTECH_OR2 C278 ( .A(idataB_exp_ff[2]), .B(N175), .Z(N176) );
  GTECH_OR2 C279 ( .A(idataB_exp_ff[1]), .B(N176), .Z(N177) );
  GTECH_OR2 C280 ( .A(idataB_exp_ff[0]), .B(N177), .Z(N178) );
  GTECH_NOT I_0 ( .A(N178), .Z(N179) );
  GTECH_OR2 C282 ( .A(idataA_exp_ff[6]), .B(idataA_exp_ff[7]), .Z(N180) );
  GTECH_OR2 C283 ( .A(idataA_exp_ff[5]), .B(N180), .Z(N181) );
  GTECH_OR2 C284 ( .A(idataA_exp_ff[4]), .B(N181), .Z(N182) );
  GTECH_OR2 C285 ( .A(idataA_exp_ff[3]), .B(N182), .Z(N183) );
  GTECH_OR2 C286 ( .A(idataA_exp_ff[2]), .B(N183), .Z(N184) );
  GTECH_OR2 C287 ( .A(idataA_exp_ff[1]), .B(N184), .Z(N185) );
  GTECH_OR2 C288 ( .A(idataA_exp_ff[0]), .B(N185), .Z(N186) );
  GTECH_NOT I_1 ( .A(N186), .Z(N187) );
  ADD_UNS_OP add_67 ( .A(idataA_exp_ff), .B(idataB_exp_ff), .Z(product_exp) );
  MULT_UNS_OP mult_68 ( .A(idataA_mat_ff), .B(idataB_mat_ff), .Z({product_mat, 
        net17, net18, net19, net20, net21, net22, net23, net24, net25, net26, 
        net27, net28, net29, net30, net31, net32, net33, net34, net35, net36, 
        net37, net38, net39}) );
  SUB_UNS_OP sub_87 ( .A(product_exp_ff[7:0]), .B({1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1}), .Z({N114, N113, N112, N111, N110, N109, N108, N107}) );
  SUB_UNS_OP sub_87_2 ( .A(product_exp_ff[7:0]), .B({1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1}), .Z({N130, N129, N128, N127, N126, N125, N124, N123}) );
  ADD_UNS_OP add_87 ( .A({N114, N113, N112, N111, N110, N109, N108, N107}), 
        .B(1'b1), .Z({N122, N121, N120, N119, N118, N117, N116, N115}) );
  SELECT_OP C290 ( .DATA1(1'b0), .DATA2(idataA[31]), .CONTROL1(N0), .CONTROL2(
        N4), .Z(N5) );
  GTECH_BUF B_0 ( .A(N3), .Z(N0) );
  SELECT_OP C291 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA2(idataA[30:23]), .CONTROL1(N0), .CONTROL2(N4), .Z({N13, N12, N11, 
        N10, N9, N8, N7, N6}) );
  GTECH_NOT I_2 ( .A(N3), .Z(N37) );
  SELECT_OP C293 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0}), .DATA2(idataA[22:0]), .CONTROL1(N0), .CONTROL2(N4), 
        .Z({N36, N35, N34, N33, N32, N31, N30, N29, N28, N27, N26, N25, N24, 
        N23, N22, N21, N20, N19, N18, N17, N16, N15, N14}) );
  SELECT_OP C294 ( .DATA1(1'b0), .DATA2(idataB[31]), .CONTROL1(N0), .CONTROL2(
        N4), .Z(N38) );
  SELECT_OP C295 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA2(idataB[30:23]), .CONTROL1(N0), .CONTROL2(N4), .Z({N46, N45, N44, 
        N43, N42, N41, N40, N39}) );
  SELECT_OP C296 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0}), .DATA2(idataB[22:0]), .CONTROL1(N0), .CONTROL2(N4), 
        .Z({N69, N68, N67, N66, N65, N64, N63, N62, N61, N60, N59, N58, N57, 
        N56, N55, N54, N53, N52, N51, N50, N49, N48, N47}) );
  SELECT_OP C297 ( .DATA1(1'b0), .DATA2(product_sig), .CONTROL1(N0), 
        .CONTROL2(N4), .Z(N70) );
  SELECT_OP C298 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0}), .DATA2(product_exp), .CONTROL1(N0), .CONTROL2(N4), .Z({N79, 
        N78, N77, N76, N75, N74, N73, N72, N71}) );
  SELECT_OP C299 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(product_mat), .CONTROL1(N0), 
        .CONTROL2(N4), .Z({N104, N103, N102, N101, N100, N99, N98, N97, N96, 
        N95, N94, N93, N92, N91, N90, N89, N88, N87, N86, N85, N84, N83, N82, 
        N81, N80}) );
  SELECT_OP C300 ( .DATA1(1'b0), .DATA2(out_valid_stage_1), .CONTROL1(N0), 
        .CONTROL2(N4), .Z(N105) );
  SELECT_OP C301 ( .DATA1({N122, N121, N120, N119, N118, N117, N116, N115}), 
        .DATA2({N130, N129, N128, N127, N126, N125, N124, N123}), .CONTROL1(N1), .CONTROL2(N106), .Z(odata_exp) );
  GTECH_BUF B_1 ( .A(product_mat_ff[47]), .Z(N1) );
  SELECT_OP C302 ( .DATA1(product_mat_ff[46:24]), .DATA2(product_mat_ff[45:23]), .CONTROL1(N1), .CONTROL2(N106), .Z(odata_mat) );
  SELECT_OP C303 ( .DATA1(1'b0), .DATA2(product_sig_ff), .CONTROL1(N0), 
        .CONTROL2(N4), .Z(N131) );
  SELECT_OP C304 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA2(odata_exp), .CONTROL1(N0), .CONTROL2(N4), .Z({N139, N138, N137, 
        N136, N135, N134, N133, N132}) );
  SELECT_OP C305 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0}), .DATA2(odata_mat), .CONTROL1(N0), .CONTROL2(N4), 
        .Z({N162, N161, N160, N159, N158, N157, N156, N155, N154, N153, N152, 
        N151, N150, N149, N148, N147, N146, N145, N144, N143, N142, N141, N140}) );
  SELECT_OP C306 ( .DATA1(1'b0), .DATA2(out_valid_stage_2), .CONTROL1(N0), 
        .CONTROL2(N4), .Z(N163) );
  SELECT_OP C307 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3({1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA4({odata_sig_ff, 
        odata_exp_ff, odata_mat_ff}), .CONTROL1(N2), .CONTROL2(N169), 
        .CONTROL3(N171), .CONTROL4(N167), .Z(odata) );
  GTECH_BUF B_2 ( .A(N164), .Z(N2) );
  GTECH_OR2 C310 ( .A(reset), .B(N188), .Z(N3) );
  GTECH_NOT I_3 ( .A(enable), .Z(N188) );
  GTECH_NOT I_4 ( .A(N3), .Z(N4) );
  GTECH_XOR2 C314 ( .A(idataA_sig_ff), .B(idataB_sig_ff), .Z(product_sig) );
  GTECH_NOT I_5 ( .A(product_mat_ff[47]), .Z(N106) );
  GTECH_BUF B_3 ( .A(product_mat_ff[47]) );
  GTECH_BUF B_4 ( .A(N106) );
  GTECH_OR2 C326 ( .A(N187), .B(N164), .Z(N165) );
  GTECH_OR2 C327 ( .A(N179), .B(N165), .Z(N166) );
  GTECH_NOT I_6 ( .A(N166), .Z(N167) );
  GTECH_NOT I_7 ( .A(N164), .Z(N168) );
  GTECH_AND2 C330 ( .A(N187), .B(N168), .Z(N169) );
  GTECH_AND2 C332 ( .A(N168), .B(N186), .Z(N170) );
  GTECH_AND2 C333 ( .A(N179), .B(N170), .Z(N171) );
endmodule

