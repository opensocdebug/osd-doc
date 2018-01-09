Memory Access Module (MAM)
==========================

.. figure:: img/debug_module_mam.*
   :alt: Memory Access Module
   :name: fig:debug_module_mam

   Memory Access Module

The Memory Access Module (MAM) gives read and write access to a memory in the system.
Typical use cases include the initialization of a memory with a program, or the inspection of memory post-mortem or during run-control debugging.

The module is either connected to the system memory, other memory blocks, or the last level cache.

.. toctree::
   :maxdepth: 1

   systemif
   dbgregisters
   datainterface
