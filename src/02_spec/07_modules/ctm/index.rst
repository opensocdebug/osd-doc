Core Trace Module (CTM)
=======================

The *Core Trace Module (CTM)* captures trace events generated from the processor core, and sends them in compressed form as event packets.

Which events are available depends on the observed processor core.
Typically the following events are traced:

- executed instructions (instruction trace)
- branch predictor status
- memory access delays
- cache miss rates

.. note::
   The CTM module is in a very early preview state and has significant limitations.
   It currently focuses on function call traces and has been tested only on RISC-V and or1k (OpenRISC) ISAs.
   No trace compression mechanisms are employed.

.. toctree::
   :maxdepth: 1

   dbgregisters
   datainterface
