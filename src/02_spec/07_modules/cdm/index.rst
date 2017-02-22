Core Debug Module (CDM)
=======================

.. figure:: ../../img/debug_module_cdm.*
   :alt: Core Debug Module
   :name: fig:debug_module_cdm

   Core Debug Module

The core debug module implements run-control debugging for a processor
core. The implementation is to a certain degree core-dependent, but a
generic implementation is sketched in @fig:debug\_module\_cdm. It has a
memory mapped interface as described above. The debug control, status
information and core register are mapped in memory regions. The
run-control debugger (e.g., gdb) then sends register access requests. In
case of a debug event (breakpoint hit) ``interrupt`` signals are
asserted. As a reaction the CDM reads a defined address and the
core-specific part of the CDM generates a debug event.

Of course, other implementations are possible or may be required
depending on the interface processor implementation.

.. todo::
  The specification is TBD.

System Interface
----------------

The core is connected as a slave on this interface:

 Signal | Driver | Width | Description
 ------ | ------ | ----- | -----------
 `stall` | Module | 1 | Stall the core
 `breakpoint` | Core | 1 | Indicates breakpoint
 `strobe` | Module | 1 | Access to the core debug interface
 `ack` | Core | 1 | Complete access to the core
 `adr` | Module | ? | Address of CPU register to access
 `write` | Module | 1 | Write access
 `data_in` | Module | `DATA_WIDTH` | Write data
 `data_out` | Core | `DATA_WIDTH` | Read data
