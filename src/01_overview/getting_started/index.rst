*********************
Open SoC Debug Primer
*********************

About Open SoC Debug
====================

Systems-on-Chip (SoCs) have become embedded deeply into our lives. Most
of the time we enjoy the way they serve their purpose without getting in
the way. Until they don't. In those moments, we as engineers are
reminded of the complex interplay between software and hardware in SoCs.
We might pose questions like "How does my software execute on the chip?"
or "Why is it showing this exact behavior?" To answer these questions we
need insight into the system that executes the software. We gain this
insight through the debug infrastructure integrated into the SoC.

Even though debug infrastructure is an essential part of any SoC design,
most people consider creating it more of a necessary chore than an
exciting endeavor. Therefore, most vendors today include debug
infrastructure that follows one of two major specifications: `ARM
CoreSight <http://www.arm.com/products/system-ip/debug-trace/>`__ and
`NEXUS 5001 <http://nexus5001.org/>`__ (officially called "IEEE-ISTO
5001"). Unfortunately, none of these specifications are fully open, they
cannot be used without any money involved.

The Open SoC Debug (OSD) specification was created to close this gap.
Three key messages guide its design.

-  **OSD is a truly open (source) specification.** Without any committee
   membership required or royalty fees to be payed, anyone can freely

   -  share and modify the specification itself, and
   -  create and distribute implementations of the specification for any
      purpose.

-  **OSD is for debugging and tracing.** A debugging infrastructure by
   itself is not a solution, but a toolbox providing the right tool for
   the task. Some bugs are best hunted using run-control debugging, some
   are better found using tracing. OSD supports both, enabling hardware
   and software developers to pick what's best for their needs.
-  **OSD provides the common and enables the special.** SoCs came to
   live because they allow reuse of components and specialization at the
   same time, letting hardware designers focus on the unique challenges
   without re-inventing the wheel. OSD follows this lead. Common IP
   blocks, interfaces and software tools can be re-used, and multiple
   extension vectors allow for easy customization where necessary.

Scope
-----

By implementing Open SoC Debug, a SoC gains the following features (to a
varying and implementation-defined degree).

-  Support for run-control debugging, i.e. setting breakpoints and
   watchpoints and reading register values. In short, all you need to
   attach a debugger like GDB to the SoC.
-  Support for tracing, i.e. non-intrusively observing the program
   execution on the SoC.
-  Support for remotely controlling the SoC during development, e.g.
   starting the CPUs, resetting the system, and reading and writing the
   memories.

To provide these features, this specification defines

-  an extensible debug system architecture, covering both hardware and
   host software,
-  templates with well-defined interfaces for debug and trace IP blocks
   ("debug modules"),
-  a set of common debug modules for the most frequent run-control debug
   and tracing tasks,
-  a host-side software programming interface (API) for debug tools to
   interact with an OSD-enabled debug system.

In addition, implementations of many components described in the OSD
specification are made available under a permissive open source license
which can be used directly in custom designs.

Current Status
--------------

OSD is an evolving effort. Currently, we target the first release of the
base specification and module specification, that contain the following
parts:

-  Basic interfaces and transport protocols
-  A generic and mandatory memory map for all debug modules to allow
   enumeration, capabilities and versioning
-  Basic modules for run-control and trace debugging

This is just the start that covers the very basic functionality, but
more features are planned to be added to the specification in the near
future: tracing to memory instead of host, device traces, module
triggering, cross-triggers, on-chip aggregation and filtering,
sophisticated interconnects, just to mention a few.

About This Document
===================

This document gives an overview of Open SoC Debug. The goal is to
provide interested designers SoC hardware components as well as
developers of debugging software tools a good understanding of the
overall picture and the reasoning behind the design of OSD. This
document is not the specification itself. Please refer to the individual
sub-documents for the exact wording of the specification.


High-Level Features
===================

By implementing OSD, a SoC can easily be enhanced with advanced debug
functionality. This section describes these features in more detail.

Run-Control Debug
-----------------

Run-control debugging, a.k.a. breakpoint debugging, "stop-and-stare"
debugging, or just "debugging," is the most common way of finding
problems in software at early stages of development. Using software
tools like the GNU Debugger (gdb) breakpoints can be set in the software
code. If this point in the program reached, the program execution is
stalled and the program control is handed over to the debugger. Using
the debugger, a developer can now read register or memory values, print
stack traces, and much more. To be efficient, run-control debugging
functionality needs hardware support to stop the program execution at a
given time. In addition, run-control debugging on SoC platforms is
usually done remotely, i.e. the system is controlled from a host PC, as
opposed to running the debugger directly on the SoC.

OSD contains all parts to add run-control debug support to a SoC. On the
hardware side, OSD interfaces with the CPU core(s) to control its
behavior. On the host side, OSD provides a daemon that GDB can connect
to. The actual debugging is then handled by GDB and the usage of OSD is
transparent to the software developer.

Tracing
-------

Today's heterogeneous multi-core designs present new challenges to
software developers. Concurrent software distributed across multiple
CPUs and hardware accelerators, interacting with complex I/O interfaces
and strict real-time requirements is the new normal. This results in new
classes of bugs which are hard to find, like race conditions, deadlocks,
and severely degraded performance for no obvious reason. To find such
bugs, run-control debugging is not applicable: setting a breakpoint
disturbs the temporal relationship between the different threads of
execution. This disturbance to the program execution is called "probe
effect" and can cause the original problem to disappear when searching
for it, a phenomenon known as "Heisenbug."

Tracing avoids these problems by unobtrusively monitoring the program
execution and transferring the observations off-chip. There, the program
flow can be reconstructed and the program behavior analyzed.

OSD comes with components to enable tracing for not only CPU cores, but
also for any component in the SoC, such as memories, hardware
accelerators, and interconnects.

Memory Access
-------------

Reading and writing memories is an essential tool during bring-up and
debugging of a SoC. A typical use case is to write software to a program
memory from the host PC, to avoid writing it for example to a SD card or
flash memory and then resetting the system.

OSD ships with a module that can be attached to a memory to support
reads and writes from and to memories.

System Discovery
----------------

Users of today's debug systems know the pain: setting up a debugger on a
host PC to communicate with the hardware often requires obscure
configuration settings, secret switches and a bit of magic sauce to make
it all work.

OSD is designed to be plug-and-play. All hardware components are
self-describing. When a host connects to the system, it first enumerates
all available components, and reads necessary configuration bits.

Timestamping
------------

Timestamps are monotonically increasing numbers which are attached to
events generated by the debug system. (They usually do not correspond in
any way to wall-clock time.) Timestamps enable correlation of events in
different parts of the chip with each other. Additionally, they can be
used to restore order to events which are (for some reason) out of order
when they arrive.

While timestamps are useful in many cases, adding them to all events
generated by the debug system can significantly increase the overhead of
such events.

Currently OSD supports timestamps which are full numbers of configurable
width. Some debug modules can be configured to enable or disable
timestamp generation.

The timestamping method used in OSD is referred to as "source
timestamps" in some debug systems. Timestamps are added to the trace
data at the source, as opposed to (e.g.) adding timestamps when the data
is received by a debug adapter hardware between the SoC and the host PC.

Security and Authentication
---------------------------

Any debug system, by nature, exposes much of the system internals to the
outside world. To prevent abuse of the debug system, production devices
often require a developer to authenticate towards the system before
being able to use the debug system.

OSD provides the infrastructure to implement such features.



OSD By Example
==============

Before we dive into the details of the OSD architecture, this section
discusses two typical usage examples of OSD. The first example only
shows run-control debugging, the second one presents a full tracing
infrastructure.

OSD for Run-Control Debugging
-----------------------------

Many smaller single-core designs traditionally only support run-control
debugging through custom JTAG-based debug infrastructure. OSD supports
this use case well. Its modular architecture makes it easy to implement
only essential debug modules to support run-control debug, and to add
advanced features such as trace later without major changes.

.. figure:: img/overview_example_debug.*
   :alt: An example system using OSD for run-control debugging
   :name: fig:overview_example_debug

   An example system using OSD for run-control debugging

:numref:`Figure %s <fig:overview_example_debug>`
shows an example configuration of OSD for
a small run-control debug scenario. The functional system (to be
attached on the right side) consists of a single-core CPU, a memory and
a bus interconnect. To this functional system the debug modules are
attached.

-  The Subnet Control Module (SCM) module allows to control the system
   remotely: reset the system, halt the system, reset the CPUs, etc.
-  The Core Debug Module (CDM) provides all functionality expected from
   a run-control debug system: setting breakpoints and reading CPU
   registers.
-  The Memory Access Module (MAM) gives access to the chip's memories
   for loading the memories during debugging (e.g. with the program
   code), to verify the memory contents, or to read out memory contents
   during debugging.
-  To show the benefits of using OSD, the example system adds another
   module, the Device Emulation Module UART (DEM-UART). This module
   behaves on the functional hardware side, and on the software side
   like a usual UART device. But instead of using dedicated pins, the
   data is transported through the debug connection.

For all mentioned components, OSD includes a full specifications which
enables a custom implementation, as well as a hardware implementation
that can be used unmodified or adapted to fit the interface to the
custom functional system.

The debug modules are all connected to a debug network. The OSD
specification does not require a specific network topology or
implementation type. However, usually OSD implementations use a 16-bit
wide, unidirectional ring network on chip (NoC), as it presents a good
trade-off between area usage and performance.

To connect with a host PC, three further components are needed: the Host
Interface Module (HIM) on the hardware side, a GLIP transport module,
and a software daemon on the host side.

The transport of data between host and device is handled by
`GLIP <http://glip.io>`__. GLIP is a library which abstracts the data
transport between hardware and software with a bi-directional FIFO
interface. The data transport itself can happen through different
physical interfaces, such as UART, JTAG, USB or PCI Express (PCIe). In
the presented example, a JTAG connection is used. A possibly existing
JTAG boundary scan interface can be re-used and a new Test Access Point
(TAP) is added to the JTAG chain for the debug connection.

The Host Interface Module (HIM) connects the debug network to the
FIFO-interface of GLIP.

On the software side, the OSD host daemon encapsulates the communication
to the device and provides a API for various tools communicating with
the debug system. A scriptable command line interface can be used to
control the system (such as reset, halt, etc.) and to read and write
memories. A gdb server provides an interface to the core debug
functionality that the GNU Debugger (gdb) can connect to. In the end,
software can be debugged with an unmodified gdb (and other gdb-enabled
IDEs, such as Eclipse CDT).

OSD for Tracing
---------------

Today's debug system architectures strictly separate between run-control
debugging and tracing. The example below shows how OSD units the two
worlds with a common interface, thus reducing development and
maintainance effort. Since most of the architecture is shared between
run-control debugging and tracing, upgrading an existing design from
run-control debugging to tracing is not a large step.

.. figure:: img/overview_example_trace.*
   :alt: An example system dual-core system using OSD tracing
   :name: fig:overview_example_trace

   An example system dual-core system using OSD tracing

:numref:`Figure %s <fig:overview_example_trace>` shows an example architecture of a OSD
system with tracing support for a dual-core design. Most of the
architecture is identical to the previous example: the host daemon, the
HIM, the debug network and the SCM, CDM and MAM debug modules. New in
this example are the following parts.

-  The GLIP transport library now uses USB 2.0 instead of JTAG for
   communication. This allows for higher off-chip transfer speeds to get
   improved visibility into the system by tracing.
-  The Core Trace Module (CTM) provides program trace (a.k.a.
   instruction trace) support. It is attached to the CPU core next to
   the CDM.
-  A graphical trace viewer can be attached to the host daemon to view
   the traces. Currently, OSD does not come with such a tool, but all
   interfaces are provided to easily write such a tool.

The two examples in this section have already shed a light on what is
possible with OSD. In the remainder of this document, we'll discuss OSD
in more depth, starting with a more general overview of the
architecture.
