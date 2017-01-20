*******************************
SystemVerilog Coding Guidelines
*******************************

We try to maintain SV compatibility for 4 tools: Verilator, VCS, ISim (the Vivado simulator) and Vivado Synthesizer.
To increase the code compatibility, please following the following guidance until tools are improved.

#. Avoid using arrayed interface any where. (port or inside a module)

   Existing issues in: ISim, Vivado

#. Avoid using functions/tasks in interfaces.

   Existing issues in: VCS

#. Avoid using simple names, such as "length", "size", "out", "in". They can be mistaken into functions.

   Existing issues in: ISim

#. Avoid "assign" member elements of a struct, use always_comb instead.

   Existing issues in: ISim

#. Avoid using interface as data buffer inside a module.

   Existing issues in: Potentially all as interface is not supposed to be used in this way.

#. Avoid using interface to connect multiple hierarchical ports.
   Such as connect ``A.data -> B.data -> C.data``, where B is a sub-module of A and C is a sub-module of B.

   Existing issues in: ISim (surprisingly it does not support this basic feature!)

#. Avoid using interface as top-level ports. Interfaces are flattened after synthesis, which causes port mismatch between behavioural DUT and post-syn DUT.
   Arguably avoid using interface modport. Some tool cannot correctly check the modport input/output definition anyway.

   Existing issues in: ISim(no check), Verilator(no check)

#. Use ``always_comb`` rather than ``always_comb @(*)``. Even wild-cased sensitive list is an error in VCS.

   Existing issues in: VCS
