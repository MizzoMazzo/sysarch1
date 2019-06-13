module Processor(
	input clk,
	input reset
);
	wire [31:0] pc, instr;
	wire [31:0] readdata, writedata;
	wire [31:0] dataaddr;
	wire datawrite;

	MIPScore mips(clk, reset,
		pc, instr,
		datawrite, dataaddr,
		writedata, readdata);

	// Binde Instruktions- und Datenspeicher an
	InstructionMemory imem(pc[7:2], instr);
	DataMemory dmem(clk, datawrite, dataaddr[7:2], writedata, readdata);
endmodule

