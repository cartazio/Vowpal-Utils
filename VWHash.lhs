\begin{code}
module Data.Digest.VowPal where
import Data.Word
--import Data.Digest.Murmur32 -- (asWord32,hash32AddWord32,Hash32)
import Data.Int 
import Data.Bits
import Data.Bytestring

-- hash32end and hash32AddWord32 are from the hackage murmur-hash lib 

liftWord :: Word8 ->Word32
liftWord = fromIntegral 

hash32End :: Word32 -> Word32
hash32End ( h) =
  let h1 = h `xor` (h `shiftR` 13)
      h2 = h1 * murmur_m
      h3 = h2 `xor` (h2 `shiftR` 15)
  in  h3

bStringAsWords :: B.Bytestring -> ([Word32], Maybe Word32)
bStringAsWords str = chew [] $! B.unpack $! str 
    where
        chew sofar [] = (reverse sofar, Nothing)
        chew sofar (a:[]) = (reverse sofar, Just $ adjust [a]) 
        chew sofar (a:b:[]) = (reverse sofar, Just $ adjust [a,b])
        chew sofar (a:b:c:[]) = (reverse sofar , )

hash32AddWord32 :: Word32 -> Word32 -> Word32
hash32AddWord32 k ( h) =
  let k1 = k * murmur_m
      k2 = k1 `xor` (k1 `shiftR` murmur_r)
      k3 = k2 * murmur_m
      h1 = h * murmur_m
      h2 = h1 `xor` k3
  in  h2

murmur_m :: Word32
murmur_m = 0x5bd1e995

murmur_r :: Int --- this is just a shift, it doesn't need to be int32
murmur_r = 24

makeMask :: Int -> Word32
makeMask ind = ( one  `shiftL` ind)   - 1 
    where   one :: Word32
            one =1 

hashBase :: Word32 
hashBase =  97562527
\end{code}
