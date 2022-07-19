gap> TestDecomp := function(iso, n)
>     local W, i, x, wreathDecomp, sparseDecomp, conj;
>     W := Range(iso);
>     for i in [1..n] do
>         x := PseudoRandom(W);
>         wreathDecomp := WreathCycleDecomposition(x);
>         sparseDecomp := SparseWreathCycleConjugate(x);
>         conj := ConjugatorWreathCycleToSparse(x);
>         if Product(wreathDecomp) <> x then
>             return false;
>         fi;
>         if ForAny(wreathDecomp, y -> not IsWreathCycle(y)) then
>             return false;
>         fi;
>         if ForAny(sparseDecomp, y -> not IsSparseWreathCycle(y)) then
>             return false;
>         fi;
>         if Length(wreathDecomp) <> Length(sparseDecomp) or Length(wreathDecomp) <> Length(conj) then
>             return false;
>         fi;
>         if ForAny([1..Length(wreathDecomp)], i -> wreathDecomp[i]^conj[i] <> sparseDecomp[i]) then
>             return false;
>         fi;
>         if x^Product(conj) <> Product(sparseDecomp) then
>             return false;
>         fi;
>     od;
>     return true;
> end;;
gap> # [Perm, Perm]
gap> K := AlternatingGroup(5);;
gap> H := SymmetricGroup(7);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismWreathProduct(G);;
gap> TestDecomp(iso, 10);
true
gap> # [Mat, Perm]
gap> K := GL(3,5);;
gap> H := SymmetricGroup(4);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismWreathProduct(G);;
gap> TestDecomp(iso, 10);
true
gap> 