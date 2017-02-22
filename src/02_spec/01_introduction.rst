************
Introduction
************

To develop, debug and improve software running on Systems-on-Chip (SoC), developers need access to the SoC's internal structures.
Developers need to observe the program execution to understand how the software is executed, and they need control over the software execution from a remote system.
The Open SoC Debug (OSD) is an extensible, modular specification which enhances SoCs with such debug and tracing functionality.

The functionality of Open SoC Debug can be placed in three groups:

- Run-Control debug functionality.
  The software execution on the SoC is temporarily suspended and control over the execution flow is handed over to a software tool, the "debugger."

- Tracing functionality. The software execution is observed and the resulting observations are transferred out of the chip, but the execution is not halted or otherwise modified.

- Internal system access. During the process of software development, fast and hassle-free access to the SoC is required. For example, the program code can be written into the RAM directly, instead of loading it from persistent storage, such as flash memory.

Open SoC Debug is a modular and extensible specification, acknowledging the fact that every SoC and every target market has its different design goals and thus requires different trade-offs.

This document, the Open SoC Debug specification, contains both required and optional parts.
The required parts MUST be implemented by any conforming implementation of Open SoC Debug, the optional parts MAY be implemented.

In addition to this specification, the Open SoC Debug Contributors have also developed a reference implementation of many components described in this specification.
It is provided as a starting point for own developments.
However, independent implementations following this specification are encouraged.
