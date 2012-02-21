Lets regard vowpal utils as essentially a build system for analyzing data
we want to feed to vowpal wabbit, evaluating how tuning certain parameters 
effect prediction quality, and associated reporting. From this perspective 
 

\begin{code}
{-# LANGUAGE DeriveDataTypeable #-}
module PrepareData where

import System.Console.CmdArgs ---cmdargs lib
import System.Cmd  
-- process lib, we'll use system :: string -> IO exitcode
-- Note that


data HBSettings = HB {  spec ::String }
    deriving (Show,Eq,Data,Typeable)

flags = cmdArgsMode $ HB {spec = def &=typFile &= explicit 
                                &= name "spec" &= name "s"}
                        &= program "vowpal-util"



main = do 
            settings <- cmdArgsRun flags
            return ()


\end{code}