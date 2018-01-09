Programmer Interface: Control Registers
---------------------------------------

The Memory Access Module implements the :ref:`sec:spec:api:base_register_map`.
The reset values are listed below.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|
.. flat-table:: MAM base register reset values
  :widths: 2 2 4 2
  :header-rows: 1

  * - address
    - name
    - description
    - reset value

  * - 0x0000
    - ``MOD_VENDOR``
    - module vendor
    - 0x0001

  * - 0x0001
    - ``MOD_TYPE``
    - module type identifier
    - 0x0003

  * - 0x0002
    - ``MOD_VERSION``
    - module version
    - 0x0000

  * - 0x0003
    - ``MOD_CS``
    - module control and status
    - 0x0001

  * - 0x0004
    - ``MOD_EVENT_DEST``
    - destination of debug events
    - 0x0000 (unused, read-only)

Additionally, it implements the following control registers for MAM-specific functionality.


.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: MAM register map
  :widths: 2 2 6
  :header-rows: 1

  * - address
    - name
    - description

  * - 0x0200
    - ``AW``
    - address width of the attached memory in bits.
      Valid values are 16, 32 and 64.

  * - 0x0201
    - ``DW``
    - data width of the attached memory in bits.
      Valid values are 16, 32 and 64.

  * - 0x0202
    - ``REGIONS``
    - number of memory regions

  * - 0x0280
    - ``REGION0_BASEADDR_0``
    - Bits [15:0] (least significant bits) of the base address of region 0

  * - 0x0281
    - ``REGION0_BASEADDR_1``
    - Bits [31:16] of the base address of region 0

  * - 0x0282
    - ``REGION0_BASEADDR_2``
    - Bits [47:32] of the base address of region 0

  * - 0x0283
    - ``REGION0_BASEADDR_3``
    - Bits [63:48] (most significant bits) of the base address of region 0

  * - 0x0284
    - ``REGION0_MEMSIZE_0``
    - Bits [15:0] (least significant bits) of the memory size of region 0

  * - 0x0285
    - ``REGION0_MEMSIZE_1``
    - Bits [31:16] of the memory size of region 0

  * - 0x0286
    - ``REGION0_MEMSIZE_2``
    - Bits [47:32] of the memory size of region 0

  * - 0x0287
    - ``REGION0_MEMSIZE_3``
    - Bits [63:48] (most significant bits) of the memory size of region 0

  * - 0x0290
    - ``REGION1_BASEADDR_0``
    - Bits [15:0] (least significant bits) of the base address of region 1

  * - 0x0291
    - ``REGION1_BASEADDR_1``
    - Bits [31:16] of the base address of region 1

  * - 0x0292
    - ``REGION1_BASEADDR_2``
    - Bits [47:32] of the base address of region 1

  * - 0x0293
    - ``REGION1_BASEADDR_3``
    - Bits [63:48] (most significant bits) of the base address of region 1

  * - 0x0294
    - ``REGION1_MEMSIZE_0``
    - Bits [15:0] (least significant bits) of the memory size of region 1

  * - 0x0295
    - ``REGION1_MEMSIZE_1``
    - Bits [31:16] of the memory size of region 1

  * - 0x0296
    - ``REGION1_MEMSIZE_2``
    - Bits [47:32] of the memory size of region 1

  * - 0x0297
    - ``REGION1_MEMSIZE_3``
    - Bits [63:48] (most significant bits) of the memory size of region 1

  * - 0x02A0
    - ``REGION2_BASEADDR_0``
    - Bits [15:0] (least significant bits) of the base address of region 2

  * - 0x02A1
    - ``REGION2_BASEADDR_1``
    - Bits [31:16] of the base address of region 2

  * - 0x02A2
    - ``REGION2_BASEADDR_2``
    - Bits [47:32] of the base address of region 2

  * - 0x02A3
    - ``REGION2_BASEADDR_3``
    - Bits [63:48] (most significant bits) of the base address of region 2

  * - 0x02A4
    - ``REGION2_MEMSIZE_0``
    - Bits [15:0] (least significant bits) of the memory size of region 2

  * - 0x02A5
    - ``REGION2_MEMSIZE_1``
    - Bits [31:16] of the memory size of region 2

  * - 0x02A6
    - ``REGION2_MEMSIZE_2``
    - Bits [47:32] of the memory size of region 2

  * - 0x02A7
    - ``REGION2_MEMSIZE_3``
    - Bits [63:48] (most significant bits) of the memory size of region 2

  * - 0x02B0
    - ``REGION3_BASEADDR_0``
    - Bits [15:0] (least significant bits) of the base address of region 3

  * - 0x02B1
    - ``REGION3_BASEADDR_1``
    - Bits [31:16] of the base address of region 3

  * - 0x02B2
    - ``REGION3_BASEADDR_2``
    - Bits [47:32] of the base address of region 3

  * - 0x02B3
    - ``REGION3_BASEADDR_3``
    - Bits [63:48] (most significant bits) of the base address of region 3

  * - 0x02B4
    - ``REGION3_MEMSIZE_0``
    - Bits [15:0] (least significant bits) of the memory size of region 3

  * - 0x02B5
    - ``REGION3_MEMSIZE_1``
    - Bits [31:16] of the memory size of region 3

  * - 0x02B6
    - ``REGION3_MEMSIZE_2``
    - Bits [47:32] of the memory size of region 3

  * - 0x02B7
    - ``REGION3_MEMSIZE_3``
    - Bits [63:48] (most significant bits) of the memory size of region 3

  * - 0x02C0
    - ``REGION4_BASEADDR_0``
    - Bits [15:0] (least significant bits) of the base address of region 4

  * - 0x02C1
    - ``REGION4_BASEADDR_1``
    - Bits [31:16] of the base address of region 4

  * - 0x02C2
    - ``REGION4_BASEADDR_2``
    - Bits [47:32] of the base address of region 4

  * - 0x02C3
    - ``REGION4_BASEADDR_3``
    - Bits [63:48] (most significant bits) of the base address of region 4

  * - 0x02C4
    - ``REGION4_MEMSIZE_0``
    - Bits [15:0] (least significant bits) of the memory size of region 4

  * - 0x02C5
    - ``REGION4_MEMSIZE_1``
    - Bits [31:16] of the memory size of region 4

  * - 0x02C6
    - ``REGION4_MEMSIZE_2``
    - Bits [47:32] of the memory size of region 4

  * - 0x02C7
    - ``REGION4_MEMSIZE_3``
    - Bits [63:48] (most significant bits) of the memory size of region 4

  * - 0x02D0
    - ``REGION5_BASEADDR_0``
    - Bits [15:0] (least significant bits) of the base address of region 5

  * - 0x02D1
    - ``REGION5_BASEADDR_1``
    - Bits [31:16] of the base address of region 5

  * - 0x02D2
    - ``REGION5_BASEADDR_2``
    - Bits [47:32] of the base address of region 5

  * - 0x02D3
    - ``REGION5_BASEADDR_3``
    - Bits [63:48] (most significant bits) of the base address of region 5

  * - 0x02D4
    - ``REGION5_MEMSIZE_0``
    - Bits [15:0] (least significant bits) of the memory size of region 5

  * - 0x02D5
    - ``REGION5_MEMSIZE_1``
    - Bits [31:16] of the memory size of region 5

  * - 0x02D6
    - ``REGION5_MEMSIZE_2``
    - Bits [47:32] of the memory size of region 5

  * - 0x02D7
    - ``REGION5_MEMSIZE_3``
    - Bits [63:48] (most significant bits) of the memory size of region 5

  * - 0x02E0
    - ``REGION6_BASEADDR_0``
    - Bits [15:0] (least significant bits) of the base address of region 6

  * - 0x02E1
    - ``REGION6_BASEADDR_1``
    - Bits [31:16] of the base address of region 6

  * - 0x02E2
    - ``REGION6_BASEADDR_2``
    - Bits [47:32] of the base address of region 6

  * - 0x02E3
    - ``REGION6_BASEADDR_3``
    - Bits [63:48] (most significant bits) of the base address of region 6

  * - 0x02E4
    - ``REGION6_MEMSIZE_0``
    - Bits [15:0] (least significant bits) of the memory size of region 6

  * - 0x02E5
    - ``REGION6_MEMSIZE_1``
    - Bits [31:16] of the memory size of region 6

  * - 0x02E6
    - ``REGION6_MEMSIZE_2``
    - Bits [47:32] of the memory size of region 6

  * - 0x02E7
    - ``REGION6_MEMSIZE_3``
    - Bits [63:48] (most significant bits) of the memory size of region 6

  * - 0x02F0
    - ``REGION7_BASEADDR_0``
    - Bits [15:0] (least significant bits) of the base address of region 7

  * - 0x02F1
    - ``REGION7_BASEADDR_1``
    - Bits [31:16] of the base address of region 7

  * - 0x02F2
    - ``REGION7_BASEADDR_2``
    - Bits [47:32] of the base address of region 7

  * - 0x02F3
    - ``REGION7_BASEADDR_3``
    - Bits [63:48] (most significant bits) of the base address of region 7

  * - 0x02F4
    - ``REGION7_MEMSIZE_0``
    - Bits [15:0] (least significant bits) of the memory size of region 7

  * - 0x02F5
    - ``REGION7_MEMSIZE_1``
    - Bits [31:16] of the memory size of region 7

  * - 0x02F6
    - ``REGION7_MEMSIZE_2``
    - Bits [47:32] of the memory size of region 7

  * - 0x02F7
    - ``REGION7_MEMSIZE_3``
    - Bits [63:48] (most significant bits) of the memory size of region 7


Address Width (``AW``)
^^^^^^^^^^^^^^^^^^^^^^

- Address: 0x0200
- Reset Value: *implementation specific*
- Access: read-only

The Address Width (AW) register contains the width of a memory address in bits.
Address Width is guaranteed to be a multiple of 16.


Data Width (``DW``)
^^^^^^^^^^^^^^^^^^^

- Address: 0x0201
- Reset Value: *implementation specific*
- Access: read-only

The Data Width (DW) register contains the width of a data word in bits.
Data Width is guaranteed to be a multiple of 16.


Number of Memory Regions (``REGIONS``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: 0x0202
- Reset Value: *implementation specific*
- Access: read-only

The Regions (REGIONS) register holds the number of memory regions available,
as set during design time. At least 1 region is available.

Region Memory Base Address (``REGION*_BASEADDR_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: *implementation specific*
- Access: read-only

The base address of a region 0-7 is given in the ``REGION*_BASEADDR_*`` registers.
The base address is a 64 bit number stored in big endian format in four configuration registers.

For example, the base address of region 0 can be determined by the following operation:

.. code::

   region0_baseaddr = REGION0_BASEADDR_3 << 48 | REGION0_BASEADDR_2 << 32 | REGION0_BASEADDR_1 << 16 | REGION0_BASEADDR_0

.. note::

   For any given region, the corresponding base address register is only present if the region actually exists.
   You must read the REGIONS register first to determine how many regions are available.

Region Memory Size (``REGION*_MEMSIZE_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: *implementation specific*
- Access: read-only

The memory size of a region 0-7 is given in the ``REGION*_MEMSIZE_*`` registers.
The memory size is a 64 bit number stored in big endian format in four configuration registers.

For example, the memory size of region 0 can be determined by the following operation:

.. code::

   region0_memsize = REGION0_MEMSIZE_3 << 48 | REGION0_MEMSIZE_2 << 32 | REGION0_MEMSIZE_1 << 16 | REGION0_MEMSIZE_0

.. note::

   For any given region, the corresponding memory size register is only present if the region actually exists.
   You must read the REGIONS register first to determine how many regions are available.
