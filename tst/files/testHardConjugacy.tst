gap> TestConjugacy := function(P, iso, n)
>     local G,W,i,g,h,x,y,c;
>     G := Source(iso);
>     W := Range(iso);
>     for i in [1..n] do
>         g := PseudoRandom(G);
>         repeat
>             h := g ^ PseudoRandom(P);
>         until h in G;
>         x := g ^ iso;
>         y := h ^ iso;
>         c := WPE_RepresentativeAction(W, x, y);
>         if IsConjugate(G, g, h) = false then
>             if c <> fail then
>                 return false;
>             fi;
>         else
>             if c = fail or x ^ c <> y or g ^ (PreImage(iso, c)) <> h then
>                 return false;
>             fi;
>         fi;
>     od;
>     return true;
> end;;
gap> K := SymmetricGroup(10);;
gap> H := DirectProduct([SymmetricGroup(5),SymmetricGroup(5)]);;
gap> G := WreathProduct(K, H);;
gap> P := WreathProduct(K, SymmetricGroup(MovedPoints(H)));;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestConjugacy(P, iso, 5);
true
gap> 