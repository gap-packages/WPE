gap> TestOrder := function(iso, n)
>     local G,W,i,g,x;
>     G := Source(iso);
>     W := Range(iso);
>     for i in [1..n] do
>         g := PseudoRandom(G);
>         x := g^iso;
>         if Order(g) <> Order(x) then
>             return false;
>         fi;
>     od;
>     return true;
> end;;
gap> # [Perm, Perm]
gap> K := SymmetricGroup(5);;
gap> H := SymmetricGroup(4);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismWreathProduct(G);;
gap> TestOrder(iso, 20);
true
gap> 