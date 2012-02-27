this module will simply provide the parsing human readable feature names
into a hash/intmap to coefficient weights, should be wrapped as a sort of 
Functional api, in a way that plays nice with having implicitly 
sparse reprsentation & constant weight included. 
eg 
Maybe Feature -> Weight
maybe have Nothing -> Constant Feature
maybe have that missing features are mapped to 0 
\begin{code}
    
\end{code}