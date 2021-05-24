gap> TestCentraliser := function(iso, n)
>     local G,W,i,g,x,C,Cgens;
>     G := Source(iso);
>     W := Range(iso);
>     for i in [1..n] do
>         g := PseudoRandom(G);
>         x := g ^ iso;
>         C := WPE_Centraliser(W, x);
>         Cgens := GeneratorsOfGroup(C);
>         if Centraliser(G, g) <> Group(List(Cgens, gen -> PreImage(iso, gen))) then
>             return false;
>         fi;
>     od;
>     return true;
> end;;
gap> K := SymmetricGroup(4);;
gap> H := SymmetricGroup(8);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestCentraliser(iso, 20);
true
gap> K := SymmetricGroup(4);;
gap> H := AlternatingGroup(8);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestCentraliser(iso, 20);
true
gap> K := SymmetricGroup(4);;
gap> H := DihedralGroup(IsPermGroup,16);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestCentraliser(iso, 20);
true