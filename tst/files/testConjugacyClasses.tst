gap> TestConjugacyClasses := function(K, H, size)
>     local G,C,D;
>     G := WreathProduct(K, H);
>     C := WPE_ConjugacyClasses(G);
>     return Size(C) = size;
> end;;
gap> K := SymmetricGroup(4);;
gap> H := SymmetricGroup(5);;
gap> TestConjugacyClasses(K, H, 506);
true
gap> K := SymmetricGroup(4);;
gap> H := AlternatingGroup(5);;
gap> TestConjugacyClasses(K, H, 337);
true
gap> K := SymmetricGroup(4);;
gap> H := DihedralGroup(IsPermGroup, 10);;
gap> TestConjugacyClasses(K, H, 512);
true
gap> K := SymmetricGroup(4);;
gap> H := Group((1,2,3)(4,5));;
gap> TestConjugacyClasses(K, H, 1100);
true
gap> 