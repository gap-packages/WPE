gap> TestAction := function(iso, n)
>     local G,K,H,W,i,point,tuple,g,x,pointImage,tupleImage;
>     G := Source(iso);
>     W := Range(iso);
>     K := WreathProductInfo(W).groups[1];
>     H := WreathProductInfo(W).groups[2];
>     for i in [1..n] do
>         point := PseudoRandom(ExternalSet(G));
>         tuple := WPE_ImprimitiveConvertPointToTuple(G, point);
>         if point <> WPE_ImprimitiveConvertTupleToPoint(G, tuple) then
>             return false;
>         fi;
>         tuple := PseudoRandom(Cartesian(ExternalSet(K),ExternalSet(H)));
>         point := WPE_ImprimitiveConvertTupleToPoint(G, tuple);
>         if tuple <> WPE_ImprimitiveConvertPointToTuple(G, point) then
>             return false;
>         fi;
>         g := PseudoRandom(G);
>         x := g^iso;
>         pointImage := OnPoints(point, g);
>         tupleImage := WPE_ImprimitiveAction(tuple, x);
>         if pointImage <> WPE_ImprimitiveConvertTupleToPoint(G, tupleImage) then
>             return false;
>         fi;
>         if tupleImage <> WPE_ImprimitiveConvertPointToTuple(G, pointImage) then
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
