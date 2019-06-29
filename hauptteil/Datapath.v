module Datapath(
	input         clk, reset,
	input         memtoreg,
	input         dobranch,
	input         alusrcbimm,
	input  [4:0]  destreg,
	input         regwrite,
	input         jump,
	input  [2:0]  alucontrol,
	output        zero,
	output [31:0] pc,
	input  [31:0] instr,
	output [31:0] aluout,
	output [31:0] writedata,
	input  [31:0] readdata,
	
	input		  mfhi,
	input		  mflo,
	input		  jal,
	input		  jr
);
	wire [31:0] pc, incrpc, jrout;
	wire [31:0] signimm;
	wire [31:0] srca, srcb, srcbimm;
	wire [31:0] result;
	wire [63:0] HILO;
	

	// Fetch: Reiche PC an Instruktionsspeicher weiter und update PC
	ProgramCounter pcenv(clk, reset, dobranch, signimm, jump, instr[25:0], pc, incrpc, jr, jrout);

	// Execute:
	// (a) Wähle Operanden aus
	SignExtension se(instr[15:0], signimm);
	assign srcbimm = alusrcbimm ? signimm : srcb;
	// (b) Führe Berechnung in der ALU durch
	ArithmeticLogicUnit alu(srca, srcbimm, alucontrol, aluout, zero, HILO);
	// (c) Wähle richtiges Ergebnis aus
	assign result = memtoreg ? readdata : aluout;

	// Memory: Datenwort das zur (möglichen) Speicherung an den Datenspeicher übertragen wird
	assign writedata = srcb;

	// Write-Back: Stelle Operanden bereit und schreibe das jeweilige Resultat zurück
	RegisterFile gpr(clk, regwrite, instr[25:21], instr[20:16],
	               destreg, result, srca, srcb, mfhi, mflo, HILO, jal, incrpc, jr, jrout);
endmodule

module ProgramCounter(
	input         clk,
	input         reset,
	input         dobranch,
	input  [31:0] branchoffset,
	input         dojump,
	input  [25:0] jumptarget,
	output [31:0] progcounter,
	
	output [31:0] incrpc,
	input		  jr,
	input  [31:0] jrout
	
);
	reg  [31:0] pc;
	wire [31:0] incpc, branchpc, nextpc;

	assign incrpc = incpc;
	// Inkrementiere Befehlszähler um 4 (word-aligned)
	Adder pcinc(.a(pc), .b(32'b100), .cin(1'b0), .y(incpc));
	// Berechne mögliches (PC-relatives) Sprungziel
	Adder pcbranch(.a(incpc), .b({branchoffset[29:0], 2'b00}), .cin(1'b0), .y(branchpc));
	// Wähle den nächsten Wert des Befehlszählers aus
	assign nextpc = dojump   ? {incpc[31:28], jumptarget, 2'b00} :
	                dobranch ? branchpc :
	                jr ? jrout :
	                incpc;

	// Der Befehlszähler ist ein Speicherbaustein
	always @(posedge clk)
	begin
		if (reset) begin // Initialisierung mit Adresse 0x00400000
			pc <= 'h00400000;
		end else begin
			pc <= nextpc;
		end
	end

	// Ausgabe
	assign progcounter = pc;

endmodule

module RegisterFile(
	input         clk,
	input         we3,
	input  [4:0]  ra1, ra2, wa3,
	input  [31:0] wd3,
	output [31:0] rd1, rd2,
	
	input 		  mfhi,
	input 		  mflo,
	input  [63:0] HILO,
	input		  jal,
	input  [31:0] pc4,
	input		  jr,
	output [31:0] jrout
);
	reg [31:0] registers[31:0];
	wire [31:0] HI, LO;
	
	assign HI = (HILO != 0) ? HILO[63:32] : 0;
	assign LO = (HILO != 0) ? HILO[31:0] : 0;
	
	

	always @(posedge clk)
		if (we3 && mfhi) begin
			registers[wa3] <= HI;
		end else if (we3 && mflo) begin
			registers[wa3] <= LO;
		end else if (we3 && jal) begin
			registers[31] <= pc4;
		end else if (we3) begin
			registers[wa3] <= wd3;
		end

	assign jrout = jr ? registers[ra1] : 0;
	assign rd1 = (ra1 != 0) ? registers[ra1] : 0;
	assign rd2 = (ra2 != 0) ? registers[ra2] : 0;

endmodule

module Adder(
	input  [31:0] a, b,
	input         cin,
	output [31:0] y,
	output        cout
);
	assign {cout, y} = a + b + cin;
endmodule

module SignExtension(
	input  [15:0] a,
	output [31:0] y
);
	assign y = {{16{a[15]}}, a};
endmodule

module ArithmeticLogicUnit(
	input  [31:0] a, b,
	input  [2:0]  alucontrol,
	output [31:0] result,
	output        zero,
	
	output [63:0] HILO
);

reg [31:0] res;
reg [63:0] hilotemp;
reg ze;
wire [2:0] alu = alucontrol[2:0];

assign result = res;
assign zero = ze;
assign HILO = hilotemp;
	// TODO Implementierung der ALU
	
always@* begin
	case(alu)
		3'b010: begin			//Addition
			res = a + b;
			if(res == 0) begin
				ze = 1;
			end else begin
				ze = 0;
			end
		end
		3'b110: begin			//Subtraktion
			res = a - b;
			if(res == 0) begin
				ze = 1;
			end else begin
				ze = 0;
			end
		end
		3'b000: begin			//And
			res = a & b;
			if(res == 0) begin
				ze = 1;
			end else begin
				ze = 0;
			end
		end
		3'b001: begin
			res = a | b;		//Or
			if(res == 0) begin
				ze = 1;
			end else begin
				ze = 0;
			end
		end
		3'b111: begin
			if(a < b) begin		//SLT
				res = 1;
				ze = 0;
			end else begin
				res = 0;
				ze = 1;
			end
		end
		3'b011: begin			//LUI zero-extension
			res = {b,{16{1'b0}}};
		end
		3'b100: begin			//MULTU
			hilotemp = a * b;
		end	
		3'b101: begin			//BLTZ
			if(a[31]) begin
				res = 0;
				ze = 1;
			end else begin
				res = 1;
				ze = 0;
			end
		end
		default: begin
			res = 32'bx;
		end
	endcase
end		

endmodule
