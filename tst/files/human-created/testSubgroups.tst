# Perm Rep
gap> G := WreathProduct(SymmetricGroup(4), SymmetricGroup(8));;
gap> x := (1,26,17,32,15,3,28,18,30,13,2,27,19,29,14,4,25,20,31,16)(5,21,8,24,7,23,6,22)(9,12);;
gap> y := (1,30,27,13,3,31,26,16,4,29,25,14,2,32,28,15)(5,12,19)(6,9,17)(7,11,18,8,10,20)(22,24);;
gap> z := (2,4)(5,6)(9,24,27,31,13,11,23,26,30,14,10,22,28,29,16)(12,21,25,32,15)(19,20);;
gap> c := (2,4)(5,6)(9,24,27,31,13,11,23,26,30,14,10,22,28,29,16)(12,21,25,32,15)(19,20);;
gap> K := Group([x, y]);;
gap> Centraliser(G, K);
Group(())
gap> H := Group([z]);;
gap> IsConjugate(G, K, H);
false
gap> U := Group([x ^ c, y ^ c]);;
gap> IsConjugate(G, K, U);
true

# Matrix Rep
gap> G := WreathProduct(SL(2,3), SymmetricGroup(3));;
gap> x := [
>  [ Z(3), Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, Z(3) ], 
>  [ 0*Z(3), 0*Z(3), Z(3)^0, Z(3), 0*Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ] ];;
gap> y := [
>  [ 0*Z(3), 0*Z(3), Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3), 0*Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ], 
>  [ Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ Z(3)^0, Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ] ];;
gap> z := [
>  [ 0*Z(3), 0*Z(3), Z(3)^0, Z(3), 0*Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], 
>  [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ Z(3)^0, Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3), Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3) ] ];;
gap> c := [
>  [ 0*Z(3), Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ Z(3)^0, Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, Z(3) ], 
>  [ 0*Z(3), 0*Z(3), Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
>  [ 0*Z(3), 0*Z(3), Z(3)^0, Z(3), 0*Z(3), 0*Z(3) ] ];;
gap> K := Group([x, y]);;
gap> Centraliser(G, K);
<group of 6x6 matrices over GF(3)>
gap> H := Group(z);;
gap> IsConjugate(G, K, H);
false
gap> U := Group([x ^ c, y ^ c]);;
gap> IsConjugate(G, K, U);
true

# Generic Rep
gap> G := WreathProduct(DihedralGroup(10), SymmetricGroup(3));;
gap> F := ComponentsOfWreathProduct(G)[1];;
gap> f1 := F.1;;
gap> f2 := F.2;;
gap> x := WreathProductElementList(G, [f1*f2^2, f2^4, f1*f2^3, (1,3)]);;
gap> y := WreathProductElementList(G, [f1, f1, f1*f2, (1,3,2)]);;
gap> z := WreathProductElementList(G, [f2^2, f1*f2^4, f1*f2^3, ()]);;
gap> c := WreathProductElementList(G, [f2^2, f1, f2^2, (1,2)]);;
gap> K := Group([x, y]);;
gap> Centraliser(G, K);
<trivial group>
gap> H := Group(z);;
gap> IsConjugate(G, K, H);
false
gap> U := Group([x ^ c, y ^ c]);;
gap> IsConjugate(G, K, U);
true
