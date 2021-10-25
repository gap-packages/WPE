gap> TestIn := function(G, n)
>     local i, g;
>     for i in [1..n] do
>         g := PseudoRandom(G);
>         if not g in G then
>             return false;
>         fi;
>     od;
>     return true;
> end;;
gap> TestInParentWreathProduct := function(G, n)
>     local P, i, g, h;
>     P := WreathProduct(K, SymmetricGroup(MovedPoints(H)));
>     for i in [1..n] do
>         g := PseudoRandom(P);
>         if not g in P then
>             return false;
>         fi;
>         h := ImageElm(Projection(P), g);
>         if not h in H and g in G then
>             return false;
>         fi;
>         if h in H and not g in G then
>             return false;
>         fi;
>     od;
>     return true;
> end;;
gap> TestInParent := function(G, n)
>     local W, P, i, g, h;
>     W := Group(GeneratorsOfGroup(G));
>     if IsPermGroup(G) then
>         P := SymmetricGroup(MovedPoints(G));
>     elif IsMatrixGroup(G) then
>         P := GL(DimensionOfMatrixGroup(G), FieldOfMatrixGroup(G));
>     else
>         return Error("Test not implemented for this representation!");
>     fi;
>     for i in [1..n] do
>         g := PseudoRandom(P);
>         if g in W and not g in G then
>             return false;
>         fi;
>         if not g in W and g in G then
>             return false;
>         fi;
>     od;
>     return true;
> end;;

# S_10 wr (S_5 x S_5)
gap> K := SymmetricGroup(10);;
gap> H := DirectProduct([SymmetricGroup(5), SymmetricGroup(5)]);;
gap> G := WreathProduct(K, H);;
gap> TestIn(G, 20);
true
gap> TestInParentWreathProduct(G, 20);
true
gap> TestInParent(G, 20);
true

# A_8 wr D_12
gap> K := AlternatingGroup(8);;
gap> H := DihedralGroup(IsPermGroup, 12);;
gap> G := WreathProduct(K, H);;
gap> TestIn(G, 20);
true
gap> TestInParentWreathProduct(G, 20);
true
gap> TestInParent(G, 20);
true

# Sp(8, 9) wr A_7
gap> K := SP(8, 9);;
gap> H := AlternatingGroup(7);;
gap> G := WreathProduct(K, H);;
gap> TestIn(G, 20);
true
gap> TestInParentWreathProduct(G, 20);
true