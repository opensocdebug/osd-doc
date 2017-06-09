System Control Module (SCM)
===========================

.. figure:: ../../img/debug_module_scm.*
   :alt: System Control Module
   :name: fig:debug_module_scm

   System Control Module

The *System Control Module (SCM)* is always mapped to address ``1`` on
the debug interconnect (``0`` is the host/HIM address). The host first
queries the SCM to provide system information, like a system identifier,
the number of debug modules, or the maximum packet length.
Beside that it can be used to control the system.

.. toctree::
   :maxdepth: 1

   dbgregisters
