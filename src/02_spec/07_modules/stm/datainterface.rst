Programmer Interface: Data
--------------------------

The STM module generates two types of event packets: trace packets and overflow packets.
Trace packets contain the trace data in the form of (id,value) tuples.
Overflow packets indicate that trace events were missed, usually if more events are generated than the module can send out to the DI.

Trace Packets
^^^^^^^^^^^^^

A Trace Packet encapsulates a trace event, which consists of an identifier ``id`` (always 16 bit wide) and an associated value ``value`` (``VALWIDTH`` bit wide).

The following fields in the header of the DI packet are set:

- ``FLAGS.TYPE`` is set to ``EVENT``
- ``FLAGS.TYPE_SUB`` is set to 0


.. tabularcolumns:: |p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.70\linewidth-2\tabcolsep}|
.. flat-table:: STM Trace Packet Structure
  :widths: 3 7
  :header-rows: 1

  * - payload word
    - description

  * - 0
    - ``id``

  * - 1
    - ``timestamp[15:0]``

  * - 2
    - ``timestamp[31:16]``

  * - 3
    - ``value[15:0]``

  * - ...
    - ...

  * - 2 + ``VALWIDTH`` / 16
    - ``value[VALWIDTH-1:VALWIDTH-16]``


Overflow Packets
^^^^^^^^^^^^^^^^

The following fields in the header of the DI packet are set:

- ``FLAGS.TYPE`` is set to ``EVENT``
- ``FLAGS.TYPE_SUB`` is set to 0x5


.. tabularcolumns:: |p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.70\linewidth-2\tabcolsep}|
.. flat-table:: STM Overflow Packet Structure
  :widths: 3 7
  :header-rows: 1

  * - payload word
    - description

  * - 0
    - number of missed events
