InstallGlobalFunction( WPE_ConjugacyClasses,
function(W)
    local info, K, H, RK, RH, RW;
    info := WreathProductInfo(W);
    K := info.groups[1];
    H := info.groups[2];
    RK := List(ConjugacyClasses(K),Representative);
    RH := List(ConjugacyClasses(H),Representative);
    RW := List(RH, h -> WPE_ConjugacyClassesWithFixedTopClass(W, H, RK, RH, h));
    return Concatenation(RW);
end);

InstallGlobalFunction( WPE_ConjugacyClassesWithFixedTopClass,
function(W, H, RK, RH, hElm)
    local r, m, h, cycles, cycleLength, l, fixPoints, omega, i, j, k, s, parts, part, blockStart, blockEnd, preTerritoryDecomposition, delta, deltaPoint, d, Ch, translations, gensD, D, shift, gensP, P, c, sigmaImage, sigma, points, point, arr, reps, iter, block, blockLength, repPoints, p, IsPointAvailable, rep, top, base, iterYades, yades, terr, gamma, combi;
    r := Length(RK);
    m := NrMovedPoints(H);
    # h is the decomposition of hElm sorted by cycle type.
    if hElm = () then
        h := [];
    else
        cycles := Cycles(hElm,MovedPoints(hElm));
        cycleLength := List(cycles, c -> Length(c));
        h := List(Set(cycleLength), l -> Set(List(Filtered(cycles, c -> Length(c) = l), CycleFromList)));
    fi;
    l := Length(h);
    # Append the fixed points of hElm
    fixPoints := Filtered([1 .. m], i -> not i in MovedPoints(hElm));
    if not IsEmpty(fixPoints) then
        h[l + 1] := fixPoints;
        l := l + 1;
    fi;
    if IsNaturalSymmetricGroup(H) then
        # omega[i] is the set of all ordered partitions of | h[i] | into at most r Yade classes.
        omega := EmptyPlist(l);
        for i in [1 .. l] do
            omega[i] := [];
            for s in [1 .. r] do
                parts := OrderedPartitions(Length(h[i]), s);
                for part in parts do
                    blockStart := 1;
                    preTerritoryDecomposition := EmptyPlist(s);
                    for j in [1 .. s] do
                        blockEnd := blockStart + part[j] - 1;
                        preTerritoryDecomposition[j] := h[i]{[blockStart .. blockEnd]};
                        blockStart := blockEnd + 1;
                    od;
                    Add(omega[i], preTerritoryDecomposition);
                od;
            od;
        od;
        # Compute representatives of orbits for these partitions
        delta := Cartesian(omega);
    else
        # Initilise Data
        Ch := Centraliser(H, hElm);
        translations := EmptyPlist(l);
        gensD := EmptyPlist(l);
        shift := 0;
        for i in [1 .. l] do
            blockLength := Length(h[i]);
            translations[i] := MappingPermListList([1 .. blockLength], [1 + shift .. blockLength + shift]);
            gensD[i] := GeneratorsOfGroup(SymmetricGroup([1 + shift .. blockLength + shift]));
            shift := shift + blockLength;
        od;
        # Image of c under projection
        gensP := EmptyPlist(Length(GeneratorsOfGroup(Ch)));
        for c in GeneratorsOfGroup(Ch) do
            sigma := One(H);
            for i in [1 .. l] do
                blockLength := Length(h[i]);
                sigmaImage := EmptyPlist(blockLength);
                for j in [1 .. blockLength] do
                    if IsPosInt(h[i,j]) then
                        gamma := h[i, j] ^ c;
                        sigmaImage[j] := First([1 .. blockLength], k -> gamma = h[i, k]);
                    else
                        gamma := MovedPoints(h[i, j])[1] ^ c;
                        sigmaImage[j] := First([1 .. blockLength], k -> gamma in MovedPoints(h[i, k]));
                    fi;
                od;
                sigma := sigma * (PermList(sigmaImage) ^ translations[i]);
            od;
            Add(gensP, sigma);
        od;
        # Right coset representatives
        gensD := Concatenation(gensD);
        if IsEmpty(gensD) then
            gensD := [()];
        fi;
        D := Group(gensD);
        P := Group(gensP);
        reps := List(RightCosets(D, P), coset -> Representative(coset) ^ -1);
        # omega[i] is the set of all unordered partitions of | h[i] | into at most r Yade classes.
        omega := List([1 .. l], i -> Union(List([1 .. r], s -> Partitions(Length(h[i]), s))));
        iter := IteratorOfCartesianProduct(omega);
        delta := [];
        for part in iter do
            # Let representatives act on the standard partitition
            point := EmptyPlist(l);
            for i in [1 .. l] do
                point[i] := EmptyPlist(Length(h[i]));
                shift := 0;
                for blockLength in part[i] do
                    Add(point[i], OnTuples([1 + shift .. blockLength + shift], translations[i]));
                    shift := shift + blockLength;
                od;
            od;
            points := Set(reps, rep -> List(point, block -> OnTuplesSets(block, rep)));
            # Glue these together under the action of P
            # O(#points * #classes)
            repPoints := BlistList([1 .. Length(points)], [1 .. Length(points)]);
            for i in [1 .. Length(points)] do
                if repPoints[i] = false then
                    continue;
                fi;
                for j in [i + 1 .. Length(points)] do
                    if repPoints[j] = false then
                        continue;
                    fi;
                    if RepresentativeAction(P, Concatenation(points[i]), Concatenation(points[j]), OnTuplesSets) <> fail then
                        repPoints[j] := false;
                    fi;
                od;
            od;
            points := ListBlist(points, repPoints);
            # Now compute all arrangements
            for point in points do
                p := EmptyPlist(Length(point));
                for i in [1 .. l] do
                    p[i] := EmptyPlist(Length(point[i]));
                    for block in point[i] do
                        Add(p[i], Length(block));
                    od;
                od;
                for arr in Cartesian(List(p, blocks -> Arrangements(blocks, Length(blocks)))) do
                    IsPointAvailable := List([1..l], i -> BlistList([1 .. Length(point[i])], [1 .. Length(point[i])]));
                    deltaPoint := EmptyPlist(l);
                    for i in [1 .. l] do
                        deltaPoint[i] := EmptyPlist(Length(point[i]));
                        for blockLength in arr[i] do
                            j := First([1 .. Length(point[i])], j -> IsPointAvailable[i, j] and Length(point[i, j]) = blockLength);
                            IsPointAvailable[i, j] := false;
                            Add(deltaPoint[i], h[i]{OnTuples(point[i, j], translations[i] ^ -1)});
                        od;
                    od;
                    Add(delta, deltaPoint);
                od;
            od;
        od;
    fi;
    # Transform these partitions into all possible territory decompositions,
    # i.e. choose explicit Yade classes for each partition.
    rep := [];
    top := hElm ^ Embedding(W, m + 1);
    for d in delta do
        combi := List(d, di -> Combinations(RK, Size(di)));
        iterYades := List(combi, Iterator);
        base := EmptyPlist(Length(d));
        i := 1;
        while i > 0 do
            if IsDoneIterator(iterYades[i]) then
                iterYades[i] := Iterator(combi[i]);
                Unbind(base[i]);
                i := i - 1;
                continue;
            fi;
            yades := NextIterator(iterYades[i]);
            if i = 1 then
                base[i] := One(W);
            else
                base[i] := base[i - 1];
            fi;
            for j in [1 .. Length(yades)] do
                for terr in d[i,j] do
                    if IsPosInt(terr) then
                        gamma := terr;
                    else
                        gamma := SmallestMovedPoint(terr);
                    fi;
                    # Do not use multiplication
                    base[i] := base[i] * yades[j] ^ Embedding(W, gamma);
                od;
            od;
            if i = Length(d) then
                Add(rep, ConjugacyClass(W, base[i] * top));
            else
                i := i + 1;
            fi;
        od;
    od;
    return rep;
end);