Programmer Interface: Control Registers
---------------------------------------

The Core Trace Module implements the :ref:`sec:spec:api:base_register_map`.
The reset values are listed below.

.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.40\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|
.. flat-table:: CTM base register reset values
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
    - 0x0005

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

Additionally, it implements the following control registers for module-specific functionality.


.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.60\linewidth-2\tabcolsep}|
.. flat-table:: CTM register map
  :widths: 2 2 6
  :header-rows: 1

  * - address
    - name
    - description

  * - 0x0200
    - ``ADDR_WIDTH``
    - width of memory addresses in bit.
      Valid values are 16, 32 and 64.

  * - 0x0201
    - ``DATA_WIDTH``
    - width of a data word in bit.
      Valid values are 16, 32 and 64.
