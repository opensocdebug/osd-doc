Debug Register Interface
========================

The Memory Access Module provides three debug registers.

Address Width (AW)
------------------

- Address: 0x200
- Reset Value: *implementation specific*
- Access: read-only

The Address Width (AW) register contains the width of a memory address in bits.
Address Width is guaranteed to be a multiple of 16.


Data Width (DW)
---------------

- Address: 0x201
- Reset Value: *implementation specific*
- Access: read-only

The Data Width (DW) register contains the width of a data word in bits.
Data Width is guaranteed to be a multiple of 16.


Configuration (CONF)
--------------------

- Address: 0x202
- Reset Value: *implementation specific*
- Access: read-only

The Configuration (CONF) register describes the configuration of the MAM module,
as set during design time.

.. flat-table:: Field Reference: CONF
  :widths: 2 2 1 10
  :header-rows: 1


  * - Bit(s)
    - Field
    - Type
    - Description

  * - [15:1]
    - RES
    - `-`
    - **Reserved**

  * - 0
    - UNAL
    - r
    - **Unaligned Accesses Allowed**

      This flag informs the reader if memory accesses not aligned to the Data Width
      are allowed by the memory.

      **0: Unaligned Accesses Disallowed**
        Only aligned memory accesses are allowed, every address must be divisible
        by the Data Width without remainder.

      **1: Unaligned Accesses Allowed**
        Unaligned accesses are allowed.

.. todo::
  The spec uses 0x202 for unaligned accesses, the implementation for regions. sync the two.
