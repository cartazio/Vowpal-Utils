\begin{code}
{-# OPTIONS -XMultiParamTypeClasses -XBangPatterns#-}


{-|
Module      : Data.Digest.VowpalHash
Copyright   : (c) Carter Tazio Schonwald
License     : BSD-style

Maintainer  :  first dot last @gmail.com
Stability   : experimental
Portability : portable


-}


module Data.Digest.VowpalHash where
import Data.Word
--import Data.Digest.Murmur32 -- (asWord32,hash32AddWord32,Hash32)
import Data.Int 
import Data.Bits
import qualified  Data.ByteString as B 
import qualified Data.ByteString.Char8 as C (pack) 
import Data.Foldable (foldl',Foldable)
import qualified Data.ByteString.UTF8 as U 

-- hash32end and hash32AddWord32 are from the hackage murmur-hash lib 

liftWord :: Word8 ->Word32
liftWord = fromIntegral 

hash32End :: Word32 -> Word32
hash32End ( h) =
  let h1 = h `xor` (h `shiftR` 13)
      h2 = h1 * murmur_m
      h3 = h2 `xor` (h2 `shiftR` 15)
  in  h3

bStringAsWords :: B.ByteString -> ([Word32], Maybe Word32)
bStringAsWords str = chew [] $! B.unpack $! str 
    where
        chew :: [Word32] -> [Word8] -> ([Word32], Maybe Word32)
        chew sofar [] = (reverse sofar, Nothing)
        chew sofar [a] = (reverse sofar, Just $ adjust [a]) 
        chew sofar [a,b] = (reverse sofar, Just $ adjust [a,b])
        chew sofar [a,b,c] = (reverse sofar , Just $ adjust [a,b,c])
        chew sofar (a:b:c:d : rest) = chew (quadChange (a,b,c,d) : sofar) rest  -- something wrong happens here?
        quadChange :: (Word8,Word8,Word8,Word8)->Word32
        quadChange (a,b,c,d)=fromIntegral a + ( fromIntegral b `shiftL` 8) +
                    (fromIntegral c `shiftL` 16 ) + (fromIntegral d `shiftL` 24)
        adjust :: [Word8]-> Word32
        --adjust [a,b,c,d] = fromIntegral a + ( fromIntegral b `shiftL` 8) +
        --            (fromIntegral c `shiftL` 16 ) + (fromIntegral d `shiftL` 24)
        adjust [a,b,c] =  fromIntegral a + ( fromIntegral b `shiftL` 8) +
                                (fromIntegral c `shiftL` 16 )            
        adjust [a,b] = fromIntegral a + ( fromIntegral b `shiftL` 8)
        adjust  [a] = fromIntegral a
        adjust _ = error "error, input must be a list with length 1-4"

--- takes next word & current seed -> new seed 
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


hashWithSeed :: Word32 -> B.ByteString -> Word32
hashWithSeed seed str =  hash32End lastState  -- .&. makeMask 18 -- default size is 18
            where
                h = seed `xor` ( fromIntegral $! B.length str) 
                (ls, optRem)= bStringAsWords str
                semilastState= hash32AddFoldable ls h 
                lastState = 
                    case optRem of 
                            Nothing -> semilastState -- * murmur_m  --- not sure if mul is needed here
                            Just a -> (semilastState `xor` a ) * murmur_m  

hash32AddFoldable :: ( Foldable c) => c Word32-> Word32->Word32
hash32AddFoldable c !h0 = foldl' f h0 c
  where f h a = hash32AddWord32 a h

--this seems correct
hashFeature :: String  ->Word32
hashFeature str =( hashWithSeed 0 $ U.fromString  str)  .&. makeMask 18

hashClass :: String -> Word32
hashClass str = hashWithSeed hashBase $ U.fromString str 

--- hash for the constant feature, 
constantHash :: Word32
constantHash = 11650396 .&. makeMask 18

{-const int quadratic_constant = 27942141;
const int constant = 11650396;
need to check if 
-}


-- HashFeatureClass ::  CLASS , FEATURENAME-> hash
-- if theres no class name or " ", use  HashFeature instead!!
hashFeatureClass :: String -> String -> Word32
hashFeatureClass clss feature  = (hashWithSeed (hashClass  clss) $! 
                                U.fromString feature )   .&. makeMask 18
\end{code}


now lets figure out how to do the same with quadratic features!
 const int quadratic_constant = 27942141;   
 88:   size_t stride = global.stride; this doesn't matter actually
  size_t halfhash = quadratic_constant * page_feature.weight_index;
  HASH == (halfhash + ele->weight_index) & mask
  



\begin{code}

quadraticConstant :: Word32
quadraticConstant   = 27942141  

-- pairs of features appear twice in general, need to 
-- hashFeaturePair (a,b) (c,d) != hashFeaturePair (c,d) (a,b)
-- (Class,Feature)
hashFeaturePair :: (String,String)-> (String,String)-> Word32
hashFeaturePair (classa,stra) (classb,strb) = ( hashFeatureClass classa stra   * quadraticConstant + hashFeatureClass classb strb ) .&. makeMask 18



\end{code}  