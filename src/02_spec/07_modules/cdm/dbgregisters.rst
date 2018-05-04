Programmer Interface: Control Registers
---------------------------------------

The Control Debug Module of OR1K CPU core implements the :ref:`sec:spec:api:base_register_map`.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|
.. flat-table:: CDM-OR1K base register reset values
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
    - 0x0006

  * - 0x0002
    - ``MOD_VERSION``
    - module version
    - 0x0000

  * - 0x0003
    - ``MOD_CS``
    - module control and status
    - 0x0000

  * - 0x0004
    - ``MOD_EVENT_DEST``
    - destination of debug events
    - 0x0000

Additionally, the CDM-OR1K module implements the following registers. 
Registers in the range **0x0400-0x443** are forwarded to corresponding registers of the attached OR1k CPU core. 
Each OR1k debug register is 32-bit wide and is mapped as two 16-bit wide registers.  

.. tabularcolumns:: |p{\dimexpr 0.40\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: CDM-OR1K register address scheme
  :widths: 4 6
  :header-rows: 1

  * - Register
    - Address

  * - OR1K_DBGR_L
    - or1k dbg register index*2 + 0x400
 
  * - OR1K_DBGR_H  
    - or1k dbg register index*2 + 0x400 + 1 


.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: CDM-OR1K register map
  :widths: 2 2 6
  :header-rows: 1

  * - address
    - name
    - description

  * - 0x0200
    - ``OR1K_DWRT_UPDATE``
    - Writing 1 to bit 0 commits data written to the registers of the CPU core.

  * - 0x0400
    - ``OR1K_DVR0_L``
    - Bits [15:0] (least significant bits) DVR0

  * - 0x0401
    - ``OR1K_DVR0_H``
    - Bits [31:16] of DVR0
   
  * - 0x0402
    - ``OR1K_DVR1_L``
    - Bits [15:0] (least significant bits) of DVR1

  * - 0x0403
    - ``OR1K_DVR1_H``
    - Bits [31:16] of DVR1

  * - 0x0404
    - ``OR1K_DVR2_L``
    - Bits [15:0] (least significant bits) of DVR2

  * - 0x0405
    - ``OR1K_DVR2_H``
    - Bits [31:16] of DVR2

  * - 0x0406
    - ``OR1K_DVR3_L``
    - Bits [15:0] (least significant bits) of DVR3

  * - 0x0407
    - ``OR1K_DVR3_H``
    - Bits [31:16] of DVR3

  * - 0x0408
    - ``OR1K_DVR4_L``
    - Bits [15:0] (least significant bits) of DVR4

  * - 0x0409
    - ``OR1K_DVR4_H``
    - Bits [31:16] of DVR4

  * - 0x0410
    - ``OR1K_DVR5_L``
    - Bits [15:0] (least significant bits) of DVR5

  * - 0x0411
    - ``OR1K_DVR5_H``
    - Bits [31:16] of DVR5

  * - 0x0412
    - ``OR1K_DVR6_L``
    - Bits [15:0] (least significant bits) of DVR6

  * - 0x0413
    - ``OR1K_DVR6_H``
    - Bits [31:16] of DVR6

  * - 0x0414
    - ``OR1K_DVR7_L``
    - Bits [15:0] (least significant bits) of DVR7

  * - 0x0415
    - ``OR1K_DVR7_H``
    - Bits [31:16] of DVR7

  * - 0x0416
    - ``OR1K_DCR0_L``
    - Bits [15:0] (least significant bits) of DCR0

  * - 0x0417
    - ``OR1K_DCR0_H``
    - Bits [31:16] of DCR0

  * - 0x0418
    - ``OR1K_DCR1_L``
    - Bits [15:0] (least significant bits) of DCR1

  * - 0x0419
    - ``OR1K_DCR1_H``
    - Bits [31:16] of DCR1

  * - 0x0420
    - ``OR1K_DCR2_L``
    - Bits [15:0] (least significant bits) of DCR2

  * - 0x0421
    - ``OR1K_DCR2_H``
    - Bits [31:16] of DCR2

  * - 0x0422
    - ``OR1K_DCR3_L``
    - Bits [15:0] (least significant bits) of DCR3

  * - 0x0423
    - ``OR1K_DCR3_H``
    - Bits [31:16] of DCR3

  * - 0x0424
    - ``OR1K_DCR4_L``
    - Bits [15:0] (least significant bits) of DCR4

  * - 0x0425
    - ``OR1K_DCR4_L``
    - Bits [31:16] of DCR4

  * - 0x0426
    - ``OR1K_DCR5_L``
    - Bits [15:0] (least significant bits) of DCR5

  * - 0x0427
    - ``OR1K_DCR5_H``
    - Bits [31:16] of DCR5

  * - 0x0428
    - ``OR1K_DCR6_L``
    - Bits [15:0] (least significant bits) of DCR6

  * - 0x0429
    - ``OR1K_DCR6_H``
    - Bits [31:16] of DCR6

  * - 0x0430
    - ``OR1K_DCR7_L``
    - Bits [15:0] (least significant bits) of DCR7

  * - 0x0431
    - ``OR1K_DCR7_H``
    - Bits [31:16] of DCR7

  * - 0x0432
    - ``OR1K_DMR1_L``
    - Bits [15:0] (least significant bits) of DMR1

  * - 0x0433
    - ``OR1K_DMR1_H``
    - Bits [31:16] of DMR1

  * - 0x0434
    - ``OR1K_DMR2_L``
    - Bits [15:0] (least significant bits) of DMR2

  * - 0x0435
    - ``OR1K_DMR2_H``
    - Bits [31:16] of DMR2

  * - 0x0436
    - ``OR1K_DWCR0_L``
    - Bits [15:0] (least significant bits) of Debug Watchpoint Counter 0

  * - 0x0437
    - ``OR1K_DWCR0_H``
    - Bits [31:16] of Debug Watchpoint Counter 0

  * - 0x0438
    - ``OR1K_DWCR1_L``
    - Bits [15:0] (least significant bits) of Debug Watchpoint Counter 1

  * - 0x0439
    - ``OR1K_DWCR1_H``
    - Bits [31:16] of Debug Watchpoint Counter 1

  * - 0x0440
    - ``OR1K_DSR_L``
    - Bits [15:0] (least significant bits) of Debug Stop Register

  * - 0x0441
    - ``OR1K_DSR_H``
    - Bits [31:16] of Debug Stop Register

  * - 0x0442
    - ``OR1K_DRR_L``
    - Bits [15:0] (least significant bits) of Debug Reason Register

  * - 0x0443
    - ``OR1K_DRR_H``
    - Bits [31:16] of Debug Reason Register

 

Debug Value Registers (``OR1K_DVR*_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: 0
- Access: read-write
- Register Index: 0-7
- More details: https://openrisc.io/or1k.html#__RefHeading__504813_595890882 (Section 10.2)

The debug value registers (DVR0-DVR7) are 32-bit special-purpose supervisor-level registers programmed with the watchpoint/breakpoint addresses or data.

Debug Control Registers (``OR1K_DCR*_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: 0
- Access: *see below*
- Register Index: 8-15
- More details: https://openrisc.io/or1k.html#__RefHeading__504815_595890882 (Section 10.3)

The debug control registers (DCR0-DCR7) are 32-bit special-purpose supervisor-level registers.
The DCRs are programmed with the watchpoint settings that define how DVRs are compared to the instruction fetch or load/store address or to the load/store data.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|
.. flat-table:: DCR Field Description
  :widths: 2 4 2 2   
  :header-rows: 1

  * - bits
    - identifier
    - reset
    - Access

  * - 31-8
    - Reserved
    - X
    - R

  * - 7-5
    - Compare To Condition
    - 0
    - R/W

  * - 4
    - Signed Comparison
    - 0
    - R/W

  * - 3-1
    - Compare Condition
    - 0
    - R/W

  * - 0
    - DVR/DCR Present
    - 0
    - R	
  

Debug Mode Register1 (``OR1K_DMR1_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: X (bits: 31-25) | 0 (bits: 23-0)
- Access: read (bits: 31-25) | read-write (bits: 23-0)
- Register Index: 16
- More details: https://openrisc.io/or1k.html#__RefHeading__504817_595890882 (Section 10.4)

The debug mode register 1 is a 32-bit special-purpose supervisor-level register.
It is programmed with the watchpoint/breakpoint settings that define how DVR/DCR pairs operate.

Debug Mode Register2 (``OR1K_DMR2_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: 0
- Access: read (bits: 31-22) | read-write (bits: 21-0)
- Register Index: 17
- More details: https://openrisc.io/or1k.html#__RefHeading__504819_595890882 (Section 10.5)

The debug mode register 1 is a 32-bit special-purpose supervisor-level register.
The DMR2 is programmed with the watchpoint/breakpoint settings that define which watchpoints generate a breakpoint and which watchpoint counters are enabled.


Debug Watchpoint Counter Registers (``OR1K_DWCR*_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: 0
- Access: read-write
- Register Index: 18-19
- More details: https://openrisc.io/or1k.html#__RefHeading__504821_595890882 (Section 10.6)

The debug watchpoint counter registers (DWCR0-DWCR1) are 32-bit special-purpose supervisor-level registers.
The DWCRs contain 16-bit counters that count watchpoints programmed in the DMR and 16-bit match values. 
When a counter reaches the match value, a watchpoint is generated.


Debug Stop Register (``OR1K_DSR_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: X (bits: 31-14) | 0 (bits: 13-0)
- Access: read (bits: 31-14) | read-write (bits: 13-0)
- Register Index: 20
- More details: https://openrisc.io/or1k.html#__RefHeading__504823_595890882 (Section 10.7)

The debug stop counter registers are 32-bit special-purpose supervisor-level registers.
The DSR specifies which exceptions cause the core to stop the execution of the exception handler and turn over control to development interface.


Debug Reason Register (``OR1K_DRR_*``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: *see full register map above*
- Reset Value: X (bits: 31-14) | 0 (bits: 13-0)
- Access: read (bits: 31-14) | read-write (bits: 13-0)
- Register Index: 21
- More details: https://openrisc.io/or1k.html#__RefHeading__504825_595890882 (Section 10.8)

The debug reason counter registers are 32-bit special-purpose supervisor-level registers.
The DRR specifies which event caused the core to stop the execution of program flow and turned control over to the development interface.


Debug Update Write Register (``OR1K_DWRT_UPDATE``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: 0x200
- Reset Value: 0
- Access: read-write 

Writing 1 to bit 0 commits data written to the registers of the CPU core.
