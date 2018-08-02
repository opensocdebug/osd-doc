Programmer Interface: Data
--------------------------

The Device Emulation Module only generates one type of event packet: **DEM-UART Data Packet**

DEM-UART Data Packet
^^^^^^^^^^^^^^^^^^^^

A DEM-UART Data packet contains one 8-bit character, that has been sent to a UART interface by a CPU, as the only payload.
All packets of this type are sent to the DI Address ``MOD_EVENT_DEST``.

The following fields in the header of the DI packet are set:

- ``FLAGS.TYPE`` is set to ``EVENT``
- ``FLAGS.TYPE_SUB`` is set to ``0x00``

The resulting Debug Interconnect packet has the following structure.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.50\linewidth-2\tabcolsep}|
.. flat-table:: Structure of a DEM-UART data packet
  :widths: 2 3 5
  :header-rows: 1

  * - Word
    - Field
    - Description

  * - 1
    - ``CHARACTER``
    - Contains the character that is being sent, the MSB is always ``0x00``
