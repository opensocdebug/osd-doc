# Introduction

With the ever increasing number of open source system-on-chip design,
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

In this article we give an overview of the the Open SoC Debug project
and the different layers and components both on the chip and on the
host the we plan in this project.

The Open Soc Debug project has been established to provide
re-usable building blocks for system-on-chip. It provides a system
designer to integrate the entire debugging infrastructure and use the
standard API to debug the system.

We follow both approaches to debugging:

 * Traditional *run-control debugging* that allows a developer to
   connect to the system and step through the program, inspect
   registers, etc., and

 * Modern *trace debugging* that generates basic trace events from the
   hardware and software execution non-intrusively.

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
module triggering, cross-triggers, on-chip aggregation and filtering,
sophisticated interconnects, just to mention a few of the many ideas
we have.

If you are interested to give input, review our specifications or to
join the Open SoC Debug team, please visit our website:
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

Figure 1 shows an overview of the different components in an Open SoC
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

## Transport Layer

## Debug Modules

# Basic Debug Modules

## Host Interface Module (HIM)

## System Control Module (SCM)

## Core Debug Module (CDM)

## Core Trace Module (CTM)

## Software Trace Module (STM)

## Memory Access Modules (MAM)

## Debug Processor Modules (DPM)

# Host Software
