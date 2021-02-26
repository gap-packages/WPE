gap> TestConjugacy := function(iso, n)
>     local G,W,i,g,h,x,y,c;
>     G := Source(iso);
>     W := Range(iso);
>     for i in [1..n] do
>         g := PseudoRandom(G);
>         h := PseudoRandom(G);
>         x := g ^ iso;
>         y := h ^ iso;;
>         c := WPE_RepresentativeAction(x, y);
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
gap> K := AlternatingGroup(15);;
gap> H := SymmetricGroup(25);;
gap> G := WreathProduct(K, H);;
gap> iso := IsomorphismToGenericWreathProduct(G);;
gap> TestConjugacy(iso, 20);
true
gap> 