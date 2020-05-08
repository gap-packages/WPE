gap> # [Perm, Perm]
gap> K := SymmetricGroup(5);;
gap> H := SymmetricGroup(4);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> W := Image(iso);;
gap> x := Image(Embedding(W,1), (1,2,3,4,5));;
gap> IsCagedCycle(x);
true
gap> x := x * Image(Embedding(W,3), (1,2));;
gap> IsCagedCycle(x);
false
gap> x := x * Image(Embedding(W,5), (1,3,4));;
gap> IsCagedCycle(x);
true
gap> x := x * Image(Embedding(W,2), (1,2));;
gap> IsCagedCycle(x);
false
gap> 