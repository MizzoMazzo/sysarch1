// Read-only Instruktionsspeicher
module InstructionMemory(
	input  [5:0] addr,
	output [31:0] rd
);
	reg [31:0] INSTRROM[63:0];

	assign rd = INSTRROM[addr];
endmodule

// Beschreibarer Datenspeicher
module DataMemory(
	input clk,
	input we,
	input [5:0] addr,
	input [31:0] wd,
	output [31:0] rd
);
	reg [31:0] DATARAM[63:0];

	always @(posedge clk)
		if (we) begin
			DATARAM[addr] <= wd;
		end

	assign rd = DATARAM[addr];
endmodule

