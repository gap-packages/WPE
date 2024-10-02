#
# h     : List h_{j} of cycles of same load
# gamma : List gamma_{j} of points, where gamma[j] in supp(h[j])
# m     : Degree of image symmetric group
#
# This function returns an (action) homomorphism from S_k to S_m,
# where k is the number of cycles in h.
# The action is induced by permuting the cycles on the left side
# and conjugating the cycles on the right side.
#
BindGlobal( "WPE_PsiFunc",
function(h, gamma, m)
    local ord, k, involutionImage, longCycleImage;
    if Length(h) = 1 then
        return GroupHomomorphismByImages(SymmetricGroup(1), SymmetricGroup(m), [()], [()]);
    fi;
    ord := Order(h[1]);
    k := Length(h);
    involutionImage := Product([0 .. ord - 1], i -> CycleFromList([gamma[1]^(h[1]^i), gamma[2]^(h[2]^i)]));
    longCycleImage := Product([0 .. ord - 1], i -> CycleFromList(List([1 .. k], j -> gamma[j]^(h[j]^i))));
    return GroupHomomorphismByImages(SymmetricGroup(k), SymmetricGroup(m), [(1,2),CycleFromList([1 .. k])], [involutionImage, longCycleImage]);
end);

#
# t                 : Element from Stab_{C_{Sym(m)}(h)}(P(w))
# h                 : List h_{i, j} of cycles, where h[i, j] and h[a, b] have same load iff i = a
# gamma             : List gamma_{i, j} of points, where gamma[i, j] in supp(h[i, j])
# GammaMinusTerr    : Gamma \ terr(w)
# m                 : Degree of top group
#
# This function returns a decomposition of t as a rec(e, sigma, pi0), such that
# t = (prod_{i=1}^l ( prod_{j = 1}^{k_i} h[i, j] ^ e[i, j] ) * [sigma[i]]Psi_i ) * pi0
#
BindGlobal( "WPE_StabDecomp",
function(t, h, gamma, GammaMinusTerr, terrDecomp, m)
    local l, i, ki, sigmaList, sigmaImage, j, point, psiFuncs, piList, pi, tBase, eList, ord, e;
    l := Length(gamma);
    if IsOne(t) then
        return rec(
            e := List([1 .. l], i -> List([1 .. Length(gamma[i])], j -> 0)),
            sigma := List([1 .. l], i -> ()),
            pi0 := ());
    else
        sigmaList := EmptyPlist(l);
        for i in [1 .. l] do
            ki := Length(gamma[i]);
            sigmaImage := EmptyPlist(ki);
            for j in [1 .. ki] do
                point := gamma[i, j] ^ t;
                sigmaImage[j] := First([1 .. ki], k -> point in terrDecomp[i, k]);
            od;
            sigmaList[i] := PermList(sigmaImage);
        od;
        psiFuncs := List([1 .. l], i -> WPE_PsiFunc(h[i], gamma[i], m));
        piList := List([1 .. l], i -> sigmaList[i] ^ psiFuncs[i]);
        pi := Product(piList);
        tBase := t * pi ^ -1;
        eList := EmptyPlist(l);
        for i in [1 .. l] do
            ki := Length(gamma[i]);
            ord := Order(h[i, 1]);
            e := List([1 .. ki], j -> First([0 .. ord - 1], k -> gamma[i, j] ^ (h[i, j] ^ k) = gamma[i, j] ^ tBase));
            eList[i] := e;
        od;
        return rec(e := eList, sigma := sigmaList, pi0 := RestrictedPermNC(t, GammaMinusTerr));
    fi;
end);

BindGlobal( "WPE_Centraliser_Image",
function(c, c0, t, h, gamma, GammaMinusTerr, terrDecomp, f, x, xInv, m)
    local tDecomp, i, j, ord, ki, k, e, sigma, pi0, l, a, s0, s1, gamma0;
    tDecomp := WPE_StabDecomp(t, h, gamma, GammaMinusTerr, terrDecomp, m);
    e := tDecomp.e;
    sigma := tDecomp.sigma;
    pi0 := tDecomp.pi0;
    l := Length(gamma);
    a := EmptyPlist(m + 1);
    a[m + 1] := t;
    a{GammaMinusTerr} := c0;
    for i in [1 .. l] do
        ord := Order(h[i, 1]);
        ki := Length(gamma[i]);
        for j in [1 .. ki] do
            s0 := xInv[i, j] * c[i, j] * x[i, j ^ sigma[i]];
            s1 := s0;
            if e[i,j] > 0 then
                s1 := s0 * f[i, j ^ sigma[i]];
            fi;
            gamma0 := gamma[i, j] ^ (h[i, j] ^ -e[i, j]);
            a[gamma0] := s0;
            for k in [1 .. e[i, j]] do
                gamma0 := gamma0 ^ h[i, j];
                a[gamma0] := s1;
            od;
            for k in [e[i, j] + 1 .. ord - 1] do
                gamma0 := gamma0 ^ h[i, j];
                a[gamma0] := s0;
            od;
        od;
    od;
    return a;
end);

BindGlobal( "WPE_Centraliser",
function(W, v)
    local grps, K, H, m, conjToSparseUnsorted, conjToSparse, conjToSparseElm, conjToSparseProd, conjToSparseInv, conjToSparseInvProd,
    w, wPartitionData, partition, l, h,
    gamma, wTerr, GammaMinusTerr, f, x, gammaPoints, gammaPoint, z, shift, blockLength,
    i, j, k, CK, terrDecomp, ki, T, CKgens, Kgens, Tgens, nrGens,
    Cgens, cTrivial, c0Trivial, gen, c, c0, t, isVisited, s, conj, a, type, xInv;
    # Catch the case v = 1
    if ForAll([1 .. WPE_TopDegree(v)], i -> IsOne(WPE_BaseComponent(v, i))) and IsOne(WPE_TopComponent(v)) then
        return W;
    fi;
    # Init Data
    grps := ComponentsOfWreathProduct(W);
    K := grps[1];
    H := grps[2];
    m := NrMovedPoints(H);
    m := Maximum(1, m);
    # Sparse Decomposition
    # TODO: Remove Ugly Hack
    # Ugly Hack: deal with list rep
    conjToSparse := ConjugatorWreathCycleToSparse(v);
    if IsList(v) then
        conjToSparseElm := List(conjToSparse, z -> WreathProductElementListNC(W, z));
        conjToSparseProd := Product(conjToSparseElm);
        conjToSparseInvProd := conjToSparseProd ^ -1;
        w := ListWreathProductElementNC(W, WreathProductElementListNC(W, v) ^ conjToSparseProd, false);
    else
        conjToSparseProd := Product(conjToSparse);
        conjToSparseInvProd := conjToSparseProd ^ -1;
        w := v ^ conjToSparseProd;
    fi;
    # Compute partition
    wPartitionData := WPE_PartitionDataOfWreathCycleDecompositionByLoad(W, w, conjToSparse);
    partition := wPartitionData.partition;
    l := Length(partition);
    h := EmptyPlist(l);
    gamma := EmptyPlist(l);
    wTerr := Territory(w);
    GammaMinusTerr := Filtered([1 .. m], i -> not i in wTerr);
    f := EmptyPlist(l);
    x := EmptyPlist(l);
    shift := 0;
    conjToSparse := EmptyPlist(l);
    for blockLength in partition do
        Add(h, List(wPartitionData.wDecomp{[1 + shift .. blockLength + shift]},
                WPE_TopComponent));
        Add(f, wPartitionData.wDecompYade{[1 + shift .. blockLength + shift]});
        Add(x, wPartitionData.wBlockConjugator{[1 + shift .. blockLength + shift]});
        Add(conjToSparse, wPartitionData.conjToSparse{[1 + shift .. blockLength + shift]});
        gammaPoints := EmptyPlist(blockLength);
        conj := EmptyPlist(blockLength);
        # We could have a trivial Yade
        for j in [1 .. blockLength] do
            z := wPartitionData.wDecomp[j + shift];
            gammaPoint := First([1 .. m], i -> not IsOne(WPE_BaseComponent(z, i)));
            if gammaPoint = fail then
                gammaPoint := WPE_ChooseYadePoint(z);
            fi;
            Add(gammaPoints, gammaPoint);
        od;
        Add(gamma, gammaPoints);
        shift := shift + blockLength;
    od;
    # TODO: Remove Ugly Hack
    # Ugly Hack: deal with list rep
    if IsList(v) then
        conjToSparseInv := List(conjToSparse, block -> List(block, c -> ListWreathProductElementNC(W, WreathProductElementListNC(W, c) ^ -1, false)));
    else
        conjToSparseInv := List(conjToSparse, block -> List(block, c -> c ^ -1));
    fi;
    xInv := List(x, block -> List(block, c -> c ^ -1));
    # Compute Generators for Components
    CK := List([1 .. l], i -> Centraliser(K, f[i,1]));
    terrDecomp := EmptyPlist(l);
    for i in [1 .. l] do
        ki := Length(h[i]);
        terrDecomp[i] := EmptyPlist(ki);
        for j in [1 .. ki] do
            if IsOne(h[i,j]) then
                terrDecomp[i,j] := [gamma[i,j]];
            else
                terrDecomp[i,j] := MovedPoints(h[i,j]);
            fi;
        od;
    od;
    T := Stabiliser(Centraliser(H, WPE_TopComponent(w)), List(terrDecomp, terr -> Set(Concatenation(terr))), OnTuplesSets);
    CKgens := List(CK, GeneratorsOfGroup);
    Kgens := GeneratorsOfGroup(K);
    Tgens := GeneratorsOfGroup(T);
    nrGens := Sum([1 .. l], Length(CKgens[i]) * Length(h[i])) + Length(Kgens) * Length(GammaMinusTerr) + Length(Tgens);
    Cgens := EmptyPlist(nrGens);
    # Init trivial elements
    cTrivial := List([1 .. l], i -> ListWithIdenticalEntries(Length(h[i]), One(K)));
    c0Trivial := ListWithIdenticalEntries(Length(GammaMinusTerr), One(K));
    # TODO: make smaller generating set for cartesian product in the base group
    # Images for c Component, base elements inside of terr
    c0 := c0Trivial;
    t := One(H);
    for i in [1 .. l] do
        for j in [1 .. Length(h[i])] do
            c := StructuralCopy(cTrivial);
            for gen in CKgens[i] do
                c[i, j] := gen;
                a := WPE_Centraliser_Image(c, c0, t, h, gamma, GammaMinusTerr, terrDecomp, f, x, xInv, m);
                # Conjugate a with with conjToSparseInv[i, j]
                for k in terrDecomp[i,j] do
                    a[k] := WPE_BaseComponent(conjToSparse[i,j], k) * a[k] * WPE_BaseComponent(conjToSparseInv[i,j], k);
                od;
                a := WreathProductElementListNC(W, a);
                Add(Cgens, a);
            od;
        od;
    od;
    # Images for c0 Component, base elements outside of terr
    c := cTrivial;
    t := One(H);
    for i in [1 .. Length(GammaMinusTerr)] do
        c0 := StructuralCopy(c0Trivial);
        for gen in Kgens do
            c0[i] := gen;
            a := WPE_Centraliser_Image(c, c0, t, h, gamma, GammaMinusTerr, terrDecomp, f, x, xInv, m);
            a := WreathProductElementListNC(W, a);
            Add(Cgens, a);
        od;
    od;
    # Images for t Component, top elements
    c0 := c0Trivial;
    c := cTrivial;
    for t in Tgens do
        a := WPE_Centraliser_Image(c, c0, t, h, gamma, GammaMinusTerr, terrDecomp, f, x, xInv, m);
        a := WreathProductElementListNC(W, a);
        a := a ^ conjToSparseInvProd;
        Add(Cgens, a);
    od;
    return Group(Cgens);
end);