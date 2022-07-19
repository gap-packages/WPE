gap> ReadPackage("WPE","tst/testIso.g");;
gap> # [Mat, Perm]
gap> K := GL(3,5);;
gap> H := SymmetricGroup(4);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismWreathProduct(G);;
gap> TestIso(iso, 20);
true
gap> 