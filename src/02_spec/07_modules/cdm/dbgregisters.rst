Programmer Interface: Control Registers
---------------------------------------

The Control Debug Module implements the :ref:`sec:spec:api:base_register_map`.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|
.. flat-table:: CDM base register reset values
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

Additionally, the CDM implements the following registers.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|
.. flat-table:: CDM register map
  :widths: 2 2 2 4
  :header-rows: 1

  * - address
    - name
    - width (bit)
    - description

  * - 0x0200
    - ``CORE_CTRL``
    - 16
    - Control the CPU core

  * - 0x0201
    - ``CORE_REG_UPPER``
    - 16
    - Most significant bits of the SPR address (see below)

  * - 0x0202
    - ``CORE_DATA_WIDTH``
    - 16
    - Register data width of the attached CPU core in bits

  * - 0x8000-0xFFFF
    -
    - 32
    - Access to the SPRs of the CPU core (see below)


Core Control Register (``CORE_CTRL``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: 0x0200
- Reset Value: 0
- Data Width: 16 bit
- Access: read-write

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|
.. flat-table:: Field Reference: ``CORE_CTRL``
  :widths: 1 3 1 1 4
  :header-rows: 1

  * - Bit(s)
    - Field
    - Access
    - Reset Value
    - Description

  * - 15:1
    - ``RES``
    - r/w
    - 0x0
    - **Reserved**

  * - 0
    - ``STALL``
    - r/w
    - *impl.-spec.*
    - **Core Stall**

      Stall the attached CPU core.

      **0b1: Stall the core**
        The core is stalled.

      **0b0: Unstall the core**
        The core is unstalled.


Core Upper Register (``CORE_REG_UPPER``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: 0x0201
- Reset Value: 0
- Data Width: 16 bit
- Access: read-write

The most significant bit of the SPR register address.
See the section "Access to core registers" for more details.


Core Data Width (``CORE_DATA_WIDTH``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Address: 0x0202
- Reset Value: 0
- Data Width: 16 bit
- Access: read-write

The register width of the CPU core (in bits) the CDM module is connected to. 
Valid values are 16, 32 and 64 and 128.


Access to core registers
^^^^^^^^^^^^^^^^^^^^^^^^
- Address: 0x8000-0xFFFF
- Reset Value: *implementation specific*
- Data Width: 32 bit
- Access: read-write

Accesses to CDM registers between 0x8000 and 0xFFFF are forwarded to the SPRs of the attached CPU core.
The register address of the accessed SPR can be determined with the help of the ``CORE_REG_UPPER`` value using the following rule:

.. code::

   spr_reg_addr = CORE_REG_UPPER << 15 | cdm_reg_addr - 0x8000

Consult the specification of the attached CPU core for a further description of the register accessed, and possible access limitations (e.g. read-only registers).
