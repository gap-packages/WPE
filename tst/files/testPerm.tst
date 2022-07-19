gap> ReadPackage("WPE","tst/testIso.g");;
gap> 
gap> # [Perm, Perm]
gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismWreathProduct(G);;
gap> TestIso(iso, 10);
true
gap> 
gap> # [Perm, Perm]
gap> # Renaming Points of K
gap> K := AlternatingGroup([21,22,23,24,25]);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismWreathProduct(G);;
gap> TestIso(iso, 10);
true
gap> 
gap> ### Not Working, since Projection does not map onto H. Bug in GAP?
gap> # # [Perm, Perm]
gap> # # Renaming Points of H
gap> # K := AlternatingGroup(5);;
gap> # H := SymmetricGroup([11,12,13,14,15,16,17]);;
gap> # G := WreathProduct(K, H);;
gap> # iso := IsomorphismWreathProduct(G);;
gap> # TestIso(iso, 10);
gap> 
gap> ### Not Working, since the constructed wreath product is not in standard imprimitive form. Bug in GAP?
gap> # [Perm, Perm, Hom]
gap> # Renaming Points of H via Hom
gap> # K := AlternatingGroup(5);;
gap> # gens1 := [(1,2,3,4,5,6,7), (1,2)];;
gap> # gens2 := [(11,12,13,14,15,16,17), (11,12)];;
gap> # hom := GroupHomomorphismByImages(Group(gens1), Group(gens2), gens1, gens2);;
gap> # H := Source(hom);;
gap> # G := WreathProduct(K, H, hom);;
gap> # iso := IsomorphismWreathProduct(G);;
gap> # TestIso(iso, 10);
gap> 