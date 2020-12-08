WPE_RepresentativeAction :=
function(x, y)
    local
        info, K, H, decompLength, nrBlocks,
        i, j, k, l, a, b, d, p, pMax, lp,
        xDecomp, xDecompYade, xDecompTopSuppLength, xSortByTopLength,
        yDecomp, yDecompYade, yDecompTopSuppLength, ySortByTopLength,
        partition, partitionConjugator, xBlockConjugator, yBlockConjugator,
        pos, blockTopStart, blockTopEnd, blockTopLength,
        xBlockTopMapping, xBlockTopPartition, xBlockTopConjugator, xBlockTopRepresentativePos, xSortByClass,
        yBlockTopMapping, yBlockTopPartition, yBlockTopConjugator, yBlockTopRepresentativePos, ySortByClass,
        blockMapping, blockPerm, blockConjugator,
        sourcePartitionInvariant, imagePartitionInvariant, shift, blockLength,
        h, h2, srcs, scrs2, imgs, S, S2, pi,
        ci, cBase, cTop;
    # initilize wreath product info
    info := FamilyObj(x)!.info;
    K := info.groups[1];
    H := info.groups[2];
    # compute wreath cycle decomposition
    xDecomp := WreathCycleDecomposition(x);
    yDecomp := WreathCycleDecomposition(y);
    decompLength := Length(xDecomp);
    # Is length of both decompositions equal?
    if decompLength <> Length(yDecomp) then return fail; fi;
    # Sorting permutation for decompositions by length of top cycles
    xDecompTopSuppLength := List(xDecomp, w -> Length(MovedPoints(Top(w))));
    yDecompTopSuppLength := List(yDecomp, w -> Length(MovedPoints(Top(w))));
    xSortByTopLength := Sortex(xDecompTopSuppLength);
    ySortByTopLength := Sortex(yDecompTopSuppLength);
    # Are top decompositions equal?
    if xDecompTopSuppLength <> yDecompTopSuppLength then return fail; fi;
    # Sort decompositions by length of top cycles, i.e.\ by cycle type
    xDecomp := Permuted(xDecomp, xSortByTopLength);
    yDecomp := Permuted(yDecomp, ySortByTopLength);
    # Next we partition the decomposition by top cycle type and yade class
    xDecompYade := List(xDecomp, Yade);
    yDecompYade := List(yDecomp, Yade);
    # This stores the block lengths of blocks xB(top)_j and yB(top)_j.
    # We denote by R(xB(top)_j) the yade representative of this block,
    # i.e. the default yade of the first element of this block.
    partition := [];
    # This stores for each pair of blocks xB(top)_j and yB(top)_j an element c_j,
    # such that R(xB(top)_j) ^ (c_j) = R(yB(top)_j).
    partitionConjugator := [];
    # This stores for each element w_i of a block $R(xB(top)_j)$ an element c_i in K,
    # such that $R(xB(top)_j) ^ (c_i) = Yade(w_i).
    xBlockConjugator := ListWithIdenticalEntries(decompLength, One(K));
    yBlockConjugator := ListWithIdenticalEntries(decompLength, One(K));
    blockTopStart := 1;
    # Construct for each top cycle type the blocks xB(top)_j and yB(top)_j.
    while blockTopStart <= decompLength do
        # blockTop is decomp{[blockTopStart .. blockTopEnd]}
        blockTopEnd := decompLength;
        for pos in [blockTopStart + 1 .. decompLength] do
            if xDecompTopSuppLength[blockTopStart] <> xDecompTopSuppLength[pos] then
                blockTopEnd := pos - 1;
                break;
            fi;
        od;
        blockTopLength := blockTopEnd - blockTopStart + 1;
        # refine blockTop into blocks by yade class,
        # i.e. we map each wreath cycle $w_i$ to a block xB(top)_j
        xBlockTopMapping := ListWithIdenticalEntries(blockTopLength, 0);
        xBlockTopPartition := [];
        xBlockTopConjugator := ListWithIdenticalEntries(blockTopLength, One(K));
        xBlockTopRepresentativePos := [];
        WPE_RepresentativeAction_PartitionBlockTopByYadeClass(
            K, xDecompYade, blockTopStart,
            xBlockTopMapping, xBlockTopPartition, xBlockTopRepresentativePos, xBlockTopConjugator);
        # refine blockTop into blocks by yade class,
        # i.e. we map each wreath cycle $w_i$ to a block yB(top)_j
        yBlockTopMapping := ListWithIdenticalEntries(blockTopLength, 0);
        yBlockTopPartition := [];
        yBlockTopConjugator := ListWithIdenticalEntries(blockTopLength, One(K));
        yBlockTopRepresentativePos := [];
        WPE_RepresentativeAction_PartitionBlockTopByYadeClass(
            K, yDecompYade, blockTopStart,
            yBlockTopMapping, yBlockTopPartition, yBlockTopRepresentativePos, yBlockTopConjugator);
        # Do xBlockTop and yBlockTop have same amount of blocks?
        nrBlocks := Length(xBlockTopPartition);
        if nrBlocks <> Length(yBlockTopPartition) then return fail; fi;
        # Sort xDecomp by xBlockTop
        xSortByClass := Sortex(xBlockTopMapping);
        xDecomp{[blockTopStart .. blockTopEnd]} := Permuted(
            xDecomp{[blockTopStart .. blockTopEnd]}, xSortByClass);
        xDecompYade{[blockTopStart .. blockTopEnd]} := Permuted(
            xDecompYade{[blockTopStart .. blockTopEnd]}, xSortByClass);
        xBlockTopConjugator := Permuted(xBlockTopConjugator, xSortByClass);
        # Compute mapping from xBlockTop to yBlockTop, such that each block corresponds to same yade class
        blockMapping := WPE_RepresentativeAction_BlockMapping(
            K, nrBlocks, blockTopStart,
            xDecompYade, xBlockTopPartition,
            yDecompYade, yBlockTopPartition, yBlockTopRepresentativePos);
        if blockMapping = fail then return fail; fi;
        # Rename blocks in yBlock, such that block xB_i corresponds to yB_i
        blockPerm := blockMapping[1]^(-1);
        yBlockTopMapping := OnTuples(yBlockTopMapping, blockPerm);
        yBlockTopPartition := Permuted(yBlockTopPartition, blockPerm);
        # Sort yDecomp with trivial top by yade class
        ySortByClass := Sortex(yBlockTopMapping);
        yDecomp{[blockTopStart .. blockTopEnd]} := Permuted(
            yDecomp{[blockTopStart .. blockTopEnd]}, ySortByClass);
        yDecompYade{[blockTopStart .. blockTopEnd]} := Permuted(
            yDecompYade{[blockTopStart .. blockTopEnd]}, ySortByClass);
        yBlockTopConjugator := Permuted(yBlockTopConjugator, ySortByClass);
        # Fill main data
        Append(partition, xBlockTopPartition);
        Append(partitionConjugator, blockMapping[2]);
        xBlockConjugator{[blockTopStart .. blockTopEnd]} := xBlockTopConjugator;
        yBlockConjugator{[blockTopStart .. blockTopEnd]} := yBlockTopConjugator;
        blockTopStart := blockTopEnd + 1;
    od;
    # Try to compute a suitable top cycle for the conjugator c
    sourcePartitionInvariant := ListWithIdenticalEntries(Length(partition), 0);
    imagePartitionInvariant := ListWithIdenticalEntries(Length(partition), 0);
    shift := 0;
    for k in [1 .. Length(partition)] do
        blockLength := partition[k];
        if Top(xDecomp[shift + 1]) = One(H) then
            sourcePartitionInvariant[k] := Set(List([1 .. blockLength], i -> Territory(xDecomp[shift + i])[1]));
            imagePartitionInvariant[k] := Set(List([1 .. blockLength], i -> Territory(yDecomp[shift + i])[1]));
        else
            sourcePartitionInvariant[k] := Set(List([1 .. blockLength], i -> Top(xDecomp[shift + i])));
            imagePartitionInvariant[k] := Set(List([1 .. blockLength], i -> Top(yDecomp[shift + i])));
        fi;
        shift := shift + blockLength;
    od;
    # Unfortunately this is slow in GAP
    #cTop := RepresentativeAction(H, sourcePartitionInvariant, imagePartitionInvariant, OnTuplesSets);
    #if cTop = fail then return fail; fi;
    cTop := ();
    S := H;
    srcs := sourcePartitionInvariant;
    imgs := imagePartitionInvariant;
    for i in [1 .. Length(srcs)] do
        if IsPerm(srcs[i][1]) then
            for pi in SymmetricGroup(Length(srcs[i])) do
                h := ();
                S2 := S;
                srcs2 := srcs;
                detectedFail := false;
                for j in [1 .. Length(srcs[i])] do
                    h2 := RepresentativeAction(S2, srcs2[i][j], imgs[i][j ^ pi], OnPoints);
                    if h2 = fail then
                        detectedFail := true;
                        break;
                    fi;
                    h := h * h2;
                    srcs2 := OnTuplesSets(srcs2, h2);
                    S2 := Stabilizer(S2, srcs2[i][j], OnPoints);
                od;
                if detectedFail = true then continue; fi;
                # no fail detected
                cTop := cTop * h;
                srcs := srcs2;
                S := S2;
                break;
            od;
        else
            h := RepresentativeAction(S, srcs[i], imgs[i], OnSets);
            if h = fail then return fail; fi;
            cTop := cTop * h;
            srcs := OnTuplesSets(srcs, h);
            S := Stabilizer(S, srcs[i], OnSets);
        fi;
    od;
    # Now construct the base component for the conjugator c
    cBase := ListWithIdenticalEntries(info!.degI, One(K));
    shift := 0;
    for k in [1 .. Length(partition)] do
        blockLength := partition[k];
        for a in [1 .. blockLength] do
            i := WPE_ChooseYadePoint(xDecomp[shift + a]);
            j := i ^ cTop;
            b := First([1 .. blockLength], b -> j in Territory(yDecomp[shift + b]));
            ci := xBlockConjugator[shift + a] ^ (-1) * partitionConjugator[k] * yBlockConjugator[shift + b];
            if Top(xDecomp[shift + a]) = One(H) then
                cBase[i] := ci;
            else
                l := WPE_ChooseYadePoint(yDecomp[shift + b]);
                pMax := Order(Top(yDecomp[shift + b])) - 1;
                lp := l;
                for p in [0 .. pMax] do
                    if lp = j then
                        break;
                    fi;
                    ci := ci * Base(yDecomp[shift + b], lp);
                    lp := lp ^ Top(yDecomp[shift + b]);
                od;
                for d in [1 .. NrMovedPoints(Top(xDecomp[shift + a]))] do
                    cBase[i] := ShallowCopy(ci);
                    ci := Base(xDecomp[shift + a], i) ^ (-1) * ci * Base(yDecomp[shift + b], j);
                    i := i ^ Top(xDecomp[shift + a]);
                    j := j ^ Top(yDecomp[shift + b]);
                od;
            fi;
        od;
        shift := shift + blockLength;
    od;
    return Objectify(info.family!.defaultType, Concatenation(cBase, [cTop]));
end;

#
# K                      : base group factor of wreath product K wr H
# decompYade             : list of length l, elements of K,
#                          we suppose that the i-th element corresponds to Yade(w_i),
#                          where w_i is a wreath cycle
# block                  : list of length l, integers
# blockLength            : empty list, integers
# blockRepresentativePos : empty list, integers
# blockConjugator        : list of length l, elements of K
#
# This function sets the lists block, blockLength, blockRepresentativePos and blockConjugator as follows:
#
# block                  : maps i-th wreath cycle w_i to j-th block B(w_i) = B_j
# blockLength            : maps j-th block B_j to length |B_j|
# blockRepresentativePos : maps j-th block B_j to position of representative r = R(B_j) in decompYade
# blockConjugator        : maps i-th wreath cycle w_i to conjugator c_i
#                          from Yade(r) to Yade(w_i) where r ist the representative r = R(B(w_i))
#
# This function partitions wreath cycles by yade class.
# We say that two wreath cycles w, v are in the same yade class,
# if the yade elements are conjugate in K.
# For each block B_j we mark the first element as the unique representative r = R(B_j)
# and for each element $w_i$ in the block we store an element c_i of K, that maps Yade(r) to Yade(w_i).
WPE_RepresentativeAction_PartitionBlockTopByYadeClass :=
function(K, decompYade, blockStart, blockMapping, blockPartition, blockRepresentativePos, blockConjugator)
    local i, j, wYade, rPos, rYade, c;
    for i in [1 .. Length(blockMapping)] do
        wYade := decompYade[blockStart + i - 1];
        # search for an existing block
        for j in [1 .. Length(blockRepresentativePos)] do
            rPos := blockRepresentativePos[j];
            rYade := decompYade[blockStart + rPos - 1];
            c := RepresentativeAction(K, rYade, wYade);
            if c <> fail then
                blockMapping[i] := j;
                blockConjugator[i] := c;
                blockPartition[j] := blockPartition[j] + 1;
                break;
            fi;
        od;
        # we found a new block
        if blockMapping[i] = 0 then
            j := Length(blockRepresentativePos) + 1;
            c := One(K);
            blockMapping[i] := j;
            blockConjugator[i] := c;
            Add(blockPartition, 1);
            Add(blockRepresentativePos, i);
        fi;
    od;
end;

#
# K                       : base group factor of wreath product K wr H
# nrBlocks                : integer, number of blocks
# blockStart              : integer, starting position of blocks
# xDecompYade             : list of length l, elements of K
# xBlockPartition         : list of length nrBlocks, integers
# yDecompYade             : list of length l, elements of K
# yBlockPartition         : list of length nrBlocks, integers
# yBlockRepresentativePos : list of length nrBlocks, integers
#
# This functions return either fail or [blockPerm, blockConjugator] such that
# xB[j] and yB[j ^ blockPerm] have equal yade class
# and R(xB[j]) ^ blockConjugator[j] = R(yB[j ^ blockPerm])
WPE_RepresentativeAction_BlockMapping :=
function(K, nrBlocks, blockStart, xDecompYade, xBlockPartition, yDecompYade, yBlockPartition, yBlockRepresentativePos )
    local blockPerm, blockConjugator, possibleImages, j, k, vPos, vBlockLength, vYade, wPos, wBlockLength, wYade, c;
    blockPerm := ListWithIdenticalEntries(nrBlocks, 0);
    blockConjugator := ListWithIdenticalEntries(nrBlocks, One(K));
    possibleImages := [1 .. nrBlocks];
    vPos := 1;
    vBlockLength := 0;
    for j in [1 .. nrBlocks] do
        vPos := vPos + vBlockLength;
        vBlockLength := xBlockPartition[j];
        vYade := xDecompYade[blockStart + vPos - 1];
        for k in possibleImages do
            wPos := yBlockRepresentativePos[k];
            if vBlockLength <> yBlockPartition[k] then continue; fi;
            wYade := yDecompYade[blockStart + wPos - 1];
            c := RepresentativeAction(K, vYade, wYade);
            if c <> fail then
                blockPerm[j] := k;
                blockConjugator[j] := c;
                Remove(possibleImages, k);
                break;
            fi;
        od;
        if blockPerm[j] = 0 then return fail; fi;
    od;
    return [PermList(blockPerm), blockConjugator];
end;
