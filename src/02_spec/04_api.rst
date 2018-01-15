********************
Programmer Interface
********************

.. _sec:spec:api:base_register_map:

Debug Module Base Register Map
==============================


To enable functionality like the discovery of debug modules, all debug modules MUST implement the "Open SoC Debug Status & Control" registers and MUST follow the base address map.

All registers are accessed through Debug Packets of ``TYPE == REG``.


Debug module base address map
-----------------------------

+-------------------------+-------------------------------+
| Address Range           | Description                   |
+=========================+===============================+
| ``0x0000`` - ``0x01ff`` | Open SoC Debug Base Registers |
+-------------------------+-------------------------------+
| ``0x0200`` - ``0xffff`` | Module-specific registers     |
+-------------------------+-------------------------------+

All debug modules MUST implement the Open SoC Debug base registers.

Debug modules MAY implement any additional registers in the module-specific register space (register addresses between 0x0200 and 0xffff).

Open SoC Debug Base Registers
-----------------------------

All base registers are 16 bit wide.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.50\linewidth-2\tabcolsep}|
.. flat-table:: Open SoC Debug base register map
  :widths: 2 3 5
  :header-rows: 1

  * - address
    - name
    - description

  * - 0x0000
    - ``MOD_VENDOR``
    - module vendor

  * - 0x0001
    - ``MOD_TYPE``
    - module type identifier

  * - 0x0002
    - ``MOD_VERSION``
    - module version

  * - 0x0003
    - ``MOD_CS``
    - module control and status

  * - 0x0004
    - ``MOD_EVENT_DEST``
    - destination of debug events


Module Vendor Identifier (``MOD_VENDOR``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- Address: 0x0000
- Reset Value: implementation defined
- Access: read-only

The module vendor identifier is a 16 bit value.
Vendor identifiers MUST be assigned by the Open SoC Debug project before they can be used.
The Open SoC Debug project SHALL provide a publicly accessible list of all known vendors.

.. note::
  A list of assigned vendor IDs is available online at :ref:`sec:idregistry:vendorids`.


Module type identifier (``MOD_TYPE``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- Address: 0x0001
- Reset Value: implementation defined
- Access: read-only

The module type identifier describes the module type.
It is assigned by the module vendor.
The combination of ``MOD_VENDOR`` and ``MOD_TYPE`` must be descriptive for a given debug module across all conforming implementations.

Module Version (``MOD_VERSION``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- Address: 0x0002
- Reset Value: implementation defined
- Access: read-only

The versions are plain numbers that identify the module version.
The module version can be used by the host software to adapt the communication protocol to the API specific to a module version.
A module's API MUST NOT change in incompatible ways as long as the same module version is used.

Control and Status (``MOD_CS``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- Address: 0x0003
- Reset Value: *see the table below*
- Access: *see the table below*

Module control and status register.

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|
.. flat-table:: Field Reference: ``MOD_CS``
  :widths: 1 3 1 1 4
  :header-rows: 1

  * - Bit(s)
    - Field
    - Access
    - Reset Value
    - Description

  * - 15:1
    - ``RESERVED``
    - r/w
    - 0x0
    - **Reserved for future use**

      This field is reserved for future use.
      Implementations MUST ignore the contents of this field.

  * - 0
    - ``MOD_CS_ACTIVE``
    - r/w
    - 0b0
    - **Activate or stall the debug module**

      **0b0: Module is stalled**
        The module is stalled.
        A stalled module MAY NOT send any debug events, i.e. packets of ``TYPE == EVENT``.

      **0b1: Module is active**
        The module is active.
        An active event MAY send debug events, i.e. packets of ``TYPE == EVENT``.


Event Destination (``MOD_EVENT_DEST``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- Address: 0x0004
- Reset Value: *see the table below*
- Access: *see the table below*

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.30\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|
.. flat-table:: Field Reference: ``MOD_EVENT_DEST``
  :widths: 1 3 1 1 4
  :header-rows: 1

  * - Bit(s)
    - Field
    - Access
    - Reset Value
    - Description

  * - 15:10
    - ``RESERVED``
    - r/w
    - 0x0
    - **Reserved for future use**

      This field is reserved for future use.
      Implementations MUST ignore the contents of this field.

  * - 9:0
    - ``MOD_EVENT_DEST_ADDR``
    - r/w
    - 0x0
    - **Event Packet Destination**

      Address of the module in the Debug Interconnect to which all event packets (``TYPE == EVENT``) should be sent.

      Changing the destination address MAY not take immediate effect, but MUST take effect soon after it has been set (e.g. after a buffer has been cleared).
      The exact timing behavior is implementation-defined.
