Lets regard vowpal utils as essentially a build system for analyzing data
we want to feed to vowpal wabbit, evaluating how tuning certain parameters 
effect prediction quality, and associated reporting. From this perspective 
 

\begin{code}
{-# LANGUAGE DeriveDataTypeable #-}
module PrepareData where

import System.Console.CmdArgs ---cmdargs lib
import System.Cmd 

import Development.Shake 
--i'm probably going to fall in love with shake fast, once I decide that I need it
\end{code}
process lib, we'll use system :: string -> IO exitcode


thoughts: the only places  I want to compare file modification times are

if the spec file has changed since the last run (time of modification of report)
     or  the csv data file is newer than the vw data file
      or    csv column rules file is newer than the  vw  data file 
then
    rebuild everything. For now we

note: should also add "phase specifying flag(s)"




\begin{code}
data HBSettings = HB {  spec ::String }
    deriving (Show,Eq,Data,Typeable)


--should make it more general / flexible, but for now this is enough
flags = cmdArgsMode $ HB {spec = def &=typFile &= explicit 
                                &= name "spec" &= name "s"}
                        &= program "vowpal-util"



main = do 
            settings <- cmdArgsRun flags
            shake shakeOptions (buildPlan $ spec settings) 
            -- for now single threaded and 
\end{code}


will for now assume that a "warmed" cache file by 
vowpal wabbit is good for parallel builds!

will use "shake.need" on the unregularized run to prevent the
parallel  runs for regularization and the model evaluation
\begin{code}
buildPlan :: String -> Rules ()
buildPlan str = 
            do 
                need [str ++ ".spec"]        

\end{code}