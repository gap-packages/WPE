TestIso := function(iso, n)
    local G, W, i, g, h, x, y;
        G := Source(iso);
        W := Range(iso);
        for i in [1..n] do
            g := PseudoRandom(G);
            h := PseudoRandom(G);
            x := Image(iso,g);
            y := Image(iso,h);
            if g <> PreImage(iso, x) or h <> PreImage(iso, y) then
                return false;
            fi;
            if x * y <> Image(iso, g*h) then
                return false;
            fi;
            x := PseudoRandom(W);
            y := PseudoRandom(W);
            g := PreImage(iso,x);
            h := PreImage(iso,y);
            if x <> Image(iso, g) or y <> Image(iso, h) then
                return false;
            fi;
            if g * h <> PreImage(iso, x * y) then
                return false;
            fi;
        od;
    return true;
end;