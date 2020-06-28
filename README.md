# Pipelined RV32IMC: Capstone Project for CoE 198 (2SAY1920)
This project uses Xilinx IP modules available in Vivado. The design was verified using **Vivado 2019.2**

#### Project Members
+ Emman Baylosis
+ Phoebe Chua
+ MJ Neri
+ Red Ridao
+ Allen Tan

### Processor Specifications and Features
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
**Branch/Jump Misprediction Penalty** | 2 cycles
**FPGA Used** | Arty-A7 35
**Supported Communication Protocols** | UART, SPI, I2C (memory-mapped)


### Simplified Processor Block Diagram
<p align="center">
  <img src="final-toplevel.png" alt="Size Limit CLI" width="738">
</p>

### Data Memory Organization

## Quickstart
+ Add all source files to Vivado (uncheck "Copy sources into project") or use **project_run.tcl**
+ To generate dump files for assembly-tests, use **dumpgen_script.py**

### Using assembler.py
```python
> py assembler\assembler.py <input_file.s> <output_file.dmp> -comp_buffer True
```

### Using dumpgen_script.py
+ Set terminal to directory of assembly code before running **dumpgen_script.py**
+ Edit `assembler_folder_path` in **dumpgen_script.py** using absolute path
+ [**RARS**](https://github.com/TheThirdOne/rars) is used to generate datamem dumps & answer keys
```python
> py dumpgen_script.py <input_file.s>
```

### Using project_run.tcl
+ Execute using **Tools > Run Tcl Script...** in Vivado

### Using Vivado ILA
+ Comment/uncomment `ila_ctr` in **top.v**
+ Comment/uncomment Vivado ILA section in the constraints file
