Programmer Interface: Data
--------------------------

The CTM module generates two types of event packets: trace packets and overflow packets.
Trace packets contain the data traced from the processor core.
Overflow packets indicate that trace events were missed, usually if more events are generated than the module can send out to the DI.

Trace Packets
^^^^^^^^^^^^^

A Trace Packet encapsulates a single trace event.

The following fields in the header of the DI packet are set:

- ``FLAGS.TYPE`` is set to ``EVENT``
- ``FLAGS.TYPE_SUB`` is set to 0


.. tabularcolumns:: |p{\dimexpr 0.40\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: CTM Trace Packet Structure
  :widths: 4 6
  :header-rows: 1

  * - payload word
    - description

  * - 0
    - ``timestamp[15:0]``

  * - 1
    - ``timestamp[31:16]``

  * - 2
    - Next Program Counter ``npc[15:0]``

  * - ...
    - ...

  * - 1 + ``ADDR_WIDTH`` / 16
    - Next Program Counter ``npc[ADDR_WIDTH-1:ADDR_WIDTH-16]``

  * - 1 + ``ADDR_WIDTH`` / 16 + 1
    - Program Counter ``pc[15:0]``

  * - ...
    - ...

  * - 1 + 2 * (``ADDR_WIDTH`` / 16 + 1)
    - Program Counter ``pc[ADDR_WIDTH-1:ADDR_WIDTH-16]``

  * - 1 + 2 * (``ADDR_WIDTH`` / 16 + 1) + 1
    - [1:0] ``mode``: The privilege mode of the executed instruction.

      [2] ``ret``: The executed instruction returned from a subroutine (e.g. Jump and Link Register (`jalr`) on RISC, `ret` on x86).

      [3] ``call``: The executed instruction called a subroutine (e.g. Jump and Link (`jal`) on RISC, `call` on x86).

      [4] ``modechange``: The executed instruction changed the privilege mode (e.g. from user to kernel space).

      [15:5] reserved

Overflow Packets
^^^^^^^^^^^^^^^^

The following fields in the header of the DI packet are set:

- ``FLAGS.TYPE`` is set to ``EVENT``
- ``FLAGS.TYPE_SUB`` is set to 0x5


.. tabularcolumns:: |p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.70\linewidth-2\tabcolsep}|
.. flat-table:: CTM Overflow Packet Structure
  :widths: 3 7
  :header-rows: 1

  * - payload word
    - description

  * - 0
    - number of missed events
