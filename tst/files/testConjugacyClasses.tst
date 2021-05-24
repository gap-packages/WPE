gap> TestConjugacyClasses := function(K, H)
>     local G,C,D;
>     G := WreathProduct(K, H);
>     C := WPE_ConjugacyClasses(G);
>     D := ConjugacyClasses(G);
>     return Size(C) = Size(D);
> end;;
gap> K := SymmetricGroup(4);;
gap> H := SymmetricGroup(5);;
gap> TestConjugacyClasses(K, H);
true
gap> K := SymmetricGroup(4);;
gap> H := AlternatingGroup(5);;
gap> TestConjugacyClasses(K, H);
true
gap> K := SymmetricGroup(4);;
gap> H := DihedralGroup(IsPermGroup, 10);;
gap> TestConjugacyClasses(K, H);
true
gap> 
gap> # Currently only transitive top groups are supported.
gap> #K := SymmetricGroup(4);;
gap> #H := Group((1,2,3)(4,5));;
gap> #TestConjugacyClasses(K, H);
gap> 