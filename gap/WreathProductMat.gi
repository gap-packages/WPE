InstallMethod( IsomorphismToGenericWreathProduct, "Matrix to Generic", true, [HasWreathProductInfo and IsMatrixGroup], 0,
function(G)
    local W, iso;

    W := WPE_GenericMatWreathProduct(G);
    iso := GroupHomomorphismByFunction(G,W,g->WPE_ConvertMatToRep(G,W,g), rep -> WPE_ConvertRepToMat(G,W,rep));
    return iso;
end);

InstallGlobalFunction( WPE_GenericMatWreathProduct,
function(G)
    local info, K, H;
    info := WreathProductInfo(G);
    K := info.groups[1];
    H := info.groups[2];
    return WreathProduct(K, H, IdentityMapping(H));
end);

InstallGlobalFunction( WPE_ConvertMatToRep,
function(G, W, g)
    local info, degI, dimA, field, base, top, topImages, block, k, l, rep;

    info := WreathProductInfo(G);
    degI := info.degI;
    dimA := info.dimA;
    field := info.field;

    base := [];
    topImages := [];
    for k in [1..degI] do 
        for l in [1..degI] do
            block := g{[dimA * (k-1) + 1..dimA * k]}{[dimA * (l-1) + 1..dimA * l]};
            if block <> NullMat(dimA, dimA, field) then
                Add(base, block);
                Add(topImages,l);
                break;
            fi;
        od;
    od;
    top := PermList(topImages);
    rep := Concatenation(base, [top]);
    return Objectify(WreathProductInfo(W).family!.defaultType, rep);
end);

InstallGlobalFunction( WPE_ConvertRepToMat,
function(G, W, rep)
    local info, base, top, i, prod;

    info := WreathProductInfo(G);
    top := Image(Embedding(G, info.degI + 1), rep![info.degI + 1]);
    base := [];
    for i in [1..info.degI] do
        Add(base, Image(Embedding(G, i), rep![i]));
    od;
    prod := Product(Concatenation(base, [top]));
    return prod;
end);