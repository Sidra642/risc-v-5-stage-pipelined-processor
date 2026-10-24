# 5-Stage Pipelined RISC-V Processor

## Overview
This project implements a 5-stage pipelined RISC-V processor in SystemVerilog. It is intended to explore instruction execution, pipeline organization, and hazard handling.

## Pipeline Stages
1. **IF — Instruction Fetch:** Fetches instructions from instruction memory.
2. **ID — Instruction Decode:** Decodes instructions and reads registers.
3. **EX — Execute:** Performs ALU operations and evaluates execution conditions.
4. **MEM — Memory Access:** Interfaces with data memory.
5. **WB — Write Back:** Writes results back to the register file.

## Features
- SystemVerilog RTL modules
- Pipeline registers between stages
- Hazard detection unit
- Forwarding unit
- ALU and control logic
- Instruction and data memory
- Testbench for simulation

## Project Structure

```text
.
├── RTL/
│   ├── top.sv
│   ├── tb_top.sv
│   └── ... other RTL modules
├── .gitignore
└── README.md
```

## Simulation

### Requirements
- Icarus Verilog
- GTKWave (optional, for waveform inspection)

### Compile
Run from the repository root:

```bash
mkdir -p build
iverilog -g2012 -Wall -s tb_top -o build/tb_top.vvp RTL/*.sv
```

### Run
```bash
vvp build/tb_top.vvp
```

### View Waveforms
The testbench generates `tb.vcd`. Open it with:

```bash
gtkwave tb.vcd
```

## Current Status
RTL compilation has been tested with Icarus Verilog. Functional verification of the complete processor is still in progress.

## Tools
- SystemVerilog
- Icarus Verilog
- GTKWave
=======
# risc-v-5-stage-pipelined-processor
A 5-stage pipelined RISC-V processor implemented in SystemVerilog
