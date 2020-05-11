gap> # [Perm, Perm]
gap> # Renaming Points of K
gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> W := Range(iso);;
gap> oneG := One(G);;
gap> oneW := One(W);;
gap> Image(iso, oneG) = oneW;
true
gap> PreImage(iso, oneW) = oneG;
true
gap> Territory(oneW);
[  ]
gap> CagedCycleDecomposition(oneW);
[  ]
gap> Order(oneW);
1
gap> IsCagedCycle(oneW);
false
gap> 