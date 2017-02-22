Host Interface Module (HIM)
===========================

.. figure:: ../../img/debug_module_him.*
   :alt: Host Interface Module
   :name: fig:debug_module_him

   Host Interface Module

The *Host Interface Module (HIM)* converts the debug packets to a
``length``-``value`` encoded data stream, that is transferred using the
glip interconnect. This format is simple and contains the length of the
debug packet in one data item followed by the debug packet.

Alternatively, the HIM can be configured to store the debug packets to
the system memory using the memory interface.


Debug Transport Datagram (DTD)
------------------------------

.. todo::
  Do we really want to specify this format in here, or should we leave it as implementation-defined until we find a better solution which can cope with variable-length data in a streaming fashion (i.e. without buffering the whole packet first to determine its length)?

The Debug Transport Datagram (DTD) encapsulates the Debug Packet into a
16-bit wide packet.
The Debug Packet data is prepended with the size of the packet in 16 bit words.

.. flat-table:: Debug Interconnect Packet (DI Packet) Structure
  :widths: 2 10
  :header-rows: 1

  * - word index
    - data

  * - 0
    - size *n* of the Debug Packet in 16 bit words

  * - 1
    - word 0 of the Debug Packet

  * - 2
    - word 1 of the Debug Packet

  * - ...
    - ...

  * - *n* + 1
    - word *n* of the Debug Packet

.. note::
  Due to the native width the Debug Transport Datagram is used when transferring a Debug Packet off-chip.
