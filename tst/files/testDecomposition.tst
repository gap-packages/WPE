gap> TestDecomp := function(iso, n)
>     local W, i, x, decomp, normal, conj;
>     W := Range(iso);
>     for i in [1..n] do
>         x := PseudoRandom(W);
>         decomp := CagedCycleDecomposition(x);
>         normal := NormalCycleDecomposition(x);
>         conj := ConjugatorCagedToNormal(x);
>         if Product(decomp) <> x then
>             return false;
>         fi;
>         if ForAny(decomp, y -> not IsCagedCycle(y)) then
>             return false;
>         fi;
>         if ForAny(normal, y -> not IsNormalCycle(y)) then
>             return false;
>         fi;
>         if Length(decomp) <> Length(normal) or Length(decomp) <> Length(conj) then
>             return false;
>         fi;
>         if ForAny([1..Length(decomp)], i -> decomp[i]^conj[i] <> normal[i]) then
>             return false;
>         fi;
>         if x^Product(conj) <> Product(normal) then
>             return false;
>         fi;
>     od;
>     return true;
> end;;
gap> # [Perm, Perm]
gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestDecomp(iso, 10);
true
gap> # [Mat, Perm]
gap> K := GL(3,5);;
gap> H := SymmetricGroup(4);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestDecomp(iso, 10);
true
gap> 