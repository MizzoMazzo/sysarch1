module SanitizerHauptteil();

	// Instanziere das zu testende Verilog-Modul
  Processor proc(clk, reset);

	wire [31:0] a,b,s;
	wire zero;
	wire [2:0] ac;

	ArithmeticLogicUnit alu(
	 .a(a), .b(b),
	 .alucontrol(ac),
	 .result(s),
	 .zero(zero));

	integer idx;

  initial
    begin
    	// Generiere eine Waveform-Ausgabe mit allen (nicht-Speicher) Variablen
    	$dumpfile("simres.vcd");
    	$dumpvars(0, proc.imem.INSTRROM[0]);
    	$dumpvars(0, proc.dmem.DATARAM[0]);
    	$dumpvars(0, proc.pc);
    	$dumpvars(0, proc.instr);
    	$dumpvars(0, proc.readdata);
    	$dumpvars(0, proc.writedata);
    	$dumpvars(0, proc.dataaddr);
    	$dumpvars(0, proc.datawrite);
    	$dumpvars(0, proc.mips);
    	$dumpvars(0, proc.mips.decoder);
    	$dumpvars(0, proc.mips.dp);
    	$dumpvars(0, proc.mips.dp.gpr);
			for (idx = 0; idx < 32; idx = idx + 1) begin
    		$dumpvars(0, proc.mips.dp.gpr.registers[idx]);
    	end
			#1; $finish;
    end

endmodule
