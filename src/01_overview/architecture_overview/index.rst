***************************
Open SoC Debug Architecture
***************************

.. todo::
  This document mixes our reference implementation with the specification.
  It probably should be rewritten to contain only a high-level reasoning about
  the design decisions; other sections should be moved to more appropriate
  places.

In Open SoC Debug, software and hardware components form together an extensible architecture.
This document introduces the architecture and the design decisions from a birds-level point of view.
It helps you to understand how the individual components interact and gives you a good understanding where to start when using or extending OSD for your purpose.

.. figure:: img/overview.*
   :alt: Debug System Overview
   :name: fig:overview

   Overview of an Open SoC Debug debug system

:numref:`Figure %s <fig:overview>` shows the different components in an Open SoC Debug-based
debug system.

-  **Debug modules** (shown on the right) monitor or interact with the
   functional components of the SoC. Towards the functional SoC the
   interface is implementation-specific. Towards the debug network the
   modules conform to a well-defined interface, consisting of two parts:
   a register-mapped control interface, and an event data interface
   (i.e. to send out trace data or other unsolicited messages).
-  The **debug network** is used to exchange messages between the debug
   modules and the host.
-  The **physical transport** connects the device to a host PC. For most
   implementations, we recommend using `GLIP <http://glip.io>`__.
-  On the host side, the **OSD host library** (``libopensocdebug``)
   provides a programming interface (API) to the debug system.
-  On top of that library, the **OSD daemon** (``opensocdebugd``) can be
   used to enable multiple debug tools to interact with the on-chip
   debug system.
-  Finally, **debug tools** use the debug system to perform debugging
   and analysis tasks, ranging from run-control debugging to tracing and
   runtime verification.

All parts of the OSD architecture have been designed with extensibility
in mind. But if no or only small customizations are needed, OSD also
includes reference implementations of most components which can be used to
get a system up and running quickly.

Debug Modules
=============

The debug modules either monitor a debug module or interact with it in
case of run-control debugging or special functionalities. On the other
side the debug modules generally interface the debug infrastructure via
the so called "Debug Interconnect Interface" (DII).

.. figure:: img/debug_module_generic_if.*
   :alt: Generic status and control interface
   :name: fig:debug_module_generic_if

   The generic status and control interface of all debug modules

All debug modules have a common debug-side status and control interface
as depicted in :numref:`Figure %s <fig:debug_module_generic_if>`.
It is a base register
map that contains mandatory and optional registers such as:

-  The *module class* and a module *vendor id* and *product id*, that
   support enumeration and software handling of the debug modules on the
   host
-  Enable and disable the entire module
-  Query module-specific capabilities and enable features

This interface usually runs in the debug system clock domain, while the
actual module logic is responsible for clock domain crossing between the
connected system component and the debug clock domain. Most simply,
tracing is usually done by (naturally) sampling the trace information in
the component's domain and cross the trace event via a small buffer into
the module logic that handles packetization of the trace event.

Register Access
---------------

The host sends register access packets to the debug modules to

-  read and write control & status registers, or
-  access a debug module functionality

For example, the host can send a ``REQ_READ_REG`` packet to read module
version from the defined memory address ``MOD_VERSION (0x1)``. The
module will reply with a ``RESP_READ_REG`` containing the module
version.

It is generally allowed that debug modules can also generate such
request to query or control other debug modules.

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

Debug Events
------------

Debug events are unsolicited messages generated from a debug module.
This can for examle be a "breakpoint hit" message from a run-control
debug module, or a trace message. In the first case the host usually
starts with a sequence of register accesses, while in general debug
events are of a fire-and-forget nature.

Trace Modules
-------------

.. figure:: img/generic_trace_module.*
   :alt: Generic trace module structure
   :name: fig:generic_trace_module

   Generic trace module structure

Trace modules have an overall structure as depicted in
:numref:`Figure %s <fig:generic_trace_module>`. Their task is to sample trace events
generated by the hardware. This trace events can be of arbitrary sizes,
but are usually constant at a single trace module's sampling interface.
Examples are:

-  A processor core's execution trace: Executed program counter,
   branch-taken or similar
-  A processor core's diagnosis trace: Functional unit utilization,
   branch predictor efficiency, etc.
-  Cache diagnosis trace: Hits/Misses, Conflicts, average memory access
   time, etc.
-  DMA controller trace: Start and end of request, average memory
   latency

Summarizing, nearly every hardware block is a candidate to generate
useful trace information.

Clock Domains
-------------

The base functionality of a trace module is packetization of the trace
data to trace event packets. Optionally, the module may filter events or
compress the event stream. At some point it is necessary to cross
between the module's clock domain and the debug clock domain. This can
alternatively be done on the trace event sampling, at the packet output
or somewhere in between, depending on which clock is faster and at which
rates trace events are generated.

Overflow Handling
-----------------

In case the trace events are generated at a faster rate than the host
interface can transfer. This problem becomes crucial with the increasing
number of trace modules. Generally, this can be done on the level of the
debug system by a sophisticated flow control that will be specified in
later revisions. An overflow occurs if a trace event is generated, but
cannot be transferred or buffered due to backpressure from the
interconnect, but backpressure cannot be generated to the system module.
In the current specification the trace infrastructure detects this
situation, counts how many packets could not be transfered and then
transfers a ``missed_events`` event once it the interface is available
again.

Transport and Switching
=======================

To route debug information to the correct debug module and to the host,
OSD uses a simple packet-based protocol. The packet size is limited by
the implementation and can be queried from the *System Control Module
(SCM)*. The minimum value for the maximum packet size is 8.

The *Debug Interconnect Interface (DII)* defines the data format and
flow control mechanism. The packet width must be at least 16 bit and
currently is set fixed to 16 bit.

The debug packets contain the necessary routing and identification
information, namely the destination and the source, in their header,
which are the first two data items in a packet.

One key property of the transport & switching in the Open SoC Debug
specification is that it generally allows that debug modules exchange
packets between them. This enables on-chip trace processing, run-control
debugging from a special core or other methods to reduce the traffic on
the host interface, which is the most critical resource in modern
debugging.

.. figure:: img/interconnect.*
   :alt: Debug ring and other interconnects
   :name: fig:interconnect

   Debug ring and other interconnects

In general, the interconnect can have any possible topology as long as
it fulfills two basic properties: strict-ordering of packets with the
same ``(src,dest)`` tuple and deadlock-freedom. The first property does
forbid debug packets from one source to one destination to overtake each
other in the interconnect to allow payload data to span multiple
packets. @Fig:interconnect shows the favored topologies. The baseline
implementation is a simple ring interconnect. The ring balances well
between clock speed, required chip area and most importantly
flexibility. It can easily span the entire chip without dominating a
design.

Alternatively, other topologies may be favored. For example a low count
of debug modules favors a multiplexer interconnect. Especially if the
debug modules are all trace debugging or all run-control debugging a bus
or similar can be favorable for low debug module counts. When the
modules also communicate with each other a crossbar may be used for high
throughput, but with the disadvantage of large area overhead.

Finally, we believe once some first tests with larger systems in the
real world have been performed, hierarchical topologies may become
favorable. Beside optimizing the resource utilization, aggregating
modules may bridge subsets of trace modules to the actual debug
interconnect to perform size optimizations on the aggregated packet
stream.

Physical Interface
==================

The physical interface is abstracted in Open SoC Debug as a FIFOs which
transmit data between the host and the device.

.. figure:: img/glip.*
   :alt: GLIP abstracts from the physical interface
   :name: fig:glip_overview

   GLIP as abstraction layer from the physical interface

While not required by OSD, we recommend building on top of
`GLIP <http://www.glip.io>`__ as depicted in @fig:glip\_overview. GLIP
provides a generic FIFO interface that reliably transfers data between
the host and the system. Multiple alternatives for simulations and
prototyping hardware exist. In a silicon device, a high-speed serial
interface is most probably favorable.

Host Software
=============

As mentioned before, the host software is not in the focus of the Open
SoC Debug project, but we strongly support development of debug software
around our infrastructure.

The basic level of the ``libopensocdebug`` is the packetization of debug
packets. It also provides higher-level functions, for example register
access functions or up to convenience functions to perform
module-specific operations. A debug tool can build against this library,
or alternatively start the ``opensocdebugd`` daemon that allows
multiplexing of one Open SoC Debug-enabled system between different
tools.

Basic Debug Modules
===================

In the following we will shortly introduce the core group of debug
modules which are be part of Open SoC Debug. Only two modules are
mandatory: The *Host Interface Module* to transfer data between the
debug system and the host or memory, and the *System Control Module*
that identifies the system, provides system details and controls the
system.

Host Interface Module (HIM)
---------------------------

.. figure:: img/debug_module_him.*
   :alt: Host Interface Module
   :name: fig:debug_module_him

   Host Interface Module

The *Host Interface Module (HIM)* converts the debug packets to a
``length``-``value`` encoded data stream, that is transferred using the
glip interconnect. This format is simple and contains the length of the
debug packet in one data item followed by the debug packet.

Alternatively, the HIM can be configured to store the debug packets to
the system memory using the memory interface.

Host Authentication Module (HAM)
--------------------------------

.. figure:: img/debug_module_ham.*
   :alt: Host Authentication Module
   :name: fig:debug_module_ham

   Host Authentication Module

The system can require the host to authenticate before connecting to the
debug system, because the debug can expose confidential information. A
*HAM* implementation can for example require a token to match or a
sophisticated challenge-response protocol. If configured the
`HIM <#host-interface-module-him>`__ will wait for the HAM to allow the
host to communicate with modules other than the HAM.

System Control Module (SCM)
---------------------------

.. figure:: img/debug_module_scm.*
   :alt: System Control Module
   :name: fig:debug_module_scm

   System Control Module

The *System Control Module (SCM)* is always mapped to address ``1`` on
the debug interconnect (``0`` is the host/HIM address). The host first
queries the SCM to provide system information, like a system identifier,
the number of debug modules, or the maximum packet length.

Beside that it can be used to control the system. For that it can set
the soft reset of the processor cores and the peripherals separately in
the first specification.

Core Debug Module (CDM)
-----------------------

.. figure:: img/debug_module_cdm.*
   :alt: Core Debug Module
   :name: fig:debug_module_cdm

   Core Debug Module

The core debug module implements run-control debugging for a processor
core. The implementation is to a certain degree core-dependent, but a
generic implementation is sketched in @fig:debug\_module\_cdm. It has a
memory mapped interface as described above. The debug control, status
information and core register are mapped in memory regions. The
run-control debugger (e.g., gdb) then sends register access requests. In
case of a debug event (breakpoint hit) ``interrupt`` signals are
asserted. As a reaction the CDM reads a defined address and the
core-specific part of the CDM generates a debug event.

Of course, other implementations are possible or may be required
depending on the interface processor implementation.

Core Trace Module (CTM)
-----------------------

The *Core Trace Module (CTM)* captures trace events generated from the
processor core. The implementation is core-dependent and will be highly
configurable. Such trace events are core-internal signals, like the
completion of an instruction, the branch predictor status, memory access
delays, cache miss rates, just to name a few possibilities.

The CTM specification will define a few basic trace events and how they
can efficiently packed, because such events are usually generated with a
high rate.

Software Trace Module (STM)
---------------------------

The *Software Trace Module (STM)* emits trace events that are emitted by
the software execution. Such an STM event is a tuple ``(id,value)``.
There are generally two classed: user-defined and system-generated trace
events.

User-defined trace events are added by the user by instrumenting the
source code with calls to an API like
``TRACE(short id, uint64_t value)``. A debug tool can map the trace
events to a visualization.

Different user threads can emit trace events interleaved. Beside this
the operating system can emit relevant trace information too. For both
reasons, there are system-generated events.

There are two ways to emit a software trace event. First there is a set
of *special purpose registers* or similar techniques used to emit trace
events. Most importantly, each trace event must be emitted atomically.
Secondly, the processor core can have hardware to emit software trace
events. For example a mode change can be emitted without much overhead.

The generic trace interface is ``enable``, ``id`` and ``value`` at the
core level and the STM handles the filtering, aggregation and
packetization as described above.

Debug Processor Module (DPM)
----------------------------

.. figure:: img/debug_module_dpm.*
   :alt: Debug Processor Module
   :name: fig:debug_module_dpm

   Debug Processor Module

As mentioned in the `Introduction <#introduction>`__ we believe in the
importance of on-chip processing of debug information. The chip
interface is the bottleneck in the entire debug infrastructure. But the
developer wants to collect as much trace events as possible to get a
complete picture of the execution. The approach to solve this trade-off
is to process trace events on the chip already. This can be either
filtering or compression as introduced with `Trace
Modules <#trace-modules>`__, but also more complex processing of trace
events to generate processed information out of raw data.

A debug processor module is a subsystem in the debug system that can
receive debug packets, store them and process them to new debug packets
to be sent to the host. As depicted in @fig:debug\_module\_dpm a basic
DPM therefore contain a programmable hardware block (possibly a simple
CPU) and some local memory to execute programs from and store debug
data. A DPM can also send debug packets to configure debug modules and
set itself as destination of packets or configure filters, etc.

This subsystem may be interface from the system itself to configure it.
It may also be part of the actual system, like a core that can be
dynamically dedicated to be a DPM.

Device Emulation Module (DEM)
-----------------------------

It may be desired to deploy I/O modules that do not map to I/O pins, but
instead exchange transactions with the host. This may for example be a
serial terminal that send output characters to the host. Another
important use case for such modules is the emulation of devices on the
host or the simulation of a module during development of it.
