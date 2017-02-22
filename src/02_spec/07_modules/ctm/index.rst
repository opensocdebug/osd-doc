Core Trace Module (CTM)
=======================

The *Core Trace Module (CTM)* captures trace events generated from the
processor core. The implementation is core-dependent and will be highly
configurable. Such trace events are core-internal signals, like the
completion of an instruction, the branch predictor status, memory access
delays, cache miss rates, just to name a few possibilities.

The CTM specification will define a few basic trace events and how they
can efficiently packed, because such events are usually generated with a
high rate.

.. todo::
  Not really specified yet.
