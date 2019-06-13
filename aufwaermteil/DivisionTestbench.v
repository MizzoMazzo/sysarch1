module DivisionTestbench();

	// Generiere Eingabe Stimuli
	reg clk, s;
	wire [31:0] qres;
	wire [31:0] rres;

	initial
	begin
		s <= 1'b0; #1; s <= 1'b1; #4; s <= 1'b0; #160; $finish;
	end

	always
	begin
		clk <= 1'b1; #2; clk <= 1'b0; #2;
	end

	// Module unter Test
	Division divider(
		.clock(clk),
		.start(s),
		.a(32'd7), // TODO Probieren Sie gerne auch andere Werte aus!
		.b(32'd3),
		.q(qres),
		.r(rres)
	);

	// Teste, dass 32 Takte (a 4 Zeiteinheiten) nach dem start (zu Zeit 4)
	// das korrekte Ergebnis berechnet wurde
	initial
	begin
		$dumpfile("divsim.vcd");
		$dumpvars;
		#133;
		if (qres == 32'd2 && rres == 32'd1)
			$display("Simulation succeeded");
		else
			$display("Simulation failed");
	end

endmodule

