{-# LANGUAGE ForeignFunctionInterface #-}
module System.IO.SMBus.Internal (
    c_open
  , c_close
  , c_set_address
  , c_read
  , c_write
  , c_read_byte
  , c_write_byte
  , c_read_byte_data
  , c_write_byte_data
) where

import Foreign.C.Types
import Foreign.C.String

foreign import ccall unsafe "HsSMBus.h system_smbus_open"
    c_open :: CInt       -- ^ Bus number
           -> IO CInt    -- ^ A file descriptor, < 0 if error and errno set

foreign import ccall unsafe "HsSMBus.h system_smbus_close"
    c_close :: CInt       -- ^ file descriptor
            -> IO CInt    -- ^ returns 0 on success, -1 if error and errno is set

foreign import ccall unsafe "HsSMBus.h system_smbus_set_address"
    c_set_address :: CInt       -- ^ file descriptor
                  -> CInt       -- ^ Device address
                  -> IO CInt    -- ^ returns 0 on success, -1 if error and errno is set

foreign import ccall unsafe "HsSMBus.h system_smbus_read"
    c_read :: CInt       -- ^ file descriptor
           -> CString    -- ^ Buffer to read into
           -> CInt       -- ^ Number of bytes to read
           -> IO CInt    -- ^ returns 0 on success, -1 if error and errno is set

foreign import ccall unsafe "HsSMBus.h system_smbus_write"
    c_write :: CInt       -- ^ file descriptor
            -> CString    -- ^ Buffer to send
            -> CInt       -- ^ Number of bytes to read
            -> IO CInt    -- ^ returns 0 on success, -1 if error and errno is set

foreign import ccall unsafe "HsSMBus.h system_smbus_read_byte"
    c_read_byte :: CInt       -- ^ file descriptor
                -> IO CInt    -- ^ returns 0<=c<256 on success,
                              --   -1 if error and errno is set

foreign import ccall unsafe "HsSMBus.h system_smbus_write_byte"
    c_write_byte :: CInt       -- ^ file descriptor
                 -> CChar      -- ^ Byte to write
                 -> IO CInt    -- ^ returns 0<=c<256 on success,
                               --   -1 if error and errno is set

foreign import ccall unsafe "HsSMBus.h system_smbus_read_byte_data"
    c_read_byte_data :: CInt       -- ^ file descriptor
                     -> CChar      -- ^ Register address sent to device
                     -> IO CInt    -- ^ returns 0<=c<256 on success,
                                   --   -1 if error and errno is set

foreign import ccall unsafe "HsSMBus.h system_smbus_write_byte_data"
    c_write_byte_data :: CInt       -- ^ file descriptor
                      -> CChar      -- ^ Register address sent to device
                      -> CChar      -- ^ Byte to write
                      -> IO CInt    -- ^ returns 0<=c<256 on success,
                                    --   -1 if error and errno is set
