Host Authentication Module (HAM)
================================

.. figure:: ../../img/debug_module_ham.*
   :alt: Host Authentication Module
   :name: fig:debug_module_ham

   Host Authentication Module

.. todo::
  This module is not really specified yet.

The system can require the host to authenticate before connecting to the
debug system, because the debug can expose confidential information. A
*HAM* implementation can for example require a token to match or a
sophisticated challenge-response protocol. If configured the
HIM will wait for the HAM to allow the
host to communicate with modules other than the HAM.
