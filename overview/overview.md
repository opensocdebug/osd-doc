# Introduction

With the ever increasing number of open source system-on-chip designs,
we see a big benefit in a unified system-on-chip debug
infrastructure. On the one hand it is fair to say that developers
usually see debug as a inevitable must that does not add some fancy
new feature or increases performance, hence a toolbox of available
building blocks can easily help them. On the other hand a unified
infrastructure with shared interfaces eases the interoperability of
tools and hardware.

The goal of the Open System-on-Chip Debug (Open SoC Debug, OSD)
infrastructure is therefore to provide a repository of building
blocks, glue infrastructure and host software libraries for SoC
debugging. We therefore aim at supporting support for both run-control
debugging and trace debugging. While run-control debugging is
well-known and often used in the shape of JTAG-based debugging cables,
trace-debugging is the observation of a system-on-chip with trace
events and it gains increasing significance with multicore
system-on-chip due to their parallelism.

Furthermore, it is our philosophy that debugging is much more then
traditional functional debugging to eliminate bugs. Instead a good
trace debug infrastructure helps with performance diagnosis. It should
be possible to find inefficiencies or problems that do not manifest
in a functional, but should be solved.

In this article we give an overview of the the Open SoC Debug project
and the different layers and components both on the chip and on the
host the we plan in this project.

The building blocks share common interfaces and protocols, so that
they are easily composable, but the specifications will always allow
highly optimized versions for a specific setup.

Currently, we target the first release of the base specification and
module specification, that contain the following parts:

 * Basic interfaces and transport protocols

 * A generic and mandatory memory map for all debug modules to allow
   enumeration, capabilities and versioning

 * Basic modules for run-control and trace debugging

This is just the start that covers the very basic functionality, but
more features will be added to the specification over the next months:
tracing to memory instead of host, device traces, module triggering,
cross-triggers, on-chip aggregation and filtering, sophisticated
interconnects, just to mention a few.

If you are interested in giving input, reviewing our specifications or
joining the Open SoC Debug team, please visit our website:
[http://www.opensocdebug.org](http://www.opensocdebug.org)

## License

This work is licensed under the Creative Commons
Attribution-ShareAlike 4.0 International License. To view a copy of
this license, visit
[http://creativecommons.org/licenses/by-sa/4.0/](http://creativecommons.org/licenses/by-sa/4.0/)
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA
94042, USA.

You are free to share and adapt this work for any purpose as long as
you follow the following terms: (i) Attribution: You must give
appropriate credit and indicate if changes were made, (ii) ShareAlike:
If you modify or derive from this work, you must distribute it under
the same license as the original.

#<a name="debug-system-overview"/>Debug System Overview

![Overview of an Open SoC Debug debug system](../images/overview.png
 "Debug System Overview")

The overview figure shows the different components in an Open SoC
Debug-based debug system. The most important components are the debug
modules that monitor or interact with the SoC components via specified
interfaces. A debug network is used to exchange messages between those
modules and the host.

The physical transport is abstracted by a simple FIFO interface on
both sides by using the [*Generic Logic Interface Project
(glip)*](https://www.glip.io).

On the host side the `libopensocdebug` can be used to directly
interact with the debug modules or the `opensocdebugd` daemon can be
used to share a system between multiple debug tools. While we support
anyone who works on debug tools, the development of fancy tools is out
of the scope of this project for now.

##<a name="physical-interface"/>Physical Interface

![Generic Logic Interface Project (glip) as abstraction layer from physical interface](../images/glip.png
 "Debug System Overview")

The physical interface is abstracted in Open SoC Debug. As mentioned
before we build on top of [glip](https://www.glip.io) as depicted in
the Figure. Glip provides a generic FIFO interface that reliably
transfers data between the host and the system. Multiple alternatives
for simulations and prototyping hardware exist. In a silicon device, a
high-speed serial interface is most probably favorable.

##<a name="transport-switching"/>Transport & Switching

To route debug information to the correct debug module and to the
host, we use a simple packet-based protocol. The packet size is
limited by the implementation and can be queried from the *System
Control Module (SCM)*. The minimum value for the maximum packet size
is 8.

For flow control and to mark the start and end of a packet, the *Debug
Interconnect Interface (DII)* is defined therefore. The packet width
must be at least 16 bit and currently is set fixed to 16 bit.

The debug packets contain the necessary routing and identification
information, namely the destination and the source, in their header,
which are the first two data items in a packet.

One key property of the transport & switching in the Open SoC Debug
specification is that it generally allows that debug modules exchange
packets between them. This enables on-chip trace processing,
run-control debugging from a special core or other methods to reduce
the traffic on the host interface, which is the most critical resource
in modern debugging.

![Debug ring and other interconnects](../images/interconnect.png "Debug ring and other interconnects")

In general, the interconnect can have any possible topology as long as
it fulfills two basic properties: strict-ordering of packets with the
same `(src,dest)` tuple and deadlock-freedom. The first property does
forbid debug packets from one source to one destination to overtake
each other in the interconnect to allow paylod data to span multiple
packets. The figure shows the favored topologies. The baseline
implementation is a simple ring interconnect. The ring balances well
between clock speed, required chip area and most importantly
flexibility. It can easily span the entire chip without dominating a
design.

Alternatively, other topologies may be favored. For example a low
count of debug modules favors a multiplexer interconnect. Especially
if the debug modules are all trace debugging or all run-control
debugging a bus or similar can be favorable for low debug module
counts. When the modules also communicate with each other a crossbar
may be used for high throughput, but with the disadvantage of large
area overhead.

Finally, we believe once some first tests with larger systems in the
real world have been performed, hierarchical topologies may become
favorable. Beside optimizing the resource utilization, aggregating
modules may bridge subsets of trace modules to the actual debug
interconnect to perform size optimizations on the aggregated packet
stream.

##<a name="debug-modules"/>Debug Modules

The debug modules either monitor a debug module or interact with it in
case of run-control debugging or special functionalities. On the other
side the debug modules generally interface the debug infrastructure
via the so called "Debug Interconnect Interface" (DII).

![The generic status and control
 interface](../images/debug_module_generic_if.png "Generic status and
 control interface")

All debug modules have a common debug-side status and control
interface as depicted in the figure. It is a base register map that
contains mandatory and optional registers such as:

 * The *module class* and a module *vendor id* and *product id*, that
   support enumeration and software handling of the debug modules on
   the host

 * Enable and disable the entire module

 * Query module-specific capabilities and enable features

This interface usually runs in the debug system clock domain, while
the actual module logic is responsible for clock domain crossing
between the connected system component and the debug clock
domain. Most simply, tracing is usually done by (naturally) sampling
the trace information in the component's domain and cross the trace
event via a small buffer into the module logic that handles
packetization of the trace event.

###<a name="register-access"/>Register Access

The host sends register access packets to the debug modules to

 * read and write control & status registers, or

 * access a debug module functionality

For example, the host can send a `REQ_READ_REG` packet to read module
version from the defined memory address `MOD_VERSION (0x1)`. The
module will reply with a `RESP_READ_REG` containing the module
version.

It is generally allowed that debug modules can also generate such
request to query or control other debug modules.

![The convenience MMIO bridge wrapper](../images/debug_module_mmiobridge.png
 "The convenience MMIO bridge wrapper")

There is a convenience wrapper that maps the register access debug
packets to memory-mapped bus interface. As depicted in the figure this
module is especially useful for host-controlled modules, such as
run-control debugging.

The basic bus interface allows for register addresses. The data width
is configurable, for example as a processor's data width. The memory
adresses are register numbers, so that is is not possible to address
unaligned to the configured data width.

Finally, there is an `interrupt` signal that can be used to send
unsolicited events to the host, for example a `breakpoint` event. The
bridge is configured to read a value from a configured address and
send it to the host. Thereby it is possible to implement run-control
debugging without polling for events.

###<a name="debug-events"/>Debug Events

Debug events are unsolicited messages generated from a debug
module. This can for examle be a "breakpoint hit" message from a
run-control debug module, or a trace message. In the first case the
host usually starts with a sequence of register accesses, while in
general debug events are of a fire-and-forget nature.

###<a name="trace-modules"/>Trace Modules

![Generic trace module structure](../images/generic_trace_module.png
 "Generic trace module structure")

Trace modules have an overall structure as depicted in the
figure. Their task is to sample trace events generated by the
hardware. This trace events can be of arbitrary sizes, but are usually
constant at a single trace module's sampling interface. Examples are:

 * A processor core's execution trace: Executed program counter,
   branch-taken or similar
 
 * A processor core's diagnosis trace: Functional unit utilization,
   branch predictor efficiency, etc.

 * Cache diagnosis trace: Hits/Misses, Conflicts, average memory
   access time, etc.
 
 * DMA controller trace: Start and end of request, average memory
   latency
 
Summarizing, nearly every hardware block is a candidate to generate
useful trace information.

###<a name="clock-domains"/>Clock Domains

The base functionality of a trace module is packetization of the trace
data to trace event packets. Optionally, the module may filter events
or compress the event stream. At some point it is necessary to cross
between the module's clock domain and the debug clock domain. This can
alternatively be done on the trace event sampling, at the packet
output or somewhere in between, depending on which clock is faster and
at which rates trace events are generated.

###<a name="overflow-handling"/>Overflow Handling

In case the trace events are generated at a faster rate than the host
interface can transfer. This problem becomes crucial with the
increasing number of trace modules. Generally, this can be done on the
level of the debug system by a sophisticated flow control that will be
specified in later revisions. An overflow occurs if a trace event is
generated, but cannot be transferred or buffered due to backpressure
from the interconnect, but backpressure cannot be generated to the
system module. In the current specification the trace infrastructure
detects this situation, counts how many packets could not be
transfered and then transfers a `missed_events` event once it the
interface is available again.

#<a name="basic-debug-modules"/>Basic Debug Modules

In the following we will shortly introduce the core group of debug
modules which will be part of Open SoC Debug. Only two modules are
mandatory: The *Host Interface Module* to transfer data between the
debug system and the host or memory, and the *System Control Module*
that identifies the system, provides system details and controls the
system.

##<a name="host-interface-module-him"/>Host Interface Module (HIM)

![Host Interface Module](../images/debug_module_him.png "Host
 Interface Module")

The *Host Interface Module (HIM)* converts the debug packets to a
`length`-`value` encoded data stream, that is transferred using the
glip interconnect. This format is simple and contains the length of
the debug packet in one data item followed by the debug packet.

Alternatively, the HIM can be configured to store the debug packets to
the system memory using the memory interface.

##<a name="host-authentication-module-ham"/>Host Authentication Module (HAM)

![Host Authentication Module](../images/debug_module_ham.png "Host
 Authentication Module")

The system can require the host to authenticate before connecting to
the debug system, because the debug can expose confidential
information. A *HAM* implementation can for example require a token to
match or a sophisticated challenge-response protocol. If configured
the [HIM](#host-interface-module-him) will wait for the HAM to allow
the host to communicate with modules other than the HAM.

##<a name="system-control-module-scm"/>System Control Module (SCM)

![System Control Module](../images/debug_module_scm.png "System
 Control Module")

The *System Control Module (SCM)* is always mapped to address `1` on
the debug interconnect (`0` is the host/HIM address). The host first
queries the SCM to provide system information, like a system
identifier, the number of debug modules, or the maximum packet length.

Beside that it can be used to control the system. For that it can set
the soft reset of the processor cores and the peripherals separately
in the first specification.

##<a name="core-debug-module-cdm"/>Core Debug Module (CDM)

![Core Debug Module](../images/debug_module_cdm.png "Core Debug
 Module")

The core debug module implements run-control debugging for a processor
core. The implementation is to a certain degree core-dependent, but a
generic implementation is sketched in the figure. It has a memory
mapped interface as described above. The debug control, status
information and core register are mapped in memory regions. The
run-control debugger (e.g., gdb) then sends register access
requests. In case of a debug event (breakpoint hit) `interrupt`
signals are asserted. As a reaction the CDM reads a defined address
and the core-specific part of the CDM generates a debug event.

Of course, other implementations are possible or may be required
depending on the interface processor implementation.

##<a name="core-trace-module-ctm"/>Core Trace Module (CTM)

The *Core Trace Module (CTM)* captures trace events generated from the
processor core. The implementation is core-dependent and will be
highly configurable. Such trace events are core-internal signals, like
the completion of an instruction, the branch predictor status, memory
access delays, cache miss rates, just to name a few possibilities.

The CTM specification will define a few basic trace events and how
they can efficiently packed, because such events are usually generated
with a high rate.

##<a name="software-trace-module-stm"/>Software Trace Module (STM)

The *Software Trace Module (STM)* emits trace events that are emitted
by the software execution. Such an STM event is a tuple
`(id,value)`. There are generally two classed: user-defined and
system-generated trace events.

User-defined trace events are added by the user by instrumenting the
source code with calls to an API like `TRACE(short id, uint64_t
value)`. A debug tool can map the trace events to a visualization.

Different user threads can emit trace events interleaved. Beside this
the operating system can emit relevant trace information too. For both
reasons, there are system-generated events.

There are two ways to emit a software trace event. First there is a
set of *special pupose registers* or similar techniques used to emit
trace events. Most importantly, each trace event must be emitted
atomically. Secondly, the processor core can have hardware to emit
software trace events. For example a mode change can be emitted
without much overhead.

The generic trace interface is `enable`, `id` and `value` at the core
level and the STM handles the filtering, aggregation and packetization
as described above.

##<a name="memory-access-module-mam"/>Memory Access Module (MAM)

![Memory Access Module](../images/debug_module_mam.png "Memory Access
 Module")

The *Memory Access module (MAM)* is used to write data to the memory
or read data back from the memory. This module can therefore be used
to inititalize the memory with a program or inspect the memory
post-mortem or during run-control debugging.

The module is either connected to the system memory, other memory
blocks or the last level cache. In the presence of write-back caches
the memory access may be required to be guarded by a run-control
triggered forced writeback if necessary.

##<a name="debug-processor-modules-dpm"/>Debug Processor Module (DPM)

#<a name="host-software"/>Host Software
