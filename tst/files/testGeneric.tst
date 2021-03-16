gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(3);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> W := Image(iso);;
gap> g := (1,12,9,3,13,10,5,15,8)(2,14,7)(4,11,6);;
gap> x := g^iso;
WreathProductElement((1,2,4),(1,4,3),(2,4)(3,5);(1,3,2))
gap> BaseComponentOfGenericWreathProductElement(x);
[ (1,2,4), (1,4,3), (2,4)(3,5) ]
gap> BaseComponentOfGenericWreathProductElement(x, 2);
(1,4,3)
gap> TopComponentOfGenericWreathProductElement(x);
(1,3,2)
gap> [K, H] = ComponentsOfGenericWreathProduct(W);
true
gap> GeneratorsOfGroup(BaseGroupOfGenericWreathProduct(W));
[ WreathProductElement((1,2,3,4,5),(),();()), 
  WreathProductElement((3,4,5),(),();()), 
  WreathProductElement((),(1,2,3,4,5),();()), 
  WreathProductElement((),(3,4,5),();()), 
  WreathProductElement((),(),(1,2,3,4,5);()), 
  WreathProductElement((),(),(3,4,5);()) ]
gap> GeneratorsOfGroup(BaseGroupOfGenericWreathProduct(W, 2));
[ WreathProductElement((),(1,2,3,4,5),();()), 
  WreathProductElement((),(3,4,5),();()) ]
gap> GeneratorsOfGroup(TopGroupOfGenericWreathProduct(W));
[ WreathProductElement((),(),();(1,2,3)), 
  WreathProductElement((),(),();(1,2)) ]
gap> 
