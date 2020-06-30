Assembler Features:
+ Support for RV32IMC architecture (excluding ECALL, EBREAK, FENCE, and CSR instructions)
+ URET is included in the supported instructions. URET is used to end ISR execution.
+ Can be modified for other RISC-V Extensions support

Limitations:
+ No support for preprocessor directives and macros
+ Only instruction text dump is generated. For data memory contents & answer key, RARS is used.
+ Basically no support for pseudoinstructions (only 'nop' is supported)
