module color(
	input clk,
	input pix_stb,
	input rst,
	input [9:0] x,
	input [9:0] y,
	input [3:0] arrow,
	input [3:0] targetArrow,
	input [5:0] score,
	input border,
	output reg [2:0] vgaRed,
	output reg [2:0] vgaGreen,
	output reg [2:0] vgaBlue,
	input pauseState
   );
	 
	 
	always @(posedge clk)
	begin
   	if (rst) begin
			vgaBlue = 'b000;
			vgaGreen = 'b000;
			vgaRed = 'b000;
		end
	   if (pauseState == 0 && (arrow[0] || arrow[1] || arrow[2] || arrow[3])) begin
		    vgaBlue = 'b111;
		    vgaRed = 'b111;
		end
		
		else if (targetArrow[0] || targetArrow[1] || targetArrow[2] ||targetArrow[3])
		begin
			 vgaBlue = 'b111;
		    vgaRed = 'b111;
			 vgaGreen = 'b111;
		end
		else if (border)
		begin
			vgaBlue = 'b111;
		end
		else if (score != 0)
		begin
			vgaGreen = 'b111;
			vgaBlue = 'b111;
		end
	   else begin
		    vgaBlue = 'b000;
			 vgaGreen = 'b000;
			 vgaRed = 'b000;
		end
		
	end
endmodule