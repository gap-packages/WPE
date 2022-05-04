BindGlobal( "WPE_ConjugacyClassesWithFixedTopClass",
function(W, H, RK, RH, hElm)
    local r, m, h, cycles, cycleLength, l, fixPoints, omega, i, j, k, s,
          parts, part, blockStart, blockEnd, preTerritoryDecomposition,
          delta, deltaPoint, d, Ch, translations, gensD, D, shift,
          gensP, P, c, sigmaImage, sigma, points, point, arr, reps,
          iter, block, blockLength, repPoints, p, IsPointAvailable,
          rep, top, base, iterYades, yades, terr, gamma, combi;
    ############
    # Approach #
    ############
    #
    # Idea for Reduction of orbit space:
    # We need to compute orbit representatives for the action of $C_{H}(h)$ on
    # the set of all territory decompositions of elements of $W$ with top component $h$.
    # In the following we omit repeating the assumptions on the considered territory decompositions.
    #
    # Notation:
    # Fix an ordering on the conjugacy class representatives of $K$ by $k_1, ..., k_r$.
    # Let h_i = [h_{i,1}, h_{i,2}, ...] be the list of all cycle supports of $h$ on $Gamma$ of length $i$.
    # For example let $Gamma = {1, ..., 11}$ and $h = (2,3)(4,6)(10,11)$. Then
    # $h_1 = [{1}, {5}, {7}, {8}, {9}]$,
    # $h_2 = [{2,3}, {4,6}, {10,11}]$.
    # Define the projection $Psi : C_{Sym(Gamma)}(h) -> Sym(h_1) x Sym(h_2) x Sym(h_3) x ...$
    # by the action of the centraliser on the cycle supports of $h$.
    # We abuse notation and identify $Sym(h_i)$ with $Sym(|h_i|)$.
    #
    # Reduction Step 1: Forget yade class distribution.
    # Given a territory decomposition $P$, this must induce uniquely
    # an ordered multipartition $M$ of $h_1 u h_2 u h_3 u ...$
    # by specifying that it must respect the ordering
    # of the distribution of yade classes onto each block.
    # In the following we omit repeating the assumptions on the considered
    # ordered multipartitions and distributions of yade classes.
    # We have a 1-to-1-mapping from tuples consisting of
    # an ordered multipartition and a yade distribution, onto territory decompositions.
    # For example consider the territory decomposition
    #     [ [   k_1,          k_3,          k_4   ], [         k_1,           k_4    ] ]
    # T = [ [ { {5} }, { {1}, {7}, {9} }, { {8} } ], [ { {2,3}, {10,11} }, { {4,6} } ] ].
    # The induced ordered multipartition of $T$ is given by
    # M = [ [ { {5} }, { {1}, {7}, {9} }, { {8} } ], [ { {2,3}, {10,11} }, { {4,6} } ] ]
    # and the yade distribution is given by
    # Y = [ [   k_1,          k_3,          k_4   ], [         k_1,           k_4    ] ].
    # If two territory decompositions are in the same orbit under the action of $C_{H}(h)$,
    # then the induced multipartitions are in the same orbit under the action of $[C_{H}(h)]Psi$.
    # If two ordered multipartitions are in the same orbit under the action of $[C_{H}(h)]Psi$,
    # then, given a fixed yade distribution,
    # the corresponding territory decompositions are in the same orbit under the action of $C_{H}(h)$.
    #
    # Summary for Step 1:
    # Orbits of territory decompositions under the action of $C_{H}(h)$
    # can be enumerated by computing orbits of ordered multipartitions under the action of $[C_{H}(h)]Psi$.
    #
    # Reduction Step 2: Forget ordering of multipartition.
    # We call a multipartition of $|h_1| + |h_2| + |h_3| + ...$ a pattern of $h$ with respect to $Gamma$.
    # Given a pattern $p$, we define (weak) $p$-multipartitions as the set of all
    # ordered multipartitions of $h_1 u h_2 u h_3 u ...$ that induce this pattern
    # by mapping each block onto its size (after a suitable stable re-ordering of blocks).
    # We have a 1-to-1-mapping from tuples consisting of
    # a $p$-multipartition and a combination of $p$, onto weak $p$-multipartitions.
    # For example consider the pattern $p = [[3, 1, 1], [2, 1]]$.
    # Then we have a weak $p$-multipartition given by
    # M = [ [ { {5} }, { {1}, {7}, {9} }, { {8} } ], [ { {2,3}, {10,11} }, { {4,6} } ] ]
    # and the corresponding $p$-multipartition is
    # P = [ [ { {1}, {7}, {9} }, { {5} }, { {8} } ], [ { {2,3}, {10,11} }, { {4,6} } ] ]
    # with combination $C = [[1, 3, 1], [2, 1]]$.
    # If two weak $p$-multipartitions are in the same orbit under the action of $[C_{H}(h)]Psi$,
    # then the induced $p$-multipartitions are in the same orbit under the action of $[C_{H}(h)]Psi$.
    # If two $p$-multipartitions are in the same orbit under the action of $[C_{H}(h)]Psi$,
    # then given any combination of $p$, the induced weak $p$-multipartitions
    # are in the same orbit under the action of $[C_{H}(h)]Psi$.
    #
    # Summary for Step 2:
    # Orbits of ordered multipartitions under the action of $C_{H}(h)$
    # can be enumerated by computing orbits of weak $p$-multipartitions under the action of $C_{H}(h)$
    # for all patterns $p$ of $h$ with respect to $Gamma$.
    # Orbits of weak $p$-multipartitions under the action of $[C_{H}(h)]Psi$
    # can be enumerated by computing orbits of $p$-multipartitions under the action of $[C_{H}(h)]Psi$.
    #
    # Remarks:
    # In our computations we often concatenate all partitions in a multipartition,
    # since GAP can work with partitions (OnTuplesSets)
    # faster than with multipartitions (OnTuplesTuplesSets).
    # The considered centraliser automatically respects the multipartition structure.
    # Thus we sometimes omit the prefix "multi" in further comments.
    #
    ##################
    # Initialization #
    ##################
    r := Length(RK);
    m := NrMovedPoints(H);
    m := Maximum(1, m);
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
    ############
    # Approach #
    ############
    #
    # Idea for exploiting Reduction Step 2:
    # Given a pattern $p$ of $h \in H$ with respect to $Gamma$,
    # we want to compute orbit representatives for the action of $[C_{H}(h)]Psi$ on $p$-multipartitions.
    # We define the standard $p$-multipartition by mapping the sequence $1 ... |h_1| + |h_2| + ...$
    # onto an ordered multipartition with block sizes induced by $p$.
    # For example consider the pattern $p = [[3, 1, 1], [2, 1]]$.
    # The standard partition would be given by
    # $[ [ {  1,   2,   3  }, {  4  }, {  5  } ], [ {   6,     7   }, {    8    } ] ]$, which we identify with
    # $[ [ { {1}, {5}, {7} }, { {8} }, { {9} } ], [ { {2,3}, {4,6} }, { {10,11} } ] ]$.
    # Let $omega$ be the standard partition of the pattern $p$.
    # Then $[C_{Sym(Gamma)}(h)]Psi$ acts transitively on $p$-multipartitions.
    # Let $R$ be a collection of inverse representatives
    # of the right cosets of $[C_{Sym(Gamma)}(h)]Psi / [C_{H}(h)]Psi$,
    # i.e. we have $[C_{Sym(Gamma)}(h)]Psi = U_{r \in R} [C_{H}(h)]Psi r ^ {-1}$.
    # Let $gamma$ be an arbitrary partition.
    # Then there exists $c \in [C_{Sym(Gamma)}(h)]Psi$, s.t. $gamma ^ c = omega$.
    # Further there exists $r \in R$ and $c_h \in [C_{H}(h)]Psi$, s.t. $c = c_h ^ {-1} r ^ {-1}$.
    #
    #              c
    #    omega◄──────────gamma
    #      │               ▲
    #      │               │
    #     r│               │c_h
    #      │               │
    #      └───► delta─────┘
    #
    # Hence $Delta = {omega ^ r : r \in R}$ is a superset of orbit representatives
    # for the action of $[C_{H}(h)]Psi$ on $p$-multipartitions.
    #
    # Summary:
    # A superset of orbit representatives for the action of $[C_{H}(h)]Psi$ on $p$-multipartitions
    # can be enumerated by computing right coset representatives of $[C_{Sym(Gamma)}(h)]Psi / [C_{H}(h)]Psi$.
    #
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
        # Right coset representatives, we have to take inverses
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
                    if RepresentativeAction(P, Concatenation(points[i]), Concatenation(points[j]),
                                            OnTuplesSets) <> fail then
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
                            j := First([1 .. Length(point[i])],
                                       j -> IsPointAvailable[i, j] and Length(point[i, j]) = blockLength);
                            IsPointAvailable[i, j] := false;
                            Add(deltaPoint[i], h[i]{OnTuples(point[i, j], translations[i] ^ -1)});
                        od;
                    od;
                    Add(delta, deltaPoint);
                od;
            od;
        od;
    fi;
    #
    # Idea for exploiting Reduction Step 1:
    # Transform these partitions into all possible territory decompositions,
    # i.e. choose an explicit distribution of yade classes for each partition.
    #
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
                    # TODO: Do not use multiplication
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

BindGlobal( "WPE_ConjugacyClasses",
function(W)
    local grps, K, H, RK, RH, RW;
    grps := ComponentsOfWreathProduct(W);
    K := grps[1];
    H := grps[2];
    RK := List(ConjugacyClasses(K), Representative);
    RH := List(ConjugacyClasses(H), Representative);
    RW := List(RH, h -> WPE_ConjugacyClassesWithFixedTopClass(W, H, RK, RH, h));
    return Concatenation(RW);
end);
