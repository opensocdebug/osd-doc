Programmer Interface: Control Registers
---------------------------------------

The Memory Access Module implements the :ref:`sec:spec:api:base_register_map`.
Additionally, it implements the following control registers for MAM-specific functionality.


.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: MAM register map
  :widths: 2 2 6
  :header-rows: 1

  * - address
    - name
    - description

  * - ``0x0200``
    - ``AW``
    - address width of the attached memory in bits

  * - ``0x0201``
    - ``DW``
    - data width of the attached memory in bits

  * - ``0x0202``
    - ``CONF``
    - MAM configuration


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


Configuration (``CONF``)
^^^^^^^^^^^^^^^^^^^^^^^^

- Address: 0x0202
- Reset Value: *implementation specific*
- Access: read-only

The Configuration (CONF) register describes the configuration of the MAM module,
as set during design time.

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|
.. flat-table:: Field Reference: ``CONF``
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
    - ``UNAL``
    - *impl.-spec.*
    - ro
    - **Unaligned Accesses Allowed**

      This flag informs the reader if memory accesses not aligned to the Data Width are allowed by the memory.

      **0b0: Unaligned Accesses Disallowed**
        Only aligned memory accesses are allowed, every address must be divisible
        by the Data Width without remainder.

      **0b1: Unaligned Accesses Allowed**
        Unaligned accesses are allowed.

.. todo::
  The spec uses 0x202 for unaligned accesses, the implementation for regions. sync the two.
