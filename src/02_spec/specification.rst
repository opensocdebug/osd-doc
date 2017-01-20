Introduction
============

This document contains the specification of the interfaces and protocols
implemented in the Open SoC Debug infrastructure and modules. Any module
must follow the interfaces and protocols to be compliant with the
standard, except parts that are marked optional.

The basic interfaces are depicted in the following overview picture. The
SoC modules have individual interfaces.

.. figure:: img/interfaces.*
   :alt: Interfaces defined in Open SoC Debug

   Interfaces defined in Open SoC Debug


Hardware Interfaces
===================

Debug Interconnect Interface (DII)
----------------------------------

The *Debug Interconnect Interface (DII)* is the synchronous interface
between the debug interconnect and the debug modules. It is basic
FIFO-like interface with data and handshake signals (master view):

+-------------+----------+---------+--------------------------------------+
| Signal      | Driver   | Width   | Description                          |
+=============+==========+=========+======================================+
| ``data``    | Master   | 16      | Data item                            |
+-------------+----------+---------+--------------------------------------+
| ``valid``   | Master   | 1       | Signals transfer in this cycle       |
+-------------+----------+---------+--------------------------------------+
| ``ready``   | Slave    | 1       | Acknowledge transger in this cycle   |
+-------------+----------+---------+--------------------------------------+
| ``first``   | Master   | 1       | This is the first item of a packet   |
+-------------+----------+---------+--------------------------------------+
| ``last``    | Master   | 1       | This is the last item of a packet    |
+-------------+----------+---------+--------------------------------------+

The following rules and restrictions apply:

-  The ``valid`` signal must not depend on the ``ready`` signal. This
   means you cannot have a combinational dependency of the ``valid``
   signal on the ``ready`` signal in one cycle.

-  A transfer was succesfull iff ``valid`` and ``ready`` were set

-  The ``first`` and ``last`` signals are set so that they signal the
   first and last data item of a packet as described below.

A debug module in the standard case has an input interface and an output
interface, which is denoted a Debug Interface Port (DIP). Only in rare
cases one of them may be omitted.

Debug Packet (DP)
-----------------

A debug packet is defined by the following sequence of successfully
transferred data items (``valid && ready``) on the DII:

+-------------+------------+-----------------------------------------------+
| ``first``   | ``last``   | ``data``                                      |
+=============+============+===============================================+
| ``1``       | ``0``      | ``[15:10]`` reserved, ``[9:0]`` destination   |
+-------------+------------+-----------------------------------------------+
| ``0``       | ``0``      | ``[15:10]`` type, ``[9:0]`` source            |
+-------------+------------+-----------------------------------------------+
| ``0``       | ``0``      | payload                                       |
+-------------+------------+-----------------------------------------------+
| ..          | ..         | ..                                            |
+-------------+------------+-----------------------------------------------+
| ``0``       | ``1``      | payload                                       |
+-------------+------------+-----------------------------------------------+

The reserved bits in the first header are reserved for later use, e.g.,
to support prioritized packets, packet IDs or extended formats. The
debug packet class is part of the debug protocol and payload data is
also defined in the protocol.

In this version there are no length limitations for the packets in the
protocol, but this may change in future revisions.

Debug Transport Datagram (DTD)
------------------------------

The Debug Transport Datagram (DTD) encapsulates the Debug Packet into a
16-bit wide packet with an extra ``length`` field preprended:

+--------+-------------+
| word   | data        |
+========+=============+
| 0      | N           |
+--------+-------------+
| 1      | DP flit 0   |
+--------+-------------+
| 2      | DP flit 1   |
+--------+-------------+
| ..     | ..          |
+--------+-------------+
| N+1    | DP flit N   |
+--------+-------------+

Due to the native width the debug transport datagram is the interface
format from the host or similar.

Debug Packet Types
==================

In this section the different types of debug packets are defined. A
debug packet encodes its type in the upper six bit of the second data
word. The debug packet type are of the following classes:

-  *Register accesses* are the straight-forward read and write
   operations to a debug module. Usually, most operations can be mapped
   to such requests.

-  *Trace Events* are unsolicited events generated by the debug modules.

Register Access
---------------

Register access packets are the standard packets to access a debug
module and a basic set of registers must exist in each module.

``REQ_READ_REG``
~~~~~~~~~~~~~~~~

Reads from a register. The register size is determined by the type field
(see below). The address is always 16-bit wide, addresses 16 bit and
must be aligned to the register size.

+--------+--------------------+
| Word   | Description        |
+========+====================+
| 0      | Register Address   |
+--------+--------------------+

The debug module responds with a ``RESP_READ_REG`` packet.

``REQ_WRITE_REG``
~~~~~~~~~~~~~~~~~

Writes to a register. Identical to the ``REQ_READ_REG`` the register
size is determined by the type field. The address is also 16-bit wide,
addresses 16-bit and must be aligned to the register size.

For 16-bit accesses the request is:

+--------+--------------------+
| Word   | Description        |
+========+====================+
| 0      | Register Address   |
+--------+--------------------+
| 1      | Data               |
+--------+--------------------+

For 32-bit accesses the request is:

+--------+--------------------+
| Word   | Description        |
+========+====================+
| 0      | Register Address   |
+--------+--------------------+
| 1      | Data[31:16]        |
+--------+--------------------+
| 2      | Data[15:0]         |
+--------+--------------------+

For 64-bit access the request is:

+--------+--------------------+
| Word   | Description        |
+========+====================+
| 0      | Register Address   |
+--------+--------------------+
| 1      | Data[63:48]        |
+--------+--------------------+
| 2      | Data[47:32]        |
+--------+--------------------+
| 3      | Data[31:16]        |
+--------+--------------------+
| 4      | Data[15:0]         |
+--------+--------------------+

Accordingly, the 128-bit register request is:

+--------+--------------------+
| Word   | Description        |
+========+====================+
| 0      | Register Address   |
+--------+--------------------+
| 1      | Data[127:112]      |
+--------+--------------------+
| 2      | Data[111:96]       |
+--------+--------------------+
| 3      | Data[95:80]        |
+--------+--------------------+
| 4      | Data[79:64]        |
+--------+--------------------+
| 5      | Data[63:48]        |
+--------+--------------------+
| 6      | Data[47:32]        |
+--------+--------------------+
| 7      | Data[31:16]        |
+--------+--------------------+
| 8      | Data[15:0]         |
+--------+--------------------+

The packet is acknowledged with a ``RESP_WRITE_REG`` packet.

``RESP_READ_REG``
~~~~~~~~~~~~~~~~~

The read response is either an empty response if there was an error. The
error case is indicated by the type field (see below).

Otherwise the data is returned (1 word), for 16-bit reads:

+--------+---------------+
| Word   | Description   |
+========+===============+
| 0      | Data word 0   |
+--------+---------------+

For 32-bit, 64-bit and 128-bit reads the same order as for ``REG_WRITE``
applies.

``RESP_WRITE_REG``
~~~~~~~~~~~~~~~~~~

A write response is always empty, but the type can also indicate an
error.

Trace Events
------------

``DBG_EVENT``
~~~~~~~~~~~~~

A debug event, e.g., a trace, can be of a maximum length defined by the
debug networks maximum packet length. The content is specific to the
module. For events of 3 words or less, the packet is defined as:

+--------+---------------------------------+
| Word   | Description                     |
+========+=================================+
| 0      | Debug Event Word 0              |
+--------+---------------------------------+
| 1      | Debug Event Word 1 (optional)   |
+--------+---------------------------------+
| 2      | Debug Event Word 2 (optional)   |
+--------+---------------------------------+

For larger events the format is:

+--------+---------------------------------------------+
| Word   | Description                                 |
+========+=============================================+
| 0      | ``[15:10]`` reserveed, ``[9:0]`` size (N)   |
+--------+---------------------------------------------+
| 1      | Debug Event Word 0                          |
+--------+---------------------------------------------+
| ..     | ..                                          |
+--------+---------------------------------------------+
| N+1    | Debug Event Word N                          |
+--------+---------------------------------------------+

Debug Packet Overview
---------------------

The following table shows the coding

+----------------------+-------------------------------------------------------------------------+
| Type                 | Coding (six bit)                                                        |
+======================+=========================================================================+
| ``REQ_READ_REG``     | ``[5:2]`` ``0000``, ``[1:0]`` ``regsize``                               |
+----------------------+-------------------------------------------------------------------------+
| ``REQ_WRITE_REG``    | ``[5:2]`` ``0001``, ``[1:0]`` ``regsize``                               |
+----------------------+-------------------------------------------------------------------------+
| ``DBG_EVENT``        | ``[5:4]`` ``10``, ``[3:0]`` ``eventsize``                               |
+----------------------+-------------------------------------------------------------------------+
| ``PLAIN``            | ``[5:4]`` ``01``, ``[3:0]`` ``size``                                    |
+----------------------+-------------------------------------------------------------------------+
| ``RESP_READ_REG``    | ``[5:1]`` ``00000``, ``[0]`` is ``1`` if an error occured, ``0`` else   |
+----------------------+-------------------------------------------------------------------------+
| ``RESP_WRITE_REG``   | ``[5:1]`` ``00001``, ``[0]`` is ``1`` if an error occured, ``0`` else   |
+----------------------+-------------------------------------------------------------------------+

``regsize`` is defined as:

+---------------+--------------------+
| ``regsize``   | Description        |
+===============+====================+
| ``00``        | 16 bit register    |
+---------------+--------------------+
| ``01``        | 32 bit register    |
+---------------+--------------------+
| ``10``        | 64 bit register    |
+---------------+--------------------+
| ``11``        | 128 bit register   |
+---------------+--------------------+

``eventsize`` is defined as:

+-----------------+-----------------------------------------+
| ``eventsize``   | Description                             |
+=================+=========================================+
| ``0000``        | Event length: 1 word                    |
+-----------------+-----------------------------------------+
| ``0001``        | Event length: 2 words                   |
+-----------------+-----------------------------------------+
| ..              | ..                                      |
+-----------------+-----------------------------------------+
| ``1110``        | Event length: 15 words                  |
+-----------------+-----------------------------------------+
| ``1111``        | Event length encoded in packet word 0   |
+-----------------+-----------------------------------------+

Debug Module Registers
======================

Basic Memory Map
----------------

+---------------------------+-----------------------------------+
| Address Range             | Description                       |
+===========================+===================================+
| ``0x0000`` - ``0x01ff``   | Open SoC Debug Status & Control   |
+---------------------------+-----------------------------------+
| ``0x0200`` - ``0xffff``   | Module-specific registers         |
+---------------------------+-----------------------------------+

Open SoC Debug Status & Control
-------------------------------

+--------------+-------------------+--------------+---------------------------------------+
| Address      | Key               | Read/Write   | Description                           |
+==============+===================+==============+=======================================+
| ``0x0000``   | ``MOD_ID``        | R            | Module Identifier                     |
+--------------+-------------------+--------------+---------------------------------------+
| ``0x0001``   | ``MOD_VERSION``   | R            | Version                               |
+--------------+-------------------+--------------+---------------------------------------+
| ``0x0002``   | ``MOD_VENDOR``    | R            | Module Vendor Identifier (optional)   |
+--------------+-------------------+--------------+---------------------------------------+
| ``0x0003``   | ``MOD_CS``        | R/W          | Module status & control               |
+--------------+-------------------+--------------+---------------------------------------+

Module Identifier (``MOD_ID``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The modules are identified with this value. The following format is
used:

+------------+--------------------------------------------------------+
| Bits       | Description                                            |
+============+========================================================+
| ``15``     | ``0`` for standard modules, ``1`` for vendor modules   |
+------------+--------------------------------------------------------+
| ``14:0``   | Module idenifier                                       |
+------------+--------------------------------------------------------+

If bit ``15`` is set, ``MOD_VENDOR`` must contain the vendor identifier.
Otherwise it is a known module from the Open SoC Debug project.

Module Version
~~~~~~~~~~~~~~

+------------+--------------------------+
| Bits       | Description              |
+============+==========================+
| ``15:8``   | Module Version           |
+------------+--------------------------+
| ``7:0``    | Open SoC Debug Version   |
+------------+--------------------------+

The versions are plain numbers that identify the module version and the
implemented Open SoC Debug Protocol version.

Module Vendor Identifier (``MOD_VENDOR``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The module vendor identifier is a 16-bit value. For the first, the
vendor identifiers are manually assigned if necessary.

Module Control & Status (``MOD_CS``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Control interface (write):

+-------------+-------------------------+
| Bits        | Description             |
+=============+=========================+
| ``15:11``   | Control Instruction     |
+-------------+-------------------------+
| ``10:0``    | Instruction Parameter   |
+-------------+-------------------------+

Control Instructions:

+------+--------------+
| Key  | Description  |
+======+==============+
| ``MO | Stall the    |
| D_CS | module so    |
| _STA | that I does  |
| LL`` | not produce  |
|      | any          |
|      | unsolicited  |
|      | output       |
+------+--------------+
| ``MO | Set the      |
| D_CS | destination  |
| _SET | address of   |
| _DES | unsolicited  |
| T``  | events       |
+------+--------------+

Status interface (read): Is not yet defined.
