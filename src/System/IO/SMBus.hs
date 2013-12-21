module System.IO.SMBus (
    SMBus
  , Device (..)
  , withSMBus
  , i2c_read
  , i2c_write
  , read_byte
  , write_byte
  , read_byte_data
  , write_byte_data
) where

import Control.Applicative ((<$>))
import Control.Exception ( bracket
                         , bracketOnError
                         )
import Data.ByteString as BS (ByteString, length)
import Data.ByteString.Unsafe as BS ( unsafeUseAsCString
                                    , unsafePackMallocCString
                                    )
import Foreign.C.Error ( throwErrnoIf_
                       , throwErrnoIfMinus1
                       , throwErrnoIfMinus1_
                       )
import Foreign.C.String (castCCharToChar, castCharToCChar)
import Foreign.Ptr (castPtr)
import Foreign.C.Types (CInt)
import Foreign.Marshal.Alloc (mallocBytes, free)

import System.IO.SMBus.Internal ( c_open
                                , c_close
                                , c_set_address
                                , c_read
                                , c_write
                                , c_read_byte
                                , c_write_byte
                                , c_read_byte_data
                                , c_write_byte_data
                                )

newtype SMBus = SMBus CInt deriving (Eq, Show)
newtype Device = Device CInt deriving (Eq, Show)

withSMBus :: Int -> (SMBus -> IO a) -> IO a
withSMBus n = bracket open close
  where
    open = SMBus <$> throwErrnoIfMinus1 ("open: Could not open SMBus #" ++ show n)
                                        (c_open (fromIntegral n))
    close (SMBus b) = throwErrnoIfMinus1_ "close:"  (c_close b)

i2c_read :: SMBus -> Device -> Int -> IO ByteString
i2c_read (SMBus fd) (Device addr) count = do
  setAddress fd addr
  let createBuffer = castPtr <$> mallocBytes count
      count'       = fromIntegral count
  bracketOnError createBuffer free $ \buf -> do
    throwErrnoIf_ (\c -> c < count') "read: did not read enough bytes" $
      c_read fd buf count'
    unsafePackMallocCString buf

  

i2c_write :: SMBus -> Device -> ByteString -> IO ()
i2c_write (SMBus fd) (Device addr) bs = unsafeUseAsCString bs $ \buf -> do
  setAddress fd addr
  let count = fromIntegral $ BS.length bs 
  throwErrnoIf_ (\c -> c < count) "read: did not read enough bytes" $
    c_write fd buf count

read_byte :: SMBus -> Device -> IO Char
read_byte (SMBus fd) (Device addr) = do
  setAddress fd addr
  castCCharToChar . fromIntegral <$> throwErrnoIfMinus1 "read_byte:" (c_read_byte fd)

write_byte :: SMBus -> Device -> Char -> IO ()
write_byte (SMBus fd) (Device addr) c = do
  setAddress fd addr
  throwErrnoIfMinus1_ "write_byte:" $ c_write_byte fd (castCharToCChar c)

read_byte_data :: SMBus -> Device -> Char -> IO Char
read_byte_data (SMBus fd) (Device addr) reg = do
  setAddress fd addr
  let r = castCharToCChar reg
  castCCharToChar . fromIntegral <$>
    throwErrnoIfMinus1 "read_byte_data:" (c_read_byte_data fd r)


write_byte_data :: SMBus -> Device -> Char -> Char -> IO ()
write_byte_data (SMBus fd) (Device addr) reg c = do
  setAddress fd addr
  let r  = castCharToCChar reg
      c' = castCharToCChar c
  throwErrnoIfMinus1_ "write_byte_data:" (c_write_byte_data fd r c')

setAddress :: CInt -> CInt -> IO ()
setAddress fd addr =
  throwErrnoIfMinus1_ "set_address: could not set address" $ c_set_address fd addr
