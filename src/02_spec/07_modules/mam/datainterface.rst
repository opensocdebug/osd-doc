Programmer Interface: Data
--------------------------

Reading and writing of the memory happens through a MAM-specific protocol inside DI packets of type ``EVENT``.
Data transfers can either be a read or a write access.
Both burst and single word accesses are supported.

.. figure:: img/mam_data_transfer_structure.*
   :alt: MAM data transfer encapsulation
   :name: fig:mam_data_transfer_structure

   MAM data transfer encapsulation

:numref:`Figure %s <fig:mam_data_transfer_structure>` shows how data, which should be written to or read from a memory address is encapsulated.

In a first step, a **MAM Transfer Request** is formed, which consists of a header, the address to write to/read from, and (for write accesses) the data itself.
In a second step, the MAM Transfer Request is split into parts each not exceeding the maximum payload size of the Debug Interconnect.
Out of each of the resulting chunks a DI Packet of type ``EVENT`` is created.

In case of read accesses or acknowledged (synchronous) write accesses, a response is sent from the MAM to the source of the MAM Transfer Request.

In the following, we first explaing the structure of the different types of MAM transfers, and then its packetization into DI Packets.

MAM Transfer Request
^^^^^^^^^^^^^^^^^^^^

A MAM Transfer Request is used to read or write *s* bytes of data, starting at the byte address *addr*.

.. note::

  The address *addr* must be word-aligned according to the data width ``DW``.
  To access non-aligned data the byte-select field ``SELSIZE`` can be used.

A transfer request is structured as a sequence of bytes, consisting of a header, the memory byte address, and (in case of a write request) the write data.
The structure of a MAM Transfer Request is given below.

The following variables are used:

- ``AW`` and ``DW`` are the address and data width, respectively, of the memory.
  The values for these variables can be read from the MAM control registers.
- *s* is the number of bytes to transfer.
- *a* is the size of a memory address in bytes, calculated as *a* = ``AW`` / 8.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.50\linewidth-2\tabcolsep}|
.. flat-table:: Structure of a MAM Transfer Request
  :widths: 2 3 5
  :header-rows: 1

  * - byte
    - name
    - description

  * - :cspan:`2` **MAM Transfer Request Header**

  * - 0
    - ``HDR0``
    - MAM Transfer Request Header (part 1)

  * - 1
    - ``HDR1``
    - MAM Transfer Request Header (part 2)

  * - :cspan:`2` **Address**

  * - 2
    - ``ADDR(0)``
    - most significant byte of the read/write address, i.e. ``addr[AW-1 : AW-8]``

  * - ...
    - ...
    - ...

  * - 1 + *a*
    - ``ADDR(a-1)``
    - least significant byte of the read/write address, i.e. ``addr[7 : 0]``

  * - :cspan:`2` **Write Data**

  * - 1 + *a* + 1
    - ``D(0)``
    - the first data byte to be transferred, to be written to address *addr*.

  * - 1 + *a* + 2
    - ``D(1)``
    - the second data byte to be transferred, to be written to address (*addr* + 1).

  * - ...
    - ...
    - ...

  * - 1 + *a* + *s*
    - ``D(s-1)``
    - the last data byte to be transferred, to be written to address (*addr* + *s* - 1).

MAM Transfer Request Header, Part 1 (HDR0)
""""""""""""""""""""""""""""""""""""""""""

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.70\linewidth-2\tabcolsep}|
.. flat-table:: Field Reference: ``HDR0``
  :widths: 1 2 7
  :header-rows: 1

  * - Bit(s)
    - Field
    - Description

  * - 7
    - ``WE``
    - **Write Enable**

      **0: Read**
        read from memory

      **1: Write**
        write to memory

  * - 6
    - ``BURST``
    - **Burst or Single Word Access Mode**

      This flag switches between burst and single word access.

      **0: Single Word Access**
        Use single word access.

      **1: Burst Access**
        Read or write from a continuous region of memory.

  * - 5
    - ``SYNC``
    - **Use Synchronous Writes**

      **0: Asynchronous Writes**
        Asynchronous writes are not acknowledged by the MAM, thus other modules
        cannot know when a write has finished and the data has reached the
        attached memory. However, subsequent reads from the same MAM will return
        the newly written data.

      **1: Synchronous Writes**
        Synchronous writes are acknowledged by the MAM.
        The acknowledgement is an empty read response.

  * - 4:0
    - ``RESERVED``
    - **Reserved for future extensions**

MAM Transfer Request Header, Part 2 (HDR1)
""""""""""""""""""""""""""""""""""""""""""

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.70\linewidth-2\tabcolsep}|
.. flat-table:: Field Reference: ``HDR1``
  :widths: 1 2 7
  :header-rows: 1

  * - Bit(s)
    - Field
    - Description

  * - 7:0
    - SELSIZE
    - **Burst Size/Byte Select**

      This field has a different meaning depending on the value of the ``HDR0.BURST`` field.

      **If HDR0.BURST = 1: Burst Size**
        The number of words the transfer consists of, i.e. (*s* / ``DW``).

      **If HDR0.BURST = 0: Byte Select**
        Only relevant for writes (``HDR0.WE`` = 1): byte select.
        ``SELSIZE`` contains a bit mask, a data byte is only written if a corresponding bit in the mask is set to 1.
        For example, set ``SELSIZE[0] := 1`` to write ``D0``.

MAM Transfer Response
^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.50\linewidth-2\tabcolsep}|
.. flat-table:: Structure of a MAM Transfer Response
  :widths: 2 3 5
  :header-rows: 1

  * - byte
    - name
    - description

  * - :cspan:`2` **Read Data**

  * - 1 + *a* + 1
    - ``D(0)``
    - the first data byte read from the memory at address *addr*.

  * - 1 + *a* + 2
    - ``D(1)``
    - the second data byte read from the memory at address (*addr* + 1).

  * - ...
    - ...
    - ...

  * - 1 + *a* + *s*
    - ``D(s-1)``
    - the last data byte read from the memory at address (*addr* + *s* - 1).


Packetization
^^^^^^^^^^^^^

A MAM Transfer (both request and response) is packetized into DI event packets for transmission over the debug interconnect.
Towards this goal, a MAM Transfer is split into chunks of each (MAX_PAYLOAD_LEN * 2) bytes.
Each such chunk is sent as ``PAYLOAD`` in a DI packet.

The maximum number of payload words in a Debug Packet (``MAX_PAYLOAD_LEN``) can be determined by reading the ``MAX_PKT_LEN`` register of the SCM module and subtracting 3 to account for the header words.

The following fields in the header of the DI packet are set:

- ``FLAGS.TYPE`` is set to ``EVENT``
- ``FLAGS.TYPE_SUB`` is set to 0


.. tabularcolumns:: |p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.70\linewidth-2\tabcolsep}|
.. flat-table:: MAM Packet Structure
  :widths: 3 7
  :header-rows: 1

  * - payload word
    - description

  * - 0
    - [15 : 8] := ``D(0)``, [7 : 0] := ``D(1)``

  * - 1
    - [15 : 8] := ``D(2)``, [7 : 0] := ``D(3)``

  * - ...
    - ...

  * - ``MAX_PAYLOAD_LEN`` - 1
    - ...

All packets except the last one should be of size ``MAX_PKT_LEN`` to reduce overhead.
