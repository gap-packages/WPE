gap> TestPermIso := function(iso, n)
>     local G, W, i, perm, rep, point, tupel;
>     G := Source(iso);
>     W := Range(iso);
>     for i in [1..n] do
>         perm := PseudoRandom(G);
>         if perm <> PreImage(iso, Image(iso,perm)) then
>             return false;
>         fi;
>         rep := PseudoRandom(W);
>         if rep <> Image(iso, PreImage(iso,rep)) then
>             return false;
>         fi;
>         point := PseudoRandom(ExternalSet(G));
>         tupel := WPE_ConvertPointToTupel(G, point);
>         if point <> WPE_ConvertTupelToPoint(G, tupel) then
>             return false;
>         fi;
>     od;
>     return true;
> end;
function( iso, n ) ... end
gap> 
gap> # [Perm, Perm]
gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestPermIso(iso, 10);
true
gap> 
gap> # [Perm, Perm]
gap> # Renaming Points of K
gap> K := AlternatingGroup([21,22,23,24,25]);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestPermIso(iso, 10);
true
gap> 
gap> ### Not Working, since Projection does not map onto H. Bug in GAP?
gap> # # [Perm, Perm]
gap> # # Renaming Points of H
gap> # K := AlternatingGroup(5);;
gap> # H := SymmetricGroup([11,12,13,14,15,16,17]);;
gap> # G := WreathProduct(K, H);;
gap> # iso := IsomorphismToGenericWreathProduct(G);;
gap> # TestPermIso(iso, 10);
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
gap> # iso := IsomorphismToGenericWreathProduct(G);;
gap> # TestPermIso(iso, 10);
gap> 