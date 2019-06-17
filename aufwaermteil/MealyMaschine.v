module MealyPattern(
	input        clock,
	input        i,
	output [1:0] o
);
reg a, b, c,isa,isb,isc;
    reg [2:0] test;
    reg [1:0] out; 
    assign o = out;
initial
    begin
    
    out[1] <= 'b0;
    out[0] <= 'b0;
        
        $display("Hello Team this is Testy your friendly Neighbourhood Debug Message!"); 
    end
    
    
    always @(posedge clock)
    begin
      out[1] <= 'b0;
    out[0] <= 'b0;
        if(isa) begin 
            
            if(isb) begin
                
                if(isc) begin
                    a = b;
                    b = c;
                    c = i;
                    test[2] <= a; test[1] <= b; test[0] <= c;
                            if(test=='b010)begin
                                out[1]<=1;
                            end else begin
                            if(test=='b101)begin
                                out[0] <= 1; 
                            end
                            end 
                    
                end else begin
                    c<= i;isc<='b1;
                    test[2] <= a; test[1] <= b; test[0] <= c;
                            if(test=='b010)begin
                                out[1]<=1;
                            end else begin
                            if(test=='b101)begin
                                out[0] <= 1; 
                            end
                            end 
                end    
            end else begin 
               b<=i;isb<='b1; 
            end
        end else begin
           a<=i;isa<='b1; 
        end
        
        
    end


endmodule

module MealyPatternTestbench();
reg clock, i,test;
    wire [1:0] out;

	MealyPattern machine(.clock(clock), .i(i), .o(out));
      
    //create input 0110101011
    initial
    begin
        i <= 1'b0; #2; i <= 1'b1; #2; i <= 1'b1; #2; i <= 1'b0; #2; i <= 1'b1; #2; i <= 1'b0; #2; i <= 1'b1; #2; i <= 1'b0; #2; i <= 1'b1; #2; i <= 1'b1; #1; $finish;
    end

    //create clock
    always
    begin
    	clock <= 1'b1; #1; clock <= 1'b0; #1;
	end


    // TODO Überprüfe Ausgaben
initial
    begin
       $monitor("test %b, %b, %b", clock, i, out);
    end

initial
    begin
        test <= 'b0;
        $dumpfile("mealy.vcd");
		$dumpvars;
		#1;
        if(out[1] != 'b0 || out[0] != 'b0)
            test <= 'b1; else test <= test;
        #2;
        if(out[1] != 'b0 || out[0] != 'b0)
            test <= 'b1; else test <= test;
        #2;
        if(out[1] != 'b0 || out[0] != 'b0)
            test <= 'b1;else test <= test;
        #2;
        if(out[1] != 'b0 || out[0] != 'b0)
            test <= 'b1;else test <= test;
        #2;
        if(out[1] != 'b0 || out[0] != 'b0)
            test <= 'b1;else test <= test;
        #2;
        if(out[1] != 'b0 || out[0] != 'b1)
            test <= 'b1;else test <= test;
        #2;
        if(out[1] != 'b1 || out[0] != 'b0)
            test <= 'b1;else test <= test;
        #2;
        if(out[1] != 'b0 || out[0] != 'b1)
            test <= 'b1;else test <= test;
        #2;
        if(out[1] != 'b1 || out[0] != 'b0)
            test <= 'b1;else test <= test;
        #2;
        if(out[1] != 'b0 || out[0] != 'b1)
            test <= 'b1;else test <= test;
    if(test == 'b0)
        $display("Simulation successful");
    else
        $display("Simulation error");
    end
endmodule

