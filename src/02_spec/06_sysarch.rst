*******************
System Architecture
*******************

Implementation Aspects
======================

Overflow Handling
-----------------

.. todo::
  make this a bit less vague and about the future, but about what we have now.

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


Clock and Power Domains
-----------------------
.. todo::
  copy clock and power domain aspects from architecture doc


Physical Interfaces
===================

.. note::
  This version of the Open SoC Debug specification does not describe any physical interface.

.. todo::
  leave this out of the spec!? or put it next to HIM?

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
