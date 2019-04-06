 module score #(IX = 300, IY = 100, i = 0)
					(input clk,
					input rst,
					input pix_clk,
					input wire [9:0] x,
					input wire [9:0] y,
					input wire [3:0] digit,
					output reg score);
		
		always @(*) begin
			if (rst) begin
				score = 0;
			end
			case (digit)
					0:
					if (x < 600 - i*35 && x > 570 - i*35 && y < 100 && y > 97)
						score = 1;		
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 40 && y > 37)
						score = 1;
					else if (y < 100 && y > 37 && x < 600 - i*35 && x > 597 - i*35 )
						score = 1;
					else if (y < 100 && y > 37 && x > 570 - i*35 && x < 573 - i*35)
						score = 1;
					else
						score = 0;
					1:
					if (y < 100 && y > 37 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else
						score = 0;
					5:
					if (x < 600 - i*35 && x > 570 - i*35 && y < 100 && y > 97)
						score = 1;
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 70 && y > 67)
						score = 1;
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 40 && y > 37)
						score = 1;
					else if (y < 100 && y > 67 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else if (y < 67 && y > 37 && x > 570 - i*35 && x < 573 - i*35)
						score = 1;
					else 
						score = 0;
					3:
					if (x < 600 - i*35 && x > 570 - i*35 && y < 100 && y > 97)
						score = 1;		
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 70 && y > 67)
						score = 1;
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 40 && y > 37)
						score = 1;
					else if (y < 100 && y > 37 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else
						score = 0;
					4:
					if (x < 600 - i*35 && x > 570 - i*35 && y < 70 && y > 67)
						score = 1;
					else if (y < 100 && y > 37 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else if (y < 67 && y > 37 && x > 570 - i*35 && x < 573 - i*35)
						score = 1;
					else
						score = 0;
					2:
					if (x < 600 - i*35 && x > 570 - i*35 && y < 100 && y > 97)
						score = 1;		
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 70 && y > 67)
						score = 1;
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 40 && y > 37)
						score = 1;
					else if (y < 100 && y > 67 && x > 570 - i*35 && x < 573 - i*35)
						score = 1;
					else if (y < 67 && y > 37 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else
						score = 0;
					6:
					if (x < 600 - i*35 && x > 570 - i*35 && y < 100 && y > 97)
						score = 1;		
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 70 && y > 67)
						score = 1;
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 40 && y > 37)
						score = 1;
					else if (y < 100 && y > 37 && x > 570 - i*35 && x < 573 - i*35)
						score = 1;
					else if (y < 100 && y > 67 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else
						score = 0;
					7:
					if (x < 600 - i*35 && x > 570 - i*35 && y < 40 && y > 37)
						score= 1;	
					else if (y < 100 && y > 37 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else
						score = 0;
					8: 
					if (x < 600 - i*35 && x > 570 - i*35 && y < 100 && y > 97)
						score = 1;		
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 70 && y > 67)
						score = 1;
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 40 && y > 37)
						score = 1;
					else if (y < 100 && y > 37 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else if (y < 100 && y > 37 && x > 570 - i*35 && x < 573 - i*35)
						score = 1;
					else
						score = 0;
					9:
					if (x < 600 - i*35 && x > 570 - i*35 && y < 40 && y > 37)
						score = 1;		
					else if (x < 600 - i*35 && x > 570 - i*35 && y < 70 && y > 67)
						score = 1;
					else if (y < 100 && y > 37 && x < 600 - i*35 && x > 597 - i*35)
						score = 1;
					else if (y < 67 && y > 37 && x < 573 - i*35 && x > 570 - i*35)
						score = 1;
					else
						score = 0;
				endcase
		end
		
endmodule
			