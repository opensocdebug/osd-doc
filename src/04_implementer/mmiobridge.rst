
Memory-Mapped I/O (MMIO) Bridge
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: img/debug_module_mmiobridge.*
   :alt: The convenience MMIO bridge wrapper
   :name: fig:debug_module_mmiobridge

   The MMIO convenience wrapper.

OSD comes with convenience wrapper that maps the register access debug
packets to memory-mapped bus interface. As depicted in
:numref:`Figure %s <fig:debug_module_mmiobridge>` this module is especially useful for
host-controlled modules, such as run-control debugging.

The basic bus interface allows for register addresses. The data width is
configurable, for example as a processor's data width. The memory
addresses are register numbers, so that is is not possible to address
unaligned to the configured data width.

Finally, there is an ``interrupt`` signal that can be used to send
unsolicited events to the host, for example a ``breakpoint`` event. The
bridge is configured to read a value from a configured address and send
it to the host. Thereby it is possible to implement run-control
debugging without polling for events.
