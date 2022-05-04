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
# This functions return either fail or rec(blockPerm, blockConjugator) such that
# xB[j] and yB[j ^ blockPerm] have equal yade class
# and R(xB[j]) ^ blockConjugator[j] = R(yB[j ^ blockPerm])
BindGlobal( "WPE_RepresentativeAction_BlockMapping",
function(K, nrBlocks, blockStart, xDecompYade, xBlockPartition, yDecompYade, yBlockPartition, yBlockRepresentativePos )
    local blockPerm, blockConjugator, possibleImages, j, k, kPos, vPos, vBlockLength, vYade, wPos, wBlockLength, wYade, c;
    blockPerm := ListWithIdenticalEntries(nrBlocks, 0);
    blockConjugator := ListWithIdenticalEntries(nrBlocks, One(K));
    possibleImages := [1 .. nrBlocks];
    vPos := 1;
    vBlockLength := 0;
    for j in [1 .. nrBlocks] do
        vPos := vPos + vBlockLength;
        vBlockLength := xBlockPartition[j];
        vYade := xDecompYade[blockStart + vPos - 1];
        for kPos in [1 .. Length(possibleImages)] do
            k := possibleImages[kPos];
            wPos := yBlockRepresentativePos[k];
            if vBlockLength <> yBlockPartition[k] then
                continue;
            fi;
            wYade := yDecompYade[blockStart + wPos - 1];
            c := RepresentativeAction(K, vYade, wYade);
            if c <> fail then
                blockPerm[j] := k;
                blockConjugator[j] := c;
                Remove(possibleImages, kPos);
                break;
            fi;
        od;
        if blockPerm[j] = 0 then
            return fail;
        fi;
    od;
    return rec(blockPerm := PermList(blockPerm), blockConjugator := blockConjugator);
end);

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
BindGlobal( "WPE_RepresentativeAction_PartitionBlockTopByYadeClass",
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
end);

BindGlobal( "WPE_RepresentativeAction_PartitionByTopAndYadeClass",
function(K, x, y)
    local
        i, j, k, l, a, b, d, p, pMax, lp,
        decompLength, nrBlocks,
        xDecomp, xDecompYade, xDecompTopSuppLength, xSortByTopLength,
        yDecomp, yDecompYade, yDecompTopSuppLength, ySortByTopLength,
        partition, partitionConjugator, xBlockConjugator, yBlockConjugator,
        pos, blockTopStart, blockTopEnd, blockTopLength,
        xBlockTopMapping, xBlockTopPartition, xBlockTopConjugator, xBlockTopRepresentativePos, xSortByClass,
        yBlockTopMapping, yBlockTopPartition, yBlockTopConjugator, yBlockTopRepresentativePos, ySortByClass,
        blockMapping, blockPerm, blockConjugator;
    # compute wreath cycle decomposition
    xDecomp := WreathCycleDecomposition(x);
    yDecomp := WreathCycleDecomposition(y);
    decompLength := Length(xDecomp);
    # Is length of both decompositions equal?
    if decompLength <> Length(yDecomp) then
        return fail;
    fi;
    # Sorting permutation for decompositions by length of top cycles
    xDecompTopSuppLength := List(xDecomp, w -> Length(MovedPoints(WPE_TopComponent(w))));
    yDecompTopSuppLength := List(yDecomp, w -> Length(MovedPoints(WPE_TopComponent(w))));
    xSortByTopLength := Sortex(xDecompTopSuppLength);
    ySortByTopLength := Sortex(yDecompTopSuppLength);
    # Are top decompositions equal?
    if xDecompTopSuppLength <> yDecompTopSuppLength then
        return fail;
    fi;
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
        if nrBlocks <> Length(yBlockTopPartition) then
            return fail;
        fi;
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
        if blockMapping = fail then
            return fail;
        fi;
        # Rename blocks in yBlock, such that block xB_i corresponds to yB_i
        blockPerm := blockMapping.blockPerm^(-1);
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
        Append(partitionConjugator, blockMapping.blockConjugator);
        xBlockConjugator{[blockTopStart .. blockTopEnd]} := xBlockTopConjugator;
        yBlockConjugator{[blockTopStart .. blockTopEnd]} := yBlockTopConjugator;
        blockTopStart := blockTopEnd + 1;
    od;
    return rec(xDecomp := xDecomp, yDecomp := yDecomp,
               partition := partition, partitionConjugator := partitionConjugator,
               xBlockConjugator := xBlockConjugator, yBlockConjugator := yBlockConjugator);
end);

BindGlobal( "WPE_RepresentativeAction_Top",
function(H, x, y, xDecomp, yDecomp, partition)
    local shift, blockLength, k, j, source, image, t, c, xTop, yTop;

    if IsNaturalSymmetricGroup(H) then
        source := EmptyPlist(NrMovedPoints(H));
        image := EmptyPlist(NrMovedPoints(H));
        shift := 0;
        for k in [1 .. Length(partition)] do
            blockLength := partition[k];
            for j in [1 .. blockLength] do
                xTop := WPE_TopComponent(xDecomp[shift + j]);
                if IsOne(xTop) then
                    Add(source, Territory(xDecomp[shift + j])[1]);
                    Add(image, Territory(yDecomp[shift + j])[1]);
                else
                    yTop := WPE_TopComponent(yDecomp[shift + j]);
                    Append(source, Cycles(xTop, MovedPoints(xTop))[1]);
                    Append(image, Cycles(yTop, MovedPoints(yTop))[1]);
                fi;
            od;
            shift := shift + blockLength;
        od;
        return MappingPermListList(source, image);
    else
        t := RepresentativeAction(H, WPE_TopComponent(x), WPE_TopComponent(y));
        if t = fail then
            return fail;
        fi;
        source := EmptyPlist(Length(partition));
        image := EmptyPlist(Length(partition));
        shift := 0;
        for k in [1 .. Length(partition)] do
            blockLength := partition[k];
            source[k] := Union(List([1 .. blockLength], j -> Set(Territory(xDecomp[shift + j]))));
            image[k] := Union(List([1 .. blockLength], j -> Set(Territory(yDecomp[shift + j]))));
            shift := shift + blockLength;
        od;
        c := RepresentativeAction(Centraliser(H, WPE_TopComponent(x)), source, OnTuplesSets(image, t ^ -1), OnTuplesSets);
        if c = fail then
            return fail;
        fi;
        return c * t;
    fi;
end);

BindGlobal( "WPE_RepresentativeAction_Base",
function(cTop, degreeOfH, K, xDecomp, yDecomp, partition, partitionConjugator, xBlockConjugator, yBlockConjugator)
    local cBase, shift, blockLength, a, b, i, j, ci, l, p, pMax, lp, d, k;
    cBase := ListWithIdenticalEntries(degreeOfH, One(K));
    shift := 0;
    for k in [1 .. Length(partition)] do
        blockLength := partition[k];
        for a in [1 .. blockLength] do
            i := WPE_ChooseYadePoint(xDecomp[shift + a]);
            j := i ^ cTop;
            b := First([1 .. blockLength], b -> j in Territory(yDecomp[shift + b]));
            ci := xBlockConjugator[shift + a] ^ (-1) * partitionConjugator[k] * yBlockConjugator[shift + b];
            if WPE_TopComponent(xDecomp[shift + a]) = () then
                cBase[i] := ci;
            else
                l := WPE_ChooseYadePoint(yDecomp[shift + b]);
                pMax := Order(WPE_TopComponent(yDecomp[shift + b])) - 1;
                lp := l;
                for p in [0 .. pMax] do
                    if lp = j then
                        break;
                    fi;
                    ci := ci * WPE_BaseComponent(yDecomp[shift + b], lp);
                    lp := lp ^ WPE_TopComponent(yDecomp[shift + b]);
                od;
                for d in [1 .. NrMovedPoints(WPE_TopComponent(xDecomp[shift + a]))] do
                    cBase[i] := ShallowCopy(ci);
                    ci := WPE_BaseComponent(xDecomp[shift + a], i) ^ (-1) * ci * WPE_BaseComponent(yDecomp[shift + b], j);
                    i := i ^ WPE_TopComponent(xDecomp[shift + a]);
                    j := j ^ WPE_TopComponent(yDecomp[shift + b]);
                od;
            fi;
        od;
        shift := shift + blockLength;
    od;
    return cBase;
end);

#
# Returns either an element c such that x^c = y or fail if x and y are not conjugate.
#
BindGlobal( "WPE_RepresentativeAction",
function(W, x, y)
    local
        degI, grps, K, H, partitionData, xDecomp, yDecomp, partition, partitionConjugator, xBlockConjugator, yBlockConjugator,
        topConditionsData, sourcePartitionInvariant, imagePartitionInvariant, cTop, cBase;
    # initilize wreath product info
    degI := WPE_TopDegree(W);
    grps := ComponentsOfWreathProduct(W);
    K := grps[1];
    H := grps[2];
    # partition wreath cycle decompositions by top length and yade class
    partitionData := WPE_RepresentativeAction_PartitionByTopAndYadeClass(K, x, y);
    if partitionData = fail then
        return fail;
    fi;
    xDecomp := partitionData.xDecomp;
    yDecomp := partitionData.yDecomp;
    partition := partitionData.partition;
    partitionConjugator := partitionData.partitionConjugator;
    xBlockConjugator := partitionData.xBlockConjugator;
    yBlockConjugator := partitionData.yBlockConjugator;
    # compute top cTop of conjugator
    cTop := WPE_RepresentativeAction_Top(H, x, y, xDecomp, yDecomp, partition);
    if cTop = fail then
        return fail;
    fi;
    # construct the base component for the conjugator c
    cBase := WPE_RepresentativeAction_Base(cTop, degI, K, xDecomp, yDecomp, partition, partitionConjugator,
                                           xBlockConjugator, yBlockConjugator);
    return WreathProductElementList(W, Concatenation(cBase, [cTop]));
end);