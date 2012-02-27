every computation run will have a spec for how to run it

eg:

model: lossfun name -- one of Logistic, Squared, etc
regularized: True / False  (whether or not do regularize)
L1Range : lo, hi   --- will also use l1 = 0, 
L1resolution: step -- step will be < 3 decimal place number, no smaller than .001 ,
        will  consider all settings of the form lo +k * step <= hi, and then hi
L2Range : lo, hi
L2resolution : same principal as L1resolution

might also want to set learning rate?

Quadratic:  NS1 , NS2
Vowpal: True/False  -- run eveything in vowpal wabbit style, make sure 
    everything we pass to vowpal wabbit is in its expected format /style

quadratic spe

\begin{code}
    
\end{code}
