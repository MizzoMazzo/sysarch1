module Division(
	input         clock,
	input         start,
	input  [31:0] a,
	input  [31:0] b,
	output [31:0] q,
	output [31:0] r
);

/* rest = register with rest as output
 * quot = output-result
 * qq = temporary rest in calculation
 * rr = rest for each calc
 * rt = R'
 * tempa = saved input a
 * tempb = saved input b
 * i = counter for-loop
 * count = counter for 32 iterations at max
 * tempstart = variable for starting calculations
 */
	
reg [31:0] rest,quot, qq, rr, tempa, tempb;
integer i = 32, count = 0, tempstart = 0;
integer rt;

//assign output
assign r = rest;
assign q = quot;


//listen for double edge
//then initialize values
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

//calculations at clock if tempstart is set and start = 0
always@(posedge clock) begin
	if(tempstart && ~start) begin
		if(i < 0 || count > 31) begin
			tempstart = 0;
		end else begin
			rr = rest << 1; 					//multiply with 2 by shifting
			rt = rr + tempa[31];				//R' = R + A[i]
			tempa = tempa << 1;					//shift a by one to achieve A[i]
			if(rt < tempb) begin
				qq = 0;							
				rest = rt;
				quot = quot << 1;				//shift quot at each iteration
				quot[0] = qq;
				count = count +1; i = i -1;		
			end else begin
				qq = 1;
				rest = rt - tempb;
				quot = quot << 1;
				quot[0] = qq;
				count = count +1; i = i -1;
			end
		end
	end else begin
		tempstart = 0;
end	
end		
endmodule

