System Interface
----------------

The DEM-UART module provides a generic bus interface, which can be used by wrapper modules to support actual bus interfaces.
We specify a Wishbone wrapper interface below.

+-----------------+-------------+---------------+-------------------------------------------------+
| Signal          | Width (bit) | Direction     | Description                                     |
+=================+=============+===============+=================================================+
| ``bus_req``     | 1           | CPU->DEM      | ``1`` indicates an active request from the CPU  |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``bus_addr``    | 3           | CPU->DEM      | Address to be used with write/read operation    |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``bus_write``   | 1           | CPU->DEM      | ``1`` indicates a register write request        |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``bus_wdata``   | 8           | CPU->DEM      | Data to be written into the register            |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``bus_ack``     | 1           | DEM->CPU      | Acknowledge last request                        |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``bus_rdata``   | 8           | DEM->CPU      | Data that was read from the register            |
+-----------------+-------------+---------------+-------------------------------------------------+

.. figure:: img/bus_write_diagram.*
   :alt: A typical write cycle

.. figure:: img/bus_read_diagram.*
   :alt: A typical read cycle

A new request is made by asserting ``bus_req``, unless ``bus_req`` is asserted, no other signal is valid.
``bus_write`` indicates whether it is a read (0) or a write (1) request.
``bus_addr`` may be any of the values documented under :ref:`uart-registers`.
Finally ``bus_ack`` is asserted to confirm the request and end the cycle.

``bus_req``, ``bus_addr`` and ``bus_write`` are asserted in the same cycle, if it is a write cycle
``bus_wdata`` is also set in the same cycle.
``bus_ack may`` be asserted any number of cycles after ``bus_req`` has been asserted.
``bus_rdata`` is only valid when ``bus_ack`` is asserted and ``bus_write`` is negated.


Wishbone Bus
------------
If a wishbone interface is present, it should wrap around the generic bus described above and take
care of translating all the signals.
The following signals MUST be present on a compatible WISHBONE bus.

+-----------------+-------------+---------------+-------------------------------------------------+
| Signal          | Width (bit) | Direction     | Description                                     |
+=================+=============+===============+=================================================+
| ``wb_adr_i``    | 3           | CPU->DEM      | Address to be used with write/read operation    |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``wb_cyc_i``    | 1           | CPU->DEM      | ``1`` indicates valid bus cycle is in progress  |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``wb_dat_i``    | 32          | CPU->DEM      | Data to be written into the register            |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``wb_sel_i``    | 4           | CPU->DEM      | Bitfield indicating validity of data on dat_i   |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``wb_stb_i``    | 1           | CPU->DEM      | ``1`` indicates that DEM is selected            |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``wb_we_i``     | 8           | CPU->DEM      | ``1`` indicates a write request by the WB-Master|
+-----------------+-------------+---------------+-------------------------------------------------+
| ``wb_ack_o``    | 1           | DEM->CPU      | ``1`` indicates termination of normal bus cycle |
+-----------------+-------------+---------------+-------------------------------------------------+
| ``wb_dat_o``    | 32          | DEM->CPU      | Data that was read from the register            |
+-----------------+-------------+---------------+-------------------------------------------------+

For more information see the `WISHBONE specification <https://cdn.opencores.org/downloads/wbspec_b3.pdf>`_
