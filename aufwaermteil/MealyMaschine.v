module MealyPattern(
	input        clock,
	input        i,
	output [1:0] o
);

reg [1:0] out;
reg s0=1, s1=0, s2=0, s3=0, s4=0, s5=0;

//initialize the output with 00
initial
begin
    out[1] = 1'b0;
    out[0] = 1'b0;
end

//assign the output
assign o = out;


//This resembles the function of a Mealy Machine
//I had to switch states by setting current state to zero and next state to 1
always@(posedge clock)
begin
    if(s0)
    begin
        if(i) begin
            s0 = 0; s2 = 1;
        end else begin
            s0 = 0; s1 = 1;
        end
    end
    else if(s1) 
         begin
            if(i) begin
                s1 = 0; s3 = 1;
            end else begin
                s1 = 1;
            end
        end
    else if(s2)
         begin
            if(i) begin
                s2 = 1;
            end else begin
                s2 = 0; s4 = 1;
            end
         end
    else if(s3)
         begin
            if(i) begin
                s3 = 0; s2 = 1;
            end else begin
                out[1] = 1'b1; s3 = 0; s4 = 1;
            end
        end
    else if(s4)
         begin
            if(i) begin
                out[0] = 1'b1; s4 = 0; s5 = 1;
            end else begin
                s4 = 0; s1 = 1;
            end
         end
    else if(s5)
         begin
            if(i) begin
                s5 = 0; s2 = 1;
            end else begin
                out[1] = 1'b1; s5 = 0; s4 = 1;
            end
        end
    else begin
        s0 = 1;
     end
    
end
endmodule

module MealyPatternTestbench();

    reg clock, i;
    wire [1:0] out;

	MealyPattern machine(.clock(clock), .i(i), .o(out));
      
    //create input 0110101011
    initial
    begin
        i <= 1'b0; #2; i <= 1'b1; #2; i <= 1'b1; #2; i <= 1'b0; #2; i <= 1'b1; #2; i <= 1'b0; #2; i <= 1'b1; #2; i <= 1'b0; #2; i <= 1'b1; #2; i <= 1'b1; #2; $finish;
    end

    //create clock
    always
    begin
    	clock <= 1'b1; #1; clock <= 1'b0; #1;
	end


    // TODO Überprüfe Ausgaben
/*initial
    begin
       $monitor("test %b, %b, %b", clock, i, out);
    end*/

initial
begin
	$dumpfile("pattern.vcd");
	$dumpvars;
    #20;
    if(out[1] == 1'b1 && out[0] == 1'b1)
        $display("Simulation successful");
    else
        $display("Simulation error");
    end

endmodule

