every computation run will have a spec for how to run it

eg:
data: csvfile.csv (use csvfilename for .vw and presumed cache files, and )
feature: csvinterp.feature
targe: feature we want to predict, for now lets assume 
csvsep: | or , etc, quoted? default to , ?
cachename: optional cache name? for now default  csvfile.cache
model: lossfun name -- one of Logistic, Squared, etc
regularized: True / False  (whether or not do regularize)
L1Range : lo, hi   --- will also use l1 = 0, 
L1resolution: step -- step will be < 3 decimal place number, no smaller than .001 ,
        will  consider all settings of the form lo +k * step <= hi, and then hi
L2Range : lo, hi
L2resolution : same principal as L1resolution

might also want to set learning rate?

Quadratic:  NS1 , NS2  -- have this be a tuple?
Vowpal: True/False  -- run eveything in vowpal wabbit style, make sure 
    everything we pass to vowpal wabbit is in its expected format /style
        for now assume that this is an implicit flag and set it it to true
quadraticOn: true / false -- implicitly true for now

\begin{code}
    
\end{code}
