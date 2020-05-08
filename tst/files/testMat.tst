gap> TestMatIso := function(iso, n)
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
>     od;
>     return true;
> end;;
gap> # [Mat, Perm]
gap> K := GL(3,5);;
gap> H := SymmetricGroup(4);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestMatIso(iso, 20);
true
gap> 