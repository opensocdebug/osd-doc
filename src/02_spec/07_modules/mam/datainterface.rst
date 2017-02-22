Programmer Interface: Data
--------------------------

Reading and writing of the memory happens through a MAM-specific protocol.
Each data transfer can either be a read or a write access.
Both chunk (bulk) and single word accesses are supported.
Before being sent over the debug interconnect, a transfer is split into one or multiple NoC packets.

MAM Transfer Structure
^^^^^^^^^^^^^^^^^^^^^^

All transfers start with a Transfer Header.

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: Transfer Header Structure
  :widths: 1 3 6
  :header-rows: 1

  * - Index
    - Name
    - Description

  * - 0
    - HDR
    - Header

  * - 1
    - ADDR[AW-1 : AW-16]
    - write/read address (most significant two bytes)

  * - 2 .. (n-1)
    - ...
    - ...

  * - n
    - ADDR[15 : 0]
    - write/read address (least significant two bytes)

In read transfers (HDR.WE = 0), the transfer is complete after the Transfer Header.
In write transfers (HDR.WE = 1), the Transfer Header is immediately followed by the Transfer Write Data.

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: Transfer Write Data Structure
  :widths: 1 3 6
  :header-rows: 1

  * - 0
    - D0[DW-1 : DW-16]
    - Most significant two bytes of the first data word

  * - x
    - D0[DW-1 : DW-16]
    - Most significant two bytes of the first data word


Transfer Header (HDR)
"""""""""""""""""""""

The transfer header describes the content of the data transfer.

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: Field Reference: HDR
  :widths: 1 3 6
  :header-rows: 1

  * - Bit(s)
    - Field
    - Description

  * - 15
    - WE
    - **Write Enable**

      **0: Read**
        read from memory

      **1: Write**
        write to memory

  * - 14
    - CHUNK
    - **Chunk or Single Word Access Mode**

      This flag switches between chunk (bulk) and single word access.

      **0: Single Word Access**
        Use single word access.
        In this mode, ADDR describes the address of the word to be accessed.

      **1: Chunk Access**
        Read or write from a continuous region of memory.
        In this mode, ADDR describes the first word to be accessed.

        Chunk accesses are limited to 2\ :sup:`12` = 4,096 words per transfer.

  * - 13
    - SYNC
    - **Use Synchronous Writes**

      **0: Asynchronous Writes**
        Asynchronous writes are not acknowledged by the MAM, thus other modules
        cannot know when a write has finished and the data has reached the
        attached memory. However, subsequent reads from the same MAM will return
        the newly written data.

      **1: Synchronous Writes**
        Synchronous writes are acknowledged by the MAM. See the section below
        for details.

  * - 12:0
    - SELSIZE
    - **Burst Size/Byte Select**

      This field has a different meaning depending on the value of the CHUNK
      field.

      **If CHUNK = 1: Burst Size**
        The number of 16 bit words that make up the burst.

        .. todo:: Is it really 16 bit words, or is the target word size used?

      **If CHUNK = 0: Byte Select**
        The byte to access in single word access mode.

        .. todo:: Detailled MAM Byte Select specification is missing.
          Not yet supported in the reference implementation.




Synchronous Writes
^^^^^^^^^^^^^^^^^^

.. todo::
  specify the guarantees that synchronous modes gives (where did the data arrive when the ACK is sent?)

If synchronous mode is selected, a ACK packet is sent after the last
word has been written. An ACK packet is equal to a read packet with no
content.


Packetization
^^^^^^^^^^^^^

Before sending over the Debug NoC to the MAM, NoC packets must be created out of a Transfer.
The packets must be of type PLAIN and must consist of no more than MAX_PACKET_LENGTH flits (including the packet header).

.. todo::
  link to the definition of the MAX_PACKET_LENGTH variable and the PLAIN data transfer type.

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: MAM Packet Structure
  :widths: 1 3 6
  :header-rows: 1

  * - Flit
    - Name
    - Description

  * - 0
    - PKG_HDR
    - Packet Header. TYPE must be set to PLAIN.

  * - 1
    - T0
    - First word of the transfer (index = 0)

  * - *n* - 1
    - T\ *n*
    - *n*\ th word of the transfer (index = *n*)

All packets except the last one should be of size MAX_PACKET_LENGTH to reduce overhead.


Examples
^^^^^^^^
.. note::
  The following examples are informal and not part of the specification.

An examplary write sequence of a chunk of four data items with data
width 64-bit and address width 32-bit is the sequence:

::

    0xc004=1100 0000 0000 0100
    Addr[31:16]
    Addr[15:0]
    D0[63:48]
    D0[47:32]
    D0[31:16]
    D0[15:0]
    D1[63:48]
    D1[47:32]
    D1[31:16]
    D1[15:0]
    D2[63:48]
    D2[47:32]
    D2[31:16]
    D2[15:0]
    D3[63:48]
    D3[47:32]
    D3[31:16]
    D3[15:0]

This sequence will write ``D0`` to ``Addr``, ``D1`` to ``Addr+1``,
``D2`` to ``Addr+2`` and ``D3`` to ``Addr+3``.

If the maximum packet size in the debug interconnect is 8, this is the
packet sequence with minimum number of packets:

::

    (dest=MAM_ID)
    (type=PLAIN,src=0)
    0xc004
    Addr[31:16]
    Addr[15:0]
    D0[63:48]
    D0[47:32]
    D0[31:16]

    (dest=MAM_ID)
    (type=PLAIN,src=0)
    D0[15:0]
    D1[63:48]
    D1[47:32]
    D1[31:16]
    D1[15:0]
    D2[63:48]

    (dest=MAM_ID)
    (type=PLAIN,src=0)
    D2[47:32]
    D2[31:16]
    D2[15:0]
    D3[63:48]
    D3[47:32]
    D3[31:16]

    (dest=MAM_ID)
    (type=PLAIN,src=0)
    D3[15:0]
