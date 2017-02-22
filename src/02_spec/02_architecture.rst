***************************
Open SoC Debug Architecture
***************************

Architecture Overview
=====================

In Open SoC Debug, software and hardware components form together an extensible architecture.

.. figure:: img/overview.*
   :alt: Open SoC Debug architecture overview
   :name: fig:spec:architecture:overview

   High-level overview of the Open SoC Debug architecture.

:numref:`Figure %s <fig:spec:architecture:overview>` shows the different components in a typical Open SoC Debug-based debug system.

- **Debug modules** (shown on the right) monitor or interact with the functional components of the SoC.
  Towards the functional SoC the interface is implementation-specific.
  Towards the debug interconnect the modules conform to a standardized interface, which is specified in this document.
  Also included in this specification is a description of common debug modules, some of which are must be implemented by any conforming implementation, others which are optional.
  Debug modules are self-describing and discoverable from the target at runtime through a standardized programmer interface, which is also described in this specification.
  All debug modules are given an address, which is used in all communication with the module.
- The **debug interconnect** is used to exchange data between debug modules, and between the target and the host.
  The format of the data transmitted over the debug interconnect (the Debug Packets, DP), as well as the interface between debug modules and the debug interconnect (the Debug Interconnect Interface, DII) are specified in this document.
- The **physical transport** connects the target to the host.
  The OSD specification does not cover the physical transport.
  However, an example implementation is given as part of the reference implementation.
- **Host software** implements the low-level interface to connect and interact with an OSD-enabled system.
  While the OSD project has created a reference implementation for the host software, its usage is not mandatory and it is not part of this specification.
- Finally, **debug tools** use the debug system to perform debugging and analysis tasks, ranging from run-control debugging to tracing and runtime verification.
  Debug tools can be implemented on top of Open SoC Debug, but are not part of this specification.

The OSD specification is designed with extensibility in mind.
Well-defined extension vectors can be used to customize the behavior of OSD and adapt OSD to different target systems.
If little or no customization is required, the reference implementation can serve as a good starting point to reduce engineering cost.
