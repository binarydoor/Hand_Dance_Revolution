
module targetArrow_right #(
    IX=50,
	 IY=400
	 )
	 (
	 input clk,
	 input rst,
	 input pix_clk,
	// input animate,
    input wire [9:0] x,
    input wire [9:0] y,
	 output reg arrow
    );

	 localparam ini_x = IX;    //initial center
	 localparam ini_y = IY;
	 localparam hw = 50;			//halfwidth
	 
	 reg [9:0] xc;     //center of the shape
	 reg [9:0] yc;
	 reg [9:0] x0;
	 reg [9:0] x1;
	 reg [9:0] x2;
	 reg [9:0] x3;
	 reg [9:0] x4;
	 reg [9:0] x5;
	 reg [9:0] x6;
	 reg [9:0] x7;
	 reg [9:0] x8;
	 reg [9:0] x9;
	 reg [9:0] x10;
	 
	 reg [9:0] y0;	    
	 reg [9:0] y1;		 
	 reg [9:0] y2;	    
	 reg [9:0] y3;		 
	 reg [9:0] y4;	    
	 reg [9:0] y5;		 
	 reg [9:0] y6;	    
	 reg [9:0] y7;		 
	 reg [9:0] y8;	    
	 reg [9:0] y9;		 
	 reg [9:0] y10;	    

	 
	 reg dir_x;       //direction
	 reg dir_y;
	 
	 
	 always @(*) 
	 begin					//    x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10	
		    
		x0 = xc - 15;	   // y0       				
		x1 = xc - 12;  	 	// y1
		x2 = xc - 9;   	// y2
		x3 = xc - 6;   	// y3
		x4 = xc - 3;		// y4
		x5 = xc; 			// y5					 (xcyc)
		x6 = xc + 3;		// y6
		x7 = xc + 6;		// y7
		x8 = xc + 9;		// y8
		x9 = xc + 12;		// y9
		x10 = xc + 15;		// y10
		
		y0 = yc - 15;
		y1 = yc - 12;		
		y2 = yc - 9;
		y3 = yc - 6;		
		y4 = yc - 3;
		y5 = yc;		
		y6 = yc + 3;
		y7 = yc + 6;		
		y8 = yc + 9;
		y9 = yc + 12;		
		y10 = yc + 15;
		

		arrow = ( (x >= x1) && (x < x5 + 2) && (y >= y3) && (y < y7) );
		for (integer i = 0; i < 10; i = i + 1) begin
		    arrow = arrow || 
			         ((x >= x8 - i) && (x < x9 - i) && (y >= y4 + 2 - i) && (y < y6 - 2 + i));
			         //((x >= x4 + 2 - i) && (x < x6 - 2 + i) && (y >= y8 - i) && (y < y9 - i));
		end
			
/*			
		arrow = ( (x >= x4) && (x < x6) && (y >= y8) && (y < y9) ) ||
		        ( (x >= x3) && (x < x7) && (y >= y7) && (y < y8) ) ||
		        ( (x >= x2) && (x < x8) && (y >= y6) && (y < y7) ) ||
				  ( (x >= x1) && (x < x9) && (y >= y5) && (y < y6) ) ||
				  ( (x >= x3) && (x < x7) && (y >= y1) && (y < y5) );*/

				 
	 end
	  

    always @ (posedge clk) 
	 begin
		if (rst)
		begin
			xc <= ini_x;
			yc <= ini_y;
			dir_x <= 1;    //move to right
			dir_y <= 0;    //move to up
		end
		
		else 
		begin	//should try reverse instead of assing a value
			   if (x0 == 0) 	dir_x <= 1;  //need to go right
				if (x1 == 640)  dir_x <= 0;
				if (y0 == 0)  dir_y <= 1;
				if (y1 == 480) dir_y <= 0;
				
		
			/*if (animate && pix_clk)
			begin
				if (dir_x) 	xc <= xc + 1;
				else xc <= xc -1;
				
				if (dir_y) yc <= yc + 1;
				else yc <= yc - 1;
			end*/
		end	
	 end

	 
endmodule

//////////////////////////////////////////////////

	  
	  
	 