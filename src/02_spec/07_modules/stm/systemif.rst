System Interface: Software Trace Port
-------------------------------------

The software trace port is a simple data port with an ``enable`` signal.
There is no backpressure as the debug infrastructure is not supposed to
influence the processor execution.

The interface is defined as:

+------------+--------------+-----------------------------------------------------+
| Name       | Width        | Description                                         |
+============+==============+=====================================================+
| ``id``     | 16           | Trace identifier                                    |
+------------+--------------+-----------------------------------------------------+
| ``value``  | ``VALWIDTH`` | Trace value, width of CPU general purpose registers |
+------------+--------------+-----------------------------------------------------+
| ``enable`` | 1            | Trace an event this cycle                           |
+------------+--------------+-----------------------------------------------------+

Trace generation
----------------

The method of emitting a trace event depends on the micro-architecture.
Examples for existing processor core architectures are given in the
following.

Software Trace Port: OpenRISC
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In OpenRISC an interesting property of the instruction set is used: The
no-operation ``l.nop`` has a parameter ``K`` of 16 bit width. The
specification defines this parameter to be used for simulation purposes,
and it is here used to emit the trace value.

We use this operation for the trace identifier. As the compiler emits
``l.nop 0x0``, the user-defined value of ``0x0000`` is not available in
this specification.

The trace value is defined to be written to the general purpose register
``r3`` with the properties described before. As a general purpose
register is restored after interrupts, the atomicity property holds.
Finally, the register ``r3`` is the first function parameter register in
the ABI which eases efficient implementation of library functions for
trace events.

In the hardware implementation the writeback stage must be observed and
whenever a write to register ``r3`` is observed, the same value is
stored into the register ``value``. When completion of an ``l.nop``
operation is observed, the opeand ``K`` (if not equal to 0) and the
``value`` are emitted on the trace port for one cycle.

Finally, the following extension is required to support the trace event
``THREAD_SWITCH``: All writes to register ``r10`` must be tracked and if
a value is written, the trace event is emitted. The register is
historically reserved and in the Linux port used as thread-local storage
(TLS), which is unique for concurrently executed threads.

Software Trace Port: RISC-V
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In RISC-V an additional control register is added to emit a trace event
(non-standard for the moment). A write to this register triggers the
emission of the trace event for one cycle.

Beside this, the general purpose register ``x10`` (``a0``) is tracked
for updates as the trace event value, identical to the reasoning for
OpenRISC.

Finally the register ``x4`` (``tp``) may also be tracked and a
``THREAD_SWICH`` trace event is emitted on updates to the register.

Software Trace Port: Other cores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The method described for the RISC-V microarchitecture should be
applicable to a variety of RISC cores.

Software Trace Port: Out-of-Order
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

With out-of-order cores it is important to track the accesses to the two
data items properly, which can be enforced by a memory fence.

In an out-of-order implementation the software trace port may be
implemented more efficiently at stages where the trace event may still
be canceled. If that is the case, the software trace port should hold
back the value until it can be safely emitted or aborted beforehand.
