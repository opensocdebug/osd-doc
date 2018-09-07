.. _uart-registers:

16550 UART Registers
--------------------

The following UART registers are implemented and accessible via the bus, the address mapping is in accordance with the UART-16550(A) standard as specified in this `Datasheet <http://caro.su/msx/ocm_de1/16550.pdf>`_.
No FIFOs are present in hardware.
No Modem or DMA-Mode related features, registers or interrupts are implemented.
Writing to a register that is not implemented has no effect, reading from such a register will always return ``0x00``.

All registers are 8 bit wide.

.. tabularcolumns:: |p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.10\linewidth-2\tabcolsep}|p{\dimexpr 0.50\linewidth-2\tabcolsep}|
.. flat-table:: 16550 UART Registers
  :widths: 1 1 2 1 5
  :header-rows: 1

  * - Address
    - Register
    - Access Type
    - Reset Value
    - Description

  * - ``0x00``
    - ``RBR``
    - Read only
    - ``0x00``
    - Receiver Buffer Register

  * - ``0x00``
    - ``THR``
    - Write only
    - ``0x00``
    - Transmitter Holding Register

  * - ``0x01``
    - ``IER``
    - Read/Write
    - ``0x00``
    - Enable(1)/Disable(0) interrupts. See `this <http://caro.su/msx/ocm_de1/16550.pdf>`_ for more details on each interrupt.

  * - ``0x02``
    - ``IIR``
    - Read only
    - ``0x01``
    - Information which interrupt occurred

  * - ``0x02``
    - ``FCR``
    - Write only
    - ``0x00``
    - Control behavior of the internal FIFOs. Currently writing to this Register has no effect.

  * - ``0x03``
    - ``LCR``
    - Read/Write
    - ``0x00``
    - The only bit in this register that has any meaning is ``LCR7`` aka the DLAB, all other bits hold their written value but have no meaning.

  * - ``0x05``
    - ``LSR``
    - Read only
    - ``0x60``
    - Information about state of the UART. After the UART is reset, ``0x60`` indicates when it is ready to transmit data.
