**********************
Component Architecture
**********************

Debug Interconnect
==================


.. todo::
  A specification for two debug interconnects, one for control and one for tracing is still missing.

To route debug information to the correct debug module and to the host, OSD uses a simple packet-based protocol.
All data exchanged on the Debug Interconnect is formatted as Debug Packet.
The *Debug Interconnect Interface (DII)* defines the the hardware interface and the flow control mechanism for hardware modules interacting with the Debug Interconnect.

One key property of the transport & switching in the Open SoC Debug specification is that it generally allows that debug modules exchange packets between them.
This enables on-chip trace processing, run-control debugging from a special core or other methods to reduce the traffic on the host interface, which is the most critical resource in modern debugging.

The Debug Interconnect is only loosely specified to allow implementors to choose an interconnect implementation suitable for their target system.

General Requirements
--------------------

In general, the interconnect implementation is not specified in this document, as long as it fulfills two basic properties:
- It provides strict ordering of packets with the same (source, destination) tuple. This property forbid debug packets from one source to one destination to overtake each other in the interconnect, which is useful to allow payload data to span multiple packets.
- It is free of deadlocks.


Topology
--------

Implementors MAY choose any interconnect topology.
:numref:`Figure %s <fig:spec:components:interconnect>` shows favored topologies.
The baseline implementation is a simple ring interconnect. The ring balances well between clock speed, required chip area and most importantly flexibility. It can easily span the entire chip without dominating a design.

.. figure:: img/interconnect.*
   :alt: Debug ring and other interconnects
   :name: fig:spec:components:interconnect

   Debug ring and other interconnects

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


Debug Interconnect Interface (DII)
----------------------------------

The *Debug Interconnect Interface (DII)* is the synchronous interface between the Debug Interconnect (DI) and the debug modules.
It is used to transfer Debug Packets.

The DII is a FIFO-like interface with data and handshake signals.
All debug components must conform to the DII when accessing the Debug Interconnect.

.. flat-table:: Debug Interconnect Interface description (master view)
  :widths: 2 4 4 10
  :header-rows: 1

  * - signal name
    - driver
    - width (bit)
    - description

  * - ``data``
    - master
    - 16
    - a word of data of the debug packet

  * - ``last``
    - master
    - 1
    - Set to 0b1 by the master to indicate that ``data`` is the last word in a Debug Packet. Set to 0b0 otherwise.

  * - ``valid``
    - master
    - 1
    - set to 0b1 by the master to indicate that ``data`` is valid and should be transferred

  * - ``ready``
    - slave
    - 1
    - set to 0b1 by the slave to acknowledge the transfer

The following rules and restrictions apply:

-  The ``valid`` signal must not depend on the ``ready`` signal. This
   means you cannot have a combinational dependency of the ``valid``
   signal on the ``ready`` signal in one cycle.

-  A transfer was succesfull iff ``valid`` and ``ready`` were set.

-  The ``last`` signal indicates that ``data`` is the last word in a Debug Packet.


Debug Modules
=============

Most functionality in Open SoC Debug is implemented as debug module.
A debug module is connected to the Debug Interconnect on the one side, and usually to a component in the functional system on the other side (such as a CPU or a memory).
The task of a debug module to collect data from or to interact with the functional system.

Debug modules MUST provide one Debug Interconnect Interface, and MUST implement the required parts of the Programmer API, especially the :ref:`sec:spec:api:base_register_map`.
