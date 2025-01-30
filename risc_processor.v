//--------------------------------------------------
// Pipelined RISC Processor (5-Stage)
//--------------------------------------------------
module risc_processor (
  input clk,
  input reset
);

// Pipeline registers
reg [31:0] IF_ID_Instruction, IF_ID_PC;
reg [31:0] ID_EX_Instruction, ID_EX_PC, ID_EX_Data1, ID_EX_Data2;
reg [31:0] EX_MEM_ALUResult, EX_MEM_WriteData, EX_MEM_PC;
reg [31:0] MEM_WB_ReadData, MEM_WB_ALUResult, MEM_WB_PC;

// Instruction Memory (ROM)
reg [31:0] instr_mem [0:255];
initial $readmemh("instructions.hex", instr_mem);

// Data Memory (RAM)
reg [31:0] data_mem [0:255];

// Register File
reg [31:0] reg_file [0:31];

//----------------------------------
// Stage 1: Instruction Fetch (IF)
//----------------------------------
always @(posedge clk) begin
  if (reset) begin
    IF_ID_PC <= 0;
    IF_ID_Instruction <= 0;
  end else begin
    IF_ID_PC <= PC;
    IF_ID_Instruction <= instr_mem[PC >> 2]; // Word-aligned
  end
end

//----------------------------------
// Stage 2: Instruction Decode (ID)
//----------------------------------
always @(posedge clk) begin
  if (reset) begin
    ID_EX_Instruction <= 0;
    ID_EX_Data1 <= 0;
    ID_EX_Data2 <= 0;
  end else begin
    // Decode instruction and read registers
    ID_EX_Instruction <= IF_ID_Instruction;
    ID_EX_Data1 <= reg_file[IF_ID_Instruction[19:15]]; // rs1
    ID_EX_Data2 <= reg_file[IF_ID_Instruction[24:20]]; // rs2
  end
end

//----------------------------------
// Stage 3: Execute (EX)
//----------------------------------
always @(posedge clk) begin
  if (reset) begin
    EX_MEM_ALUResult <= 0;
    EX_MEM_WriteData <= 0;
  end else begin
    // ALU Operations (e.g., ADD, SUB)
    case (ID_EX_Instruction[6:0])
      7'b0110011: EX_MEM_ALUResult <= ID_EX_Data1 + ID_EX_Data2; // ADD
      7'b0010011: EX_MEM_ALUResult <= ID_EX_Data1 + ID_EX_Instruction[31:20]; // ADDI
      // Add more instructions (SUB, AND, OR, etc.)
    endcase
  end
end

//----------------------------------
// Stage 4: Memory Access (MEM)
//----------------------------------
always @(posedge clk) begin
  if (reset) begin
    MEM_WB_ReadData <= 0;
  end else begin
    // Load/Store Operations
    if (EX_MEM_Instruction[6:0] == 7'b0000011) // LW
      MEM_WB_ReadData <= data_mem[EX_MEM_ALUResult >> 2];
    else if (EX_MEM_Instruction[6:0] == 7'b0100011) // SW
      data_mem[EX_MEM_ALUResult >> 2] <= EX_MEM_WriteData;
  end
end

//----------------------------------
// Stage 5: Write Back (WB)
//----------------------------------
always @(posedge clk) begin
  if (!reset) begin
    if (MEM_WB_Instruction[6:0] == 7'b0110011 ||  // R-type
        MEM_WB_Instruction[6:0] == 7'b0000011)    // LW
      reg_file[MEM_WB_Instruction[11:7]] <= MEM_WB_ALUResult;
  end
end

endmodule
