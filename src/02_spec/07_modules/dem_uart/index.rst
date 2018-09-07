UART Device Emulation Module (DEM-UART)
=======================================

.. figure:: img/osd_dem_uart.*
   :alt: Device Emulation Module UART

   High-Level Overview of the Device Emulation Module for UART (DEM-UART)

The UART Device Emulation Module connects to the bus of a given CPU on one side, and to the Debug Interconnect on the other.
Towards the CPU it behaves like a UART-16550A device, but instead of transmitting information over a UART-Interface it instead passes it to a host PC via the Debug Interconnect.

.. toctree::
   :maxdepth: 1

   dbgregisters
   datainterface
   uartspec
   systemif
