hs-smbus
========

Haskell bindings to the Linux kernel
[i2c dev interface](https://www.kernel.org/doc/Documentation/i2c/dev-interface)
exposed in `<linux/i2c-dev.h>`


Example:
--------

    import System.IO.SMBus

    dev = Device 0x50
    main = withSMBus 0 $ \bus -> do
      write_byte_data bus dev '\x00' '\x05'
      val <- read_byte_data bus eeprom '\x00'
      print val

