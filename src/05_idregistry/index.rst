.. _sec:idregistry:vendorids:

##########################
Vendor Identifier Registry
##########################

Vendor Identifiers are numbers assigned to an entity building Open SoC Debug components or products/devices and serve as an identifier namespace for that entity.
In combination with another identifier (such as a device identifier or a module identifier) unique identifiers can be created.
Vendor IDs are used in different places in OSD, most notably:

- to describe the type of a debug module (``MOD_VENDOR`` and ``MOD_ID``) and
- to identify the full OSD-enabled device type (``SYSTEM_VENDOR_ID`` and ``SYSTEM_DEVICE_ID``)

The vendor identifier is issued by the Open SoC Debug Project and listed on this page.
Other identifiers are usually assigned independently by the vendor.

To register a new vendor ID please open an issue (or pull request) on GitHub for this document.
No fees or documents are needed.


.. tabularcolumns:: |p{\dimexpr 0.20\linewidth-2\tabcolsep}|p{\dimexpr 0.80\linewidth-2\tabcolsep}|
.. flat-table:: OSD Vendor IDs
  :widths: 2 8
  :header-rows: 1

  * - vendor ID
    - name

  * - 0x0001
    - The Open SoC Debug Project

  * - 0x0002
    - The OpTiMSoC Project

  * - 0x0003
    - LowRISC
