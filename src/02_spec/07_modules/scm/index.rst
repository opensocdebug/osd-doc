Subnet Control Module (SCM)
===========================

.. figure:: ../../img/debug_module_scm.*
   :alt: Subnet Control Module
   :name: fig:debug_module_scm

   Subnet Control Module

The *Subnet Control Module (SCM)* is always mapped to the local address 0 in a subnet of the DI.
The SCM provides an description of the subnet (such as its vendor or the number of debug modules available in the subnet).
In addition, the SCM can be used to control the whole subnet, like resetting and starting or stopping its CPUs.

.. toctree::
   :maxdepth: 1

   dbgregisters
