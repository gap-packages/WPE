gap> TestConjugacy := function(K, H, n)
>     local G, P, i, g, h, c;
>     G := WreathProduct(K, H);;
>     P := WreathProduct(K, SymmetricGroup(MovedPoints(H)));
>     for i in [1..n] do
>         g := PseudoRandom(G);
>         repeat
>             h := g ^ PseudoRandom(P);
>         until h in G;
>         c := RepresentativeAction(G, g, h);
>         if c <> fail and g ^ c <> h then
>             return false;
>         fi;
>     od;
>     return true;
> end;;
gap> K := SymmetricGroup(10);;
gap> H := DirectProduct([SymmetricGroup(5), SymmetricGroup(5)]);;
gap> TestConjugacy(K, H, 5);
true
