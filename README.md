# Pipelined RV32IMC: Capstone Project for CoE 198 (2SAY1920)

## Project Members
+ Emman Baylosis
+ Phoebe Chua
+ MJ Neri
+ Red Ridao
+ Allen Tan

## Quickstart
+ Add all source files to Vivado (uncheck "Copy sources into project")
+ To generate dump files for assembly-tests, use dumpgen_script.py

### Using assembler.py
```python
  py assembler\assembler.py <input_file.s> <output_file.dmp> -comp_buffer True
```

### Using dumpgen_script.py
+ Set terminal to directory of assembly code before running dumpgen_script.py
+ RARS is used to generate datamem dumps & answer keys
```python
  py dumpgen_script.py <input_file.s>
```

#### Using project_run.tcl
+ 
