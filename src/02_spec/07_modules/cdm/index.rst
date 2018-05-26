Core Debug Module (CDM)
=======================

.. figure:: ../../img/debug_module_cdm_overview.*
   :alt: High Level Overview of the Core Debug Module (CDM)
   :name: fig:debug_module_cdm

   High Level Overview of the Core Debug Module (CDM)

The Core Debug Module (CDM) provides access to the run-control debug functionality of a single CPU core.
The CDM targets CPU cores which provide a memory-mapped interface to their registers which control the debugging procedure.
In its current form the CDM targets the 32 bit or1k CPU core and other cores with a similar interface.

Through the CDM a debugging tool, e.g. GDB, can access the Special Purpose Registers (SPRs) of the CPU core to control the debugging process.
Additionally the debugging tool uses the Memory Access Module (MAM) to read and write data from/to the memory.
Debugging-related events (e.g. "core has stalled") are signalled through a OSD event packet.


.. toctree::
   :maxdepth: 1

   systemif
   dbgregisters
   datainterface
