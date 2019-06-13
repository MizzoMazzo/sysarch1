module ProcessorTestbench();

	reg clk;
	reg reset;

	integer i;
	reg [31:0] expectedRegContent [1:31];

	// Instanziere das zu testende Verilog-Modul
	Processor proc(clk, reset);

	initial
		begin
			// Generiere eine Waveform-Ausgabe mit allen (nicht-Speicher) Variablen
			$dumpfile("simres.vcd");
			$dumpvars(0, ProcessorTestbench);

			/* initialize actual and expected registers to 0xcafebabe */
			for(i=1; i<32; i=i+1) begin
				proc.mips.dp.gpr.registers[i] = 32'hcafebabe;
				expectedRegContent[i] = 32'hcafebabe;
			end

			// Lese auszuführendes Programm ein
			$readmemh("TestProgramme/Fibonacci.dat", proc.imem.INSTRROM, 0, 5);
			$readmemh("TestProgramme/Fibonacci.expected", expectedRegContent);
//			$readmemh("TestProgramme/Funktionsaufruf.dat", proc.imem.INSTRROM, 0, 4);
//			$readmemh("TestProgramme/Funktionsaufruf.expected", expectedRegContent);
//			$readmemh("TestProgramme/Konstanten.dat", proc.imem.INSTRROM, 0, 2);
//			$readmemh("TestProgramme/Konstanten.expected", expectedRegContent);
//			$readmemh("TestProgramme/Multiplikation.dat", proc.imem.INSTRROM, 0, 4);
//			$readmemh("TestProgramme/Multiplikation.expected", expectedRegContent);

			// Generiere reset-Eingabe
			reset <= 1;
			#5; reset <= 0;
			// Anzahl simulierter Zyklen
			#117; // Fibonacci
//			#20; // Funktionsaufruf
//			#16; // Konstanten
//			#24; // Multiplikation

			for(i=1; i<32; i=i+1) begin
				$display("Register %d = %h", i, proc.mips.dp.gpr.registers[i]);
			end
			for(i=1; i<32; i=i+1) begin
				if(^proc.mips.dp.gpr.registers[i] === 1'bx || proc.mips.dp.gpr.registers[i] != expectedRegContent[i]) begin
					$write("FAILED");
					$display(": register %d = %h, expected %h",i, proc.mips.dp.gpr.registers[i], expectedRegContent[i]);
					$finish;
				end
			end
			$display("PASSED");
			$finish;
		end

	// Generiere ein periodisches Clock-Signal
	always
		begin
			clk <= 1; #2; clk <= 0; #2;
		end

endmodule

