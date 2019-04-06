module top(
    input wire clk,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire reset,         // reset button
	 input wire btnU,
	 input wire btnL,
	 input wire btnR,
	 input wire btnD,
    output wire Hsync,       // horizontal sync output
    output wire Vsync,       // vertical sync output
    output wire [2:0] vgaRed,    // 4-bit VGA red output
    output wire [2:0] vgaGreen,    // 4-bit VGA green output
    output wire [2:0] vgaBlue,     // 4-bit VGA blue output
	 output wire [7:0] JA
    );

    //wire rst = ~reset;    // reset is active low on Arty & Nexys Video
    wire rst = reset;  // reset is active high on Basys3 (BTNC)

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [9:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing
	 wire [3:0] arrow;
    wire [3:0] targetArrow;
    wire line;
	 wire [9:0] ycl;
	 wire [9:0] ycd;
	 wire [9:0] ycu;
	 wire [9:0] ycr;
	 
	 wire arrowFlagL;
	 wire arrowFlagD;
	 wire arrowFlagU;
	 wire arrowFlagR;
	 wire [19:0] ptsL;
	 wire [19:0] ptsD;
	 wire [19:0] ptsU;
	 wire [19:0] ptsR;
	 reg [19:0] totalPts = 0;
	 
	 wire [5:0] score;
	 
	 /* Calculate the Score */
	 always @(posedge clk)
	 begin
	   if (rst)
		    totalPts <= 0;
		else
		    totalPts <= totalPts + ptsL + ptsD + ptsU + ptsR;
	 end
	 
	 
	 wire [17:0] clk_dv_inc;
	reg [16:0]  clk_dv;
	reg         clk_en;
	reg         clk_en_d;
	reg         btnR_valid;
	reg         btnL_valid;
	reg         btnU_valid;
	reg         btnD_valid;
	reg [2:0]   step_d_R;
	reg [2:0]   step_d_L;
	reg [2:0]   step_d_U;
	reg [2:0]   step_d_D;
	
	
	reg [63:0] virtualCounter = 1500000000;
	reg pauseState;
	always @ (posedge clk)
	begin
	  if (rst) begin
	      virtualCounter <= 1500000000;
			pauseState <= 0;
	  end
	  else begin
	      if (virtualCounter > 0) begin
	          virtualCounter <= virtualCounter - 1;
				 if (virtualCounter == 0)
			        pauseState <= 1;
			end
			if (virtualCounter == 0)
			    pauseState <= 1;
	  end
	end

	 
   // ===========================================================================
   // Instruction Stepping Control / Debouncing
   // ===========================================================================
 assign clk_dv_inc = clk_dv + 1;
	always @ (posedge clk)
     if (rst)
       begin
          clk_dv   <= 0;
          clk_en   <= 1'b0;
          clk_en_d <= 1'b0;
       end
     else
       begin
          clk_dv   <= clk_dv_inc[16:0];
          clk_en   <= clk_dv_inc[17];
          clk_en_d <= clk_en;
       end
	 always @ (posedge clk)
     if (rst)
       begin
          step_d_R <= 0;
          step_d_L <= 0;
			 step_d_U <= 0;
			 step_d_D <= 0;
       end
     else if (clk_en) // Down sampling
       begin
			step_d_R <= {btnR, step_d_R[2:1]};
			step_d_L <= {btnL, step_d_L[2:1]};
			step_d_U <= {btnU, step_d_U[2:1]};
			step_d_D <= {btnD, step_d_D[2:1]};
       end
	   
	// Detecting posedge of btnR
   wire is_btnR_posedge;
   assign is_btnR_posedge = ~ step_d_R[0] & step_d_R[1];
	wire is_btnL_posedge;
   assign is_btnL_posedge = ~ step_d_L[0] & step_d_L[1];
	wire is_btnU_posedge;
   assign is_btnU_posedge = ~ step_d_U[0] & step_d_U[1];
	wire is_btnD_posedge;
   assign is_btnD_posedge = ~ step_d_D[0] & step_d_D[1];
  
  always @ (posedge clk)
     if (rst) begin
       btnR_valid <= 1'b0;
		 btnL_valid <= 1'b0;
		 btnU_valid <= 1'b0;
		 btnD_valid <= 1'b0;
	  end
     else if (clk_en_d) begin
       btnR_valid <= is_btnR_posedge;
		 btnL_valid <= is_btnL_posedge;
		 btnU_valid <= is_btnU_posedge;
		 btnD_valid <= is_btnD_posedge;
	  end
	  else begin
	    btnR_valid <= 0;
		 btnL_valid <= 0;
		 btnU_valid <= 0;
		 btnD_valid <= 0;
	  end

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt = 0;
    reg pix_stb = 0;
    always @(posedge clk)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    vga640x480 display (
        .i_clk(clk),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(Hsync), 
        .o_vs(Vsync), 
        .o_x(x), 
        .o_y(y),
        .o_animate(animate)
    );

    wire sq_a;//, sq_b, sq_c;
    wire [11:0] sq_a_x1, sq_a_x2, sq_a_y1, sq_a_y2;  // 12-bit values: 0-4095 
    wire [11:0] sq_b_x1, sq_b_x2, sq_b_y1, sq_b_y2;
    wire [11:0] sq_c_x1, sq_c_x2, sq_c_y1, sq_c_y2;
	 square #(.IX(160), .IY(120), .H_SIZE(60)) sq_a_anim (
        .i_clk(clk), 
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_a_x1),
        .o_x2(sq_a_x2),
        .o_y1(sq_a_y1),
        .o_y2(sq_a_y2)
    );/*

    square #(.IX(320), .IY(240), .IY_DIR(0)) sq_b_anim (
        .i_clk(clk), 
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_b_x1),
        .o_x2(sq_b_x2),
        .o_y1(sq_b_y1),
        .o_y2(sq_b_y2)
    );    

    square #(.IX(480), .IY(360), .H_SIZE(100)) sq_c_anim (
        .i_clk(clk), 
        .i_ani_stb(pix_stb),
        .i_rst(rst),
        .i_animate(animate),
        .o_x1(sq_c_x1),
        .o_x2(sq_c_x2),
        .o_y1(sq_c_y1),
        .o_y2(sq_c_y2)
    );
*/
	 
	 
	 
	 localparam gap = 30;
	 arrow_left #(.IX(50), .IY(50), .IRandom(3)) arrow1( 
	 .clk(clk),
	 .rst(rst),
	 .pix_clk(pix_stb),
	 .animate(animate),
    .x(x),
    .y(y),
	 .btnFlag(btnL_valid),
	 .arrow(arrow[0]),
	 .yc(ycl)
	);

	 arrow #(.IX(50 + gap), .IY(50), .IRandom(0)) arrow2( 
	 .clk(clk),
	 .rst(rst),
	 .pix_clk(pix_stb),
	 .animate(animate),
    .x(x),
    .y(y),
	 .btnFlag(btnD_valid),
	 .arrow(arrow[1]),
	 .yc(ycd)
	);

	 arrow_up #(.IX(50 + gap * 2), .IY(50), .IRandom(2)) arrow3( 
	 .clk(clk),
	 .rst(rst),
	 .pix_clk(pix_stb),
	 .animate(animate),
    .x(x),
    .y(y),
	 .btnFlag(btnU_valid),
	 .arrow(arrow[2]),
	 .yc(ycu)
	);

	 arrow_right #(.IX(50 + gap * 3), .IY(50), .IRandom(1)) arrow4( 
	 .clk(clk),
	 .rst(rst),
	 .pix_clk(pix_stb),
	 .animate(animate),
    .x(x),
    .y(y),
	 .btnFlag(btnR_valid),
	 .arrow(arrow[3]),
	 .yc(ycr)
	);

    targetArrow_left #(.IX(50), .IY(400)) targetArrow1(
     .clk(clk),
     .rst(rst),
     .pix_clk(pix_stb),
     .x(x),
     .y(y),
     .arrow(targetArrow[0])
    );

    targetArrow #(.IX(50 + gap), .IY(400)) targetArrow2(
     .clk(clk),
     .rst(rst),
     .pix_clk(pix_stb),
     .x(x),
     .y(y),
     .arrow(targetArrow[1])
    );

    targetArrow_up #(.IX(50 + gap * 2), .IY(400)) targetArrow3(
     .clk(clk),
     .rst(rst),
     .pix_clk(pix_stb),
     .x(x),
     .y(y),
     .arrow(targetArrow[2])
    );

    targetArrow_right #(.IX(50 + gap * 3), .IY(400)) targetArrow4(
     .clk(clk),
     .rst(rst),
     .pix_clk(pix_stb),
     .x(x),
     .y(y),
     .arrow(targetArrow[3])
    );

    border #(.IX(0), .IY(350)) lines(
        .clk(clk),
        .rst(rst),
        .pix_clk(pix_stb),
        .x(x),
        .y(y),
        .line(line)
    );
	 
	 calDist calcDistL (
				.clk(clk),
				.btnValid(btnL_valid),
				.y_coord(ycl),
				.pts(ptsL),
				.arrowFlag(arrowFlagL)
				);
				
	calDist calcDistD (
				.clk(clk),
				.btnValid(btnD_valid),
				.y_coord(ycd),
				.pts(ptsD),
				.arrowFlag(arrowFlagD)
	);
	
	calDist calcDistU (
				.clk(clk),
				.btnValid(btnU_valid),
				.y_coord(ycu),
				.pts(ptsU),
				.arrowFlag(arrowFlagU)
	);
	
	calDist calcDistR (
				.clk(clk),
				.btnValid(btnR_valid),
				.y_coord(ycr),
				.pts(ptsR),
				.arrowFlag(arrowFlagR)
	);
				
	score #(.IX(300), .IY(100), .i(0)) scores
					(.clk (clk),
					 .rst(rst),
					 .pix_clk(pix_stb),
					 .x(x),
					 .y(y),
					 .digit(totalPts%10),
					 .score(score[0])
					 );
					 
	score #(.IX(300), .IY(100), .i(1)) scores1
					(.clk (clk),
					 .rst(rst),
					 .pix_clk(pix_stb),
					 .x(x),
					 .y(y),
					 .digit((totalPts/10) % 10),
					 .score(score[1])
					 );
	score #(.IX(300), .IY(100), .i(2)) scores2
					(.clk (clk),
					 .rst(rst),
					 .pix_clk(pix_stb),
					 .x(x),
					 .y(y),
					 .digit((totalPts/100) % 10),
					 .score(score[2])
					 );
	score #(.IX(300), .IY(100), .i(3)) scores3
					(.clk (clk),
					 .rst(rst),
					 .pix_clk(pix_stb),
					 .x(x),
					 .y(y),
					 .digit((totalPts/1000) % 10),
					 .score(score[3])
					 );
	score #(.IX(300), .IY(100), .i(4)) scores4
					(.clk (clk),
					 .rst(rst),
					 .pix_clk(pix_stb),
					 .x(x),
					 .y(y),
					 .digit((totalPts/10000) % 10),
					 .score(score[4])
					 );
	score #(.IX(300), .IY(100), .i(5)) scores5
					(.clk (clk),
					 .rst(rst),
					 .pix_clk(pix_stb),
					 .x(x),
					 .y(y),
					 .digit((totalPts/100000) % 10),
					 .score(score[5])
					 );
					 
	color clr(
	.clk(clk),
	.pix_stb(pix_stb),
	.rst(rst),
	.x(x),
	.y(y),
	.arrow(arrow),
	.targetArrow(targetArrow),
	.score(score),
	.border(border),
	.vgaRed(vgaRed),
	.vgaGreen(vgaGreen),
	.vgaBlue(vgaBlue),
	.pauseState(pauseState)
   );
	
	sound snd(
	.clk(clk),
	.rst(rst),
	.speaker(JA),
	.btnU(btnU),
	.btnL(btnL),
	.btnR(btnR),
	.btnD(btnD)

	);


/*    assign sq_a = ((x > sq_a_x1) & (y > sq_a_y1) &
        (x < sq_a_x2) & (y < sq_a_y2)) ? 1 : 0;
    assign sq_b = ((x > sq_b_x1) & (y > sq_b_y1) &
        (x < sq_b_x2) & (y < sq_b_y2)) ? 1 : 0;
    assign sq_c = ((x > sq_c_x1) & (y > sq_c_y1) &
        (x < sq_c_x2) & (y < sq_c_y2)) ? 1 : 0;

    assign vgaRed[2]     = sq_a;  // square a is red
    assign vgaGreen[2]   = sq_b;  // square b is green
    assign vgaBlue[2]    = sq_c;  // square c is blue
	 assign vgaRed[1:0]   = 'b11;
	 assign vgaGreen[1:0] = 'b11;
	 assign vgaBlue[1:0]  = 'b11;*/
endmodule