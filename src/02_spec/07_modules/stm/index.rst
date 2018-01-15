Software Trace Module (STM)
===========================

The *Software Trace Module (STM)* emits trace events that are emitted by
the software execution. Such an STM event is a tuple ``(id,value)``.
There are generally two classed: user-defined and system-generated trace
events.

User-defined trace events are added by the user by instrumenting the
source code with calls to an API like
``TRACE(short id, uint64_t value)``. A debug tool can map the trace
events to a visualization.

Different user threads can emit trace events interleaved. Beside this
the operating system can emit relevant trace information too. For both
reasons, there are system-generated events.

There are two ways to emit a software trace event. First there is a set
of *special purpose registers* or similar techniques used to emit trace
events. Most importantly, each trace event must be emitted atomically.
Secondly, the processor core can have hardware to emit software trace
events. For example a mode change can be emitted without much overhead.

The generic trace interface is ``enable``, ``id`` and ``value`` at the
core level and the STM handles the filtering, aggregation and
packetization as described above.


.. toctree::
   :maxdepth: 1

   systemif
   dbgregisters
   datainterface
   eventdesc
