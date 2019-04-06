module calDist(input clk, 
					input btnValid,
					input wire [9:0] y_coord,
					output reg [19:0] pts,
					output reg [19:0] arrowFlag);

integer y_c;

always @(posedge clk)
begin
	if (btnValid == 1)
	begin
	   y_c = y_coord;
		if (400 - y_c < 10 && 400 - y_c > -10)
			pts = 500;
		else if (400 - y_c < 50 && 400 - y_c > -50)
			pts = 300;
		else if (400 - y_c < 80 && 400 - y_c > -80)
			pts = 100;
		else
			pts = 0;
		arrowFlag = 1;
	end
	else 
	begin
		pts = 0;
		arrowFlag = 0;
	end
end
endmodule

					
	
					
					
					