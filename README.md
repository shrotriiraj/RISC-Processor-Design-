# RISC-Processor-Design-
Developed a pipelined RISC processor in Verilog, focusing on instruction set validation and data pathway optimization.  Created testbenches to verify functional accuracy across edge cases.

Documentation for RISP Processor Design (Verilog)
This documentation accompanies the Verilog code for a 5-stage pipelined RISC processor, designed and validated as part of a UC Riverside digital design course. The project demonstrates proficiency in RTL design, pipeline optimization, and testbench development—key skills for silicon verification roles like MatX’s Design Verification Engineer position.

1. Overview
Project Goals
Design a pipelined RISC processor supporting basic arithmetic, load/store, and control instructions.

Validate functional correctness through testbench simulations.

Optimize data pathways to minimize stalls and hazards.

Key Features
5-Stage Pipeline: Instruction Fetch (IF), Decode (ID), Execute (EX), Memory Access (MEM), Write Back (WB).

Basic Instruction Set: ADD, ADDI (add immediate), LW (load word), SW (store word).

Testbench Coverage: Validates edge cases (data hazards, branch mispredictions).

2. Processor Architecture
Block Diagram

[IF] → [ID] → [EX] → [MEM] → [WB]  

Each stage is separated by pipeline registers to enable concurrent execution.

Pipeline Stages
Instruction Fetch (IF)

Reads instructions from ROM (instr_mem).

Updates the Program Counter (PC).

Verilog Module: always @(posedge clk) block in risc_processor.v.

Instruction Decode (ID)

Decodes instructions and reads register values.

Verilog Variables: ID_EX_Instruction, ID_EX_Data1, ID_EX_Data2.

Execute (EX)

Performs ALU operations (e.g., ADD, SUB).

Verilog Logic: Case statement for opcode handling in risc_processor.v.

Memory Access (MEM)

Handles load/store operations to/from RAM (data_mem).

Verilog Logic: if (EX_MEM_Instruction[6:0] == 7'b0000011).

Write Back (WB)

Writes results back to the register file.

Verilog Logic: Updates reg_file in the final stage.

3. Instruction Set
Instruction	Format	Example	Opcode
ADD	R-type	add x5, x6, x7	7'b0110011
ADDI	I-type	addi x5, x6, 42	7'b0010011
LW	Load	lw x5, 4(x6)	7'b0000011
SW	Store	sw x5, 8(x6)	7'b0100011

Example Encoding (ADD):

// ADD x5, x6, x7  
// Binary: funct7 | rs2 | rs1 | funct3 | rd | opcode  
32'h00C302B3 = 7'b0110011 (opcode), rd=5, rs1=6, rs2=7  

5. Testbench & Validation
Test Cases
Basic Arithmetic (ADD/ADDI)

Validates ALU functionality.

Testbench Code:

// Load instructions.hex with:  
// ADD x5, x6, x7  
// ADDI x5, x6, 42  
Data Hazards

Tests pipeline forwarding logic (e.g., back-to-back ADD instructions).

Example Hazard:
ADD x5, x6, x7  
ADD x8, x5, x9  // Requires forwarding from EX stage  
Load/Store Operations

Verifies RAM access and register updates.

Monitoring Output
The testbench prints the PC and register values at each clock cycle:
$display("PC: %h, Reg[5]: %h", uut.IF_ID_PC, uut.reg_file[5]);  

5. Simulation Setup
Tools
Icarus Verilog: Compiles and simulates Verilog code.

GTKWave: Views waveform outputs (optional).

Steps to Run
Save code as risc_processor.v and tb_risc_processor.v.

Create instructions.hex with test program (e.g., in hexadecimal format).

Compile and simulate:

iverilog -o risc_tb risc_processor.v tb_risc_processor.v  
vvp risc_tb  

View results in the console or generate waveforms.
