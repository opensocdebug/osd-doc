*******
Preface
*******

About this specification
========================
This specification describes Open SoC Debug (OSD), an extensible infrastructure adding debug and trace support to a System-on-Chip.

Target audience
----------------
This specification targets all people involved in the design and implementation of software or hardware products using Open SoC Debug.
Explicitly, this specification targets

- Hardware designers integrating Open SoC Debug in their System-on-Chip designs.
- Hardware designers extending Open SoC Debug, for example by writing own OSD modules.
- Software developers writing software tools interacting with an OSD-enabled SoC.


Conventions
===========

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be interpreted as described in :RFC:`2119`.

Unless noted otherwise, numbers are written in decimal (base 10) representation.
Hexadecimal numbers (base 16) are prefixed with "0x", binary numbers (base 2) are prefixed with "0b".

Bit fields given in the form MSB:LSB, as commonly used in Verilog and VHDL.
Both MSB and LSB are included in the range.

Ranges are given as UPPER BOUND .. LOWER BOUND.
Both bounds are included in the range.

Terms
=====

- **Target**. The component which is being observed through Open SoC Debug. Usually, this is a physical chip (e.g. an ASIC or an FPGA).

- **Host**. The component which observes the target. Typically, this is a regular PC, but it the same functionality could also be performed by a special-purpose hardware unit.

- **Conforming implementation**. A implementation of the Open SoC Debug specification which includes all required functionality as defined in this specification.
