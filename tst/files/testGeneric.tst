gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(3);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> W := Image(iso);;
gap> g := (1,12,9,3,13,10,5,15,8)(2,14,7)(4,11,6);;
gap> x := g^iso;
( (1,2,4), (1,4,3), (2,4)(3,5); (1,3,2) )
gap> BaseComponentOfWreathProductElement(x);
[ (1,2,4), (1,4,3), (2,4)(3,5) ]
gap> BaseComponentOfWreathProductElement(x, 2);
(1,4,3)
gap> TopComponentOfWreathProductElement(x);
(1,3,2)
gap> [K, H] = ComponentsOfWreathProduct(W);
true
gap> GeneratorsOfGroup(BaseGroupOfWreathProduct(W));
[ ( (1,2,3,4,5), (), (); () ), ( (3,4,5), (), (); () ), 
  ( (), (1,2,3,4,5), (); () ), ( (), (3,4,5), (); () ), 
  ( (), (), (1,2,3,4,5); () ), ( (), (), (3,4,5); () ) ]
gap> GeneratorsOfGroup(BaseGroupOfWreathProduct(W, 2));
[ ( (), (1,2,3,4,5), (); () ), ( (), (3,4,5), (); () ) ]
gap> GeneratorsOfGroup(TopGroupOfWreathProduct(W));
[ ( (), (), (); (1,2,3) ), ( (), (), (); (1,2) ) ]
gap> 
