gap> TestAction := function(iso, n)
>     local G,K,H,W,i,point,tupel;
>     G := Source(iso);
>     W := Range(iso);
>     K := WreathProductInfo(W).groups[1];
>     H := WreathProductInfo(W).groups[2];
>     for i in [1..n] do
>         point := PseudoRandom(ExternalSet(G));
>         tupel := WPE_ConvertPointToTupel(G, point);
>         if point <> WPE_ConvertTupelToPoint(G, tupel) then
>             return false;
>         fi;
>         tupel := PseudoRandom(Cartesian(ExternalSet(K),ExternalSet(H)));
>         point := WPE_ConvertTupelToPoint(G, tupel);
>         if tupel <> WPE_ConvertPointToTupel(G, point) then
>             return false;
>         fi;
>     od;
>     return true;
> end;;
gap> 
gap> # [Perm, Perm]
gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestAction(iso, 10);
true
gap> 
gap> # [Perm, Perm]
gap> # Renaming Points of K
gap> K := AlternatingGroup([21,22,23,24,25]);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestAction(iso, 10);
true
gap> 
