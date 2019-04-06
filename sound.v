//module sound(clk, rst, speaker/*, note*/);
/*
input clk;
input rst;

output reg [7:0] speaker;

reg [23:0]count;
wire clock_div;
reg [23:0] cnt;

//Clock division 50Mhz input => output 25Mhz
always @(posedge clk) begin
    count <= count+1;
end
assign clock_div = count[0];

integer note_count;
reg [2:0] note;
always @(posedge clk) begin
    if (rst) begin
        note_count <= 0;
        note <= 'b0;
    end
    if (note_count == 0) begin
        note_count <= 50000000;
        note <= note + 1;
		  if (note == 'b110)
		      note <= 'b0;
    end
    else note_count <= note_count - 1;
end
reg [14:0] counter;
always @(posedge clk) begin
    if(counter==0) begin
        case (note)
            'b000:
				    counter <= 123456;
            'b001:
				    counter <= 116279;
            'b010:
				    counter <= 130548;
            'b011:
				    counter <= 123456;
            'b100:
                counter <= 116279;
            'b101:
                counter <= 130548;
            'b110:
                counter <= 123456;
			   'b111:
				    counter <= 138504;
			endcase
    end
    else counter <= counter - 1;
end
always @(posedge clk) begin
    if (rst)
        speaker[7:0] <= 'b0;
    if(counter==0) begin 
	    speaker[7] <= ~speaker[7];
		speaker[6] <= ~speaker[6];
		speaker[5] <= ~speaker[5];
		speaker[4] <= ~speaker[4];
		speaker[3] <= ~speaker[3];
		speaker[2] <= ~speaker[2];
		speaker[1] <= ~speaker[1];
		speaker[0] <= ~speaker[0];
 
	 end
end 
*/
//always @(posedge clk) begin
module sound(clk, rst, speaker, btnU, btnL, btnR, btnD);

input clk;
input rst;
input btnU;
input btnL;
input btnR;
input btnD;

//reg [2:0] note;
output reg [7:0] speaker;

reg [23:0]count;
wire clock_div;
reg [23:0] cnt;
reg [2:0] note;

//Clock division 50Mhz input => output 25Mhz
always @(posedge clk) begin
    count <= count+1;
end
assign clock_div = count[0];

reg [23:0] note_count;
reg [14:0] counter;
always @(posedge clk) begin
    if (rst) begin
        note_count <= 0;
        counter <= 0;
		  note <= 0;
    end
    else if (btnU) begin
        note <= 'b000;
        note_count <= 80000000;
    end
    else if (btnL) begin
        note <= 'b001;
        note_count <= 80000000;
    end
    else if (btnR) begin
        note <= 'b010;
        note_count <= 80000000;
    end
    else if (btnD) begin
        note <= 'b011;
        note_count <= 80000000;
    end
    else if (note_count > 0) begin
        note_count <= note_count - 1;
        if(counter==0) begin
            if(note=='b000)
                counter <= 116279;
            if(note=='b001)
                counter <= 123456;
            if(note=='b010)
                counter <= 130548;
            if(note=='b011)
                counter <= 138504; 
        end
    end
    if (counter > 0)
        counter <= counter - 1;
end

always @(posedge clk) begin
    if (rst)
        speaker[7:0] <= 'b0;
    if(note_count > 0 && counter==0) begin 
	    speaker[7] <= ~speaker[7];
		speaker[6] <= ~speaker[6];
		speaker[5] <= ~speaker[5];
		speaker[4] <= ~speaker[4];
		speaker[3] <= ~speaker[3];
		speaker[2] <= ~speaker[2];
		speaker[1] <= ~speaker[1];
		speaker[0] <= ~speaker[0];
 
	 end
end 
/*
//Siren
parameter clkdivider = 25000000/440/2;

reg [23:0] tone;
always @(posedge clock_div) 
    tone <= tone+1;


reg [14:0] counter;
always @(posedge clock_div) 
    if(counter==0) begin
	     counter <= (tone[23] ? clkdivider-1 : clkdivider/2-1);
    else counter <= counter-1;


always @(posedge clock_div) begin
    if (rst)
	     speaker[7:0] <= 'b0;
    if(counter==0) begin 
	        speaker[7] <= ~speaker[7];
			speaker[6] <= ~speaker[6];
			speaker[5] <= ~speaker[5];
			speaker[4] <= ~speaker[4];
			speaker[3] <= ~speaker[3];
			speaker[2] <= ~speaker[2];
			speaker[1] <= ~speaker[1];
			speaker[0] <= ~speaker[0];
	 end
end

end*/
endmodule
