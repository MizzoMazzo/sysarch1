module Division(
	input         clock,
	input         start,
	input  [31:0] a,
	input  [31:0] b,
	output [31:0] q,
	output [31:0] r
);

	// TODO Implementierung
	
reg [31:0] rest, divb, quot,qq, rr;
//reg rt;
parameter temp = 31, width = 32;
reg test;
reg [31:0] tempa, tempb;
integer i = 32, count = 0, tempstart = 0;
integer rt;


assign r = rest;
assign q = quot;

//temporary testing
/*initial begin
	tempstart <= 1;
		tempa = a;
		tempb = b;
		quot = a;
		rest = 0;
		rr = 0; rt = 0; qq = 0; count = 0;
end*/
//listen for double edge
always@(start) begin
	if(clock) begin
		tempstart = 1;
		tempa = a;
		tempb = b;
		quot = a;
		rest = 0;
		rr = 0; rt = 0; qq = 0; count = 0;
	end else begin
		tempstart = 1;
	end
end

always@(posedge clock) begin
	if(tempstart && ~start) begin
		if(!(i == 0) || !(count > 31)) begin
			rr = rest << 1; //multiply with 2 by shifting
			rt = rr + tempa[31];
			tempa = tempa << 1;
			if(rt < tempb) begin
				qq = 0;
				rest = rt;
				quot = quot << 1;
				quot[0] = qq;
				count = count +1; i = i -1;
			end else begin
				qq = 1;
				rest = rt - tempb;
				quot = quot << 1;
				quot[0] = qq;
				count = count +1; i = i -1;
			end
		end else begin
			tempstart = 0;
		end
	end else begin
		tempstart = 0;
end	
end		
endmodule

