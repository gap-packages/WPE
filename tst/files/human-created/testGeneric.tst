gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(3);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismWreathProduct(G);;
gap> W := Image(iso);;
gap> g := (1,12,9,3,13,10,5,15,8)(2,14,7)(4,11,6);;
gap> x := g^iso;
< wreath product element with 3 base components >
gap> Print(x, "\n");
[ (1,2,4), (1,4,3), (2,4)(3,5), (1,3,2) ]
gap> Display(x);
     1        2         3         top  
( (1,2,4), (1,4,3), (2,4)(3,5); (1,3,2) )
gap> SetDisplayOptionsForWreathProductElements(rec(horizontal := false));;
gap> DisplayOptionsForWreathProductElements();
rec(
  horizontal := false,
  labelColor := "default",
  labelStyle := "none",
  labels := true )
gap> Display(x);
  1: (1,2,4)
  2: (1,4,3)
  3: (2,4)(3,5)
top: (1,3,2)
gap> Display(x, rec(labels := false));
(1,2,4)
(1,4,3)
(2,4)(3,5)
(1,3,2)
gap> ResetDisplayOptionsForWreathProductElements();
gap> Display(x, rec(labels := false));
( (1,2,4), (1,4,3), (2,4)(3,5); (1,3,2) )
gap> BaseComponentOfWreathProductElement(x);
[ (1,2,4), (1,4,3), (2,4)(3,5) ]
gap> BaseComponentOfWreathProductElement(x, 2);
(1,4,3)
gap> TopComponentOfWreathProductElement(x);
(1,3,2)
gap> [K, H] = ComponentsOfWreathProduct(W);
true
gap> Print(GeneratorsOfGroup(BaseGroupOfWreathProduct(W)), "\n");
[ [ (1,2,3,4,5), (), (), () ], [ (3,4,5), (), (), () ], 
  [ (), (1,2,3,4,5), (), () ], [ (), (3,4,5), (), () ], 
  [ (), (), (1,2,3,4,5), () ], [ (), (), (3,4,5), () ] ]
gap> Print(GeneratorsOfGroup(BaseGroupOfWreathProduct(W, 2)), "\n");
[ [ (), (1,2,3,4,5), (), () ], [ (), (3,4,5), (), () ] ]
gap> Print(GeneratorsOfGroup(TopGroupOfWreathProduct(W)), "\n");
[ [ (), (), (), (1,2,3) ], [ (), (), (), (1,2) ] ]
