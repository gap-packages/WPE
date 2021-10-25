TestConjugacyClasses := function(K, H, size)
    local G, C;
    G := WreathProduct(K, H);
    C := ConjugacyClasses(G);
    return Size(C) = size;
end;;