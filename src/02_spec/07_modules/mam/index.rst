Memory Access Module (MAM)
==========================

.. figure:: img/debug_module_mam.*
   :alt: Memory Access Module
   :name: fig:debug_module_mam

   Memory Access Module

The Memory Access Module (MAM) gives read and write access to a memory in the system.
Typical use cases include the initialization of a memory with a program, or the inspection of memory post-mortem or during run-control debugging.

The module is either connected to the system memory, other memory blocks, or the last level cache.

.. todo::
  be a bit more clear about what the following means, especially when mixing in sync write requests

In the presence of write-back caches the memory
access may be required to be guarded by a run-control triggered forced
writeback if necessary.


.. toctree::
   :maxdepth: 1

   systemif
   dbgregisters
   datainterface
