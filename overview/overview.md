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

# Debug System Overview

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

## Physical Interface

![Generic Logic Interface Project (glip) as abstraction layer from physical interface](../images/glip.png
 "Debug System Overview")

The physical interface is abstracted in Open SoC Debug. As mentioned
before we build on top of [glip](https://www.glip.io) as depicted in
the Figure. Glip provides a generic FIFO interface that reliably
transfers data between the host and the system. Multiple alternatives
for simulations and prototyping hardware exist. In a silicon device, a
high-speed serial interface is most probably favorable.

## Transport & Switching

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

## Debug Modules

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

### Register Access

The host sends register access packets to the debug modules to

 * read and write control & status registers, or

 * access a debug module functionality

For example, the host can send a `REQ_READ_REG` packet to read module
version from the defined memory address `MOD_VERSION (0x1)`. The
module will reply with a `RESP_READ_REG` containing the module
version.

It is generally allowed that debug modules can also generate such
request to query or control other debug modules.

### Debug Events

Debug events are unsolicited messages generated from a debug
module. This can for examle be a "breakpoint hit" message from a
run-control debug module, or a trace message. In the first case the
host usually starts with a sequence of register accesses, while in
general debug events are of a fire-and-forget nature.

### Trace Modules

![Generic trace module structure](../images/generic_trace_module.png
 "Generic trace module structure")

TODO: Other clock domain schemes

Trace modules have an overall structure as depicted in the
Figure. Their task is to sample trace events generated by the
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

The base functionality of a trace module is packetization of the trace
data to trace event packets. Optionally, the module may filter events
or compress the event stream.

# Basic Debug Modules

## Host Interface Module (HIM)

## System Control Module (SCM)

One per system

## Core Debug Module (CDM)

## Core Trace Module (CTM)

## Software Trace Module (STM)

## Memory Access Modules (MAM)

## Debug Processor Modules (DPM)

# Host Software
