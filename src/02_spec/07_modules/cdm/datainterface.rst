Programmer Interface: Data
--------------------------

The CDM-OR1K module generates only one type of event packets: **CPU debug stall packets**. 
These packets contain the data in the form of ``reason`` payload word.

CPU Debug Stall packet
^^^^^^^^^^^^^^^^^^^^^^

A CPU Debug Stall Packet encapsulates a breakpoint or watchpoint event. 
Whenever the program counter in the CPU core matches with the watchpoint/breakpoint address, CPU is stalled and this event packet is generated. 
It notifies the debugger, i.e. GDB about a breakpoint or watchpoint hit.  

The following fields in the header of the DI packet are set:

- ``FLAGS.TYPE`` is set to ``EVENT``
- ``FLAGS.TYPE_SUB`` is set to 0


.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.80\linewidth-2\tabcolsep}|
.. flat-table:: CPU Debug Stall Packet Structure
  :widths: 2 8
  :header-rows: 1

  * - payload word
    - description

  * - 0
    - ``reason``
   
      Indicates the cause of the event generation.
      It can be a breakpoint or watchpoint hit.
      Bits 16-15 indicates the state of the event generation.
      '10' indicates watchpoint hit and '11' indicates breakpoint hit.
      
      
       
		      
	         

