/******************************************************************
* Description
*	This is the top-level of a MIPS processor that can execute the next set of instructions:
*		add
*		addi
*		sub
*		ori
*		or
*		bne
*		beq
*		and
*		nor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	12/06/2016
******************************************************************/

// andi, lui, sll, srl, lw, sw, beq, bne, j, jal, jr


module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 32
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//******************************************************************/
//******************************************************************/
assign  PortOut = 0;

//******************************************************************/
//******************************************************************/
// Data types to connect modules
wire BranchNE_wire;
wire BranchEQ_wire;
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire MemRead_wire;
wire MemToReg_wire;
wire MemWrite_wire;
wire RegWrite_wire;
wire Zero_wire;
wire [2:0] ALUOp_wire;							//
wire [3:0] ALUOperation_wire;					//
wire [4:0] WriteRegister_wire;				//
wire [31:0] MUX_PC_wire;
wire [31:0] PC_wire;								//
wire [31:0] Instruction_wire;					//
wire [31:0] ReadData1_wire;					//
wire [31:0] ReadData2_wire;					//
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] PCtoBranch_wire;
wire [31:0] DataMemory_wire;
wire [31:0] MUXDataMemory_wire;
wire [31:0] ExtendedShift_wire;
wire [31:0] Branches_wire;
integer ALUStatus;


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.RegDst(RegDst_wire),
	.BranchEQ(BranchEQ_wire),
	.BranchNE(BranchNE_wire),
	.MemRead(MemRead_wire),
	.MemToReg(MemToReg_wire),
	.MemWrite(MemWrite_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	.ALUOp(ALUOp_wire)
);

PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.NewPC(PC_4_wire),
	.PCValue(PC_wire)
);


ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(PC_wire),
	.Instruction(Instruction_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(PC_4_wire)
);


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	
	.MUX_Output(WriteRegister_wire)

);



RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(WriteRegister_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(MUXDataMemory_wire),
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);



Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(ALUSrc_wire),
	.MUX_Data0(ReadData2_wire),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ALUOp_wire),
	.ALUFunction(Instruction_wire[5:0]),
	.ALUOperation(ALUOperation_wire)

);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1_wire),
	.B(ReadData2OrInmmediate_wire),
	.shamt(Instruction_wire[10:6]),
	
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire)
);

assign ALUResultOut = ALUResult_wire;

DataMemory		//para SW y LW
DataMemoryUnit
(
	.WriteData(ReadData2_wire),	//readdata2 de registers
	.Address(ALUResult_wire),	//resultado ALU
	.MemWrite(MemWrite_wire),	//viene de control
	.MemRead(MemRead_wire), 	//viene de control
	.clk(clk),
	
	.ReadData(DataMemory_wire) //Va a multiplexor
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_DataMemoryToRegs
(
	.Selector(MemToReg_wire),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(DataMemory_wire),
	
	.MUX_Output(MUXDataMemory_wire)

);


ShiftLeft2
ShifLeftSignExtend
(
	.DataInput(InmmediateExtend_wire),
	.DataOutput(ExtendedShift_wire)
);

Adder32bits
BranchAdder	//Branching
(
	.Data0(PC_4_wire),
	.Data1(ExtendedShift_wire),
	.Result(Branches_wire) //al multiplexor de branches
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ProgramCounter
(
	.Selector(ZeroANDBrachEQ), //pcsource = Branch AND Zero
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(Branches_wire),
	
	.MUX_Output()

);


endmodule

