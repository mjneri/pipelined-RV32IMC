# Pipelined RV32IMC: Capstone Project for CoE 198 (2SAY1920)
This project uses Xilinx IP modules available in Vivado. The design was verified using **Vivado 2019.2**

#### Project Members
+ Emman Baylosis
+ Phoebe Chua
+ MJ Neri
+ Red Ridao
+ Allen Tan

## Processor Specifications and Features
Features | Specifications
---- | ----
**Architecture** | RV32IMC
**Operating Frequency** | 50MHz
**Memory** | 12kB
**Pipeline stages** | 5-stage In-order Pipeline
**Hazard Handling** | Data Forwarding & Bimodal Branch Prediction
**Multiplication Latency** | 1 clock cycle
**Division Latency** | 38-46 cycles
**Branch Prediction** | 64-Entry Branch History Table w/ Branch Target Buffer
**BHT Implementation** | 4-way Set Associative w/ FIFO Replacement Algorithm
**Branch/Jump Misprediction Penalty** | 2 cycles
**FPGA Used** | Arty-A7 35
**Supported Communication Protocols** | UART, SPI, I2C (memory-mapped)


## Simplified Processor Block Diagram
<p align="center">
  <img src="img/final-toplevel.png" alt="Size Limit CLI" width="738">
</p>

## Data Memory Organization
<p align="center">
  <img src="img/mem-organization.png" alt="Size Limit CLI" width="500">
</p>

## Creating Vivado Project
+ Add **board-files/arty-a7-35** to your Vivado Installation Directory. README.txt contains specific directory.
+ Create a project in Vivado. In Boards, select **Arty A7-35** (part: *xc7a35ticsg324-1L*).
+ Run **project_run.tcl** to add all source files to the project (see section below).
+ Check for any missing sources. You can double check w/ [img/design-hier.png](img/design-hier.png)
+ Make sure to set **arty7_a35t.xdc** as the target constraints file in Vivado.
+ To generate dump files for assembly-tests, use **dumpgen_script.py**
+ Should you want to test BHT performance when its size is varied, go to the BHT constants in **processor/constants.vh**

### Using project_run.tcl
+ Edit current directory in **project_run.tcl** to where the source files are located in your PC.
+ Execute using **Tools > Run Tcl Script...** in Vivado

### Using assembler.py
```python
> python assembler\assembler.py <input_file.s> <output_file.dmp> -comp_buffer True
```

### Using dumpgen_script.py
+ Set terminal to directory of assembly code before running **dumpgen_script.py**
+ Edit `assembler_folder_path` in **dumpgen_script.py** using absolute path
+ [**RARS**](https://github.com/TheThirdOne/rars) is used to generate datamem dumps & answer keys
```python
> python dumpgen_script.py <input_file.s>
```

### Using Vivado ILA
+ Comment/uncomment `ila_ctr` in **top.v**
+ Comment/uncomment Vivado ILA section in the constraints file
