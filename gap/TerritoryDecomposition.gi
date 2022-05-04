# `O(blockTopLength * nrOfBlocks)` many K-conjugacy problems.
BindGlobal( "WPE_PartitionDataOfBlockTopByYadeClass",
function(K, wDecompYade, blockTopStart, blockTopLength)
    local blockMapping, blockConjugator, blockPartition, blockRepresentativePos, i, j, zYade, rPos, rYade, c, x;
    # Maps each wreath cycle onto a block
    blockMapping := EmptyPlist(blockTopLength);
    # Stores the conjugating element from the representative onto the wreath cycle
    blockConjugator := EmptyPlist(blockTopLength);
    # Stores the size of each block
    blockPartition := EmptyPlist(blockTopLength); # list can be smaller
    # Stores for each block the position of the representative wreath cycle
    # relative to the block.
    blockRepresentativePos := EmptyPlist(blockTopLength); # list can be smaller
    for i in [1 .. blockTopLength] do
        zYade := wDecompYade[blockTopStart + i - 1];
        # Compare yade with existing block representatives
        for j in [1 .. Length(blockRepresentativePos)] do
            rPos := blockRepresentativePos[j];
            rYade := wDecompYade[blockTopStart + rPos - 1];
            x := RepresentativeAction(K, rYade, zYade);
            if x <> fail then
                blockMapping[i] := j;
                blockConjugator[i] := x;
                blockPartition[j] := blockPartition[j] + 1;
                break;
            fi;
        od;
        # We found a new block
        if not IsBound(blockMapping[i]) then
            j := Length(blockPartition) + 1;
            x := One(K);
            blockMapping[i] := j;
            blockConjugator[i] := x;
            Add(blockPartition, 1);
            Add(blockRepresentativePos, i);
        fi;
    od;
    return rec( blockPartition  := blockPartition,
                blockMapping    := blockMapping,
                blockConjugator := blockConjugator );
end);

# Partition a decomposition of w by load, i.e. by top cycle type and yade class.
BindGlobal( "WPE_PartitionDataOfWreathCycleDecompositionByLoad",
function(W, w, conjToSparse)
    local grps, K, wDecomp, l, wDecompTopType, wSortByTopType, wDecompYade, partition, wBlockConjugator, blockTopStart, blockTopEnd, pos, blockTopLength, wBlockTopPartitionData, wBlockTopPartition, wBlockTopMapping, wBlockTopConjugator, wSortByLoad;
    # Initilize Wreath Product Info
    # Let m be the degree of the Top Group
    grps := ComponentsOfWreathProduct(W);
    K := grps[1];
    # Compute wreath cycles `C(w) = {w_1 ... w_l}`.
    # `O(m)`
    wDecomp := ShallowCopy(WreathCycleDecomposition(w));
    l := Length(wDecomp);
    # Sort decomposition by top cycle type `o`.
    # `O(l log l)`
    wDecompTopType := List(wDecomp, z -> Order(WPE_TopComponent(z)));
    wSortByTopType := Sortex(wDecompTopType);
    wDecomp := Permuted(wDecomp, wSortByTopType);
    conjToSparse := Permuted(conjToSparse, wSortByTopType);
    # Compute Yade for each wreath cycle `w_i`.
    # `O(m)`
    wDecompYade := List(wDecomp, Yade);
    # We denote by `C(L, w)` the block of all wreath cycles in `w` with the same load `L`.
    # `partition` stores the sizes of each block `|C(L, w)|`.
    # We denote by `R(L, w)` the yade representative of the block `C(L, w)`,
    # i.e. the default yade of the first element of this block.
    partition := EmptyPlist(l);
    # This stores for each element `w_i` of a block `C(L, w)` an element `x_i` in `K`,
    # such that `R(L, w) ^ (x_i) = Yade(w_i)`.
    wBlockConjugator := EmptyPlist(l);
    # Sort decomposition by load.
    # For this we iterate over the top cycle types `o` and refine the block
    # `C(o, w) = {z = (f, h) in C(w) : |h| = o}` into a partition by Yade class.
    # `O(l * |L(w)|)` many K-conjugacy problems.
    blockTopStart := 1;
    while blockTopStart <= l do
        # Construct for fixed top cycle type
        blockTopEnd := l;
        for pos in [blockTopStart + 1 .. l] do
            if wDecompTopType[blockTopStart] <> wDecompTopType[pos] then
                blockTopEnd := pos - 1;
                break;
            fi;
        od;
        blockTopLength := blockTopEnd - blockTopStart + 1;
        # Refine blockTop into blocks by yade class,
        # i.e. we map each wreath cycle $w_i$ to a block `C(L, w)`.
        wBlockTopPartitionData := WPE_PartitionDataOfBlockTopByYadeClass(K, wDecompYade, blockTopStart, blockTopLength);
        wBlockTopPartition := wBlockTopPartitionData.blockPartition;
        wBlockTopMapping := wBlockTopPartitionData.blockMapping;
        wBlockTopConjugator := wBlockTopPartitionData.blockConjugator;
        # Partition blockTop of wDecomp
        wSortByLoad := Sortex(wBlockTopMapping);
        wDecomp{[blockTopStart .. blockTopEnd]} := Permuted(
            wDecomp{[blockTopStart .. blockTopEnd]}, wSortByLoad);
        wDecompYade{[blockTopStart .. blockTopEnd]} := Permuted(
            wDecompYade{[blockTopStart .. blockTopEnd]}, wSortByLoad);
        wBlockTopConjugator := Permuted(wBlockTopConjugator, wSortByLoad);
        conjToSparse{[blockTopStart .. blockTopEnd]} := Permuted(
            conjToSparse{[blockTopStart .. blockTopEnd]}, wSortByLoad);
        # Fill main data
        Append(partition, wBlockTopPartition);
        wBlockConjugator{[blockTopStart .. blockTopEnd]} := wBlockTopConjugator;
        blockTopStart := blockTopEnd + 1;
    od;
    return rec( partition           := partition,
                conjToSparse        := conjToSparse,
                wDecomp             := wDecomp,
                wDecompYade         := wDecompYade,
                wBlockConjugator    := wBlockConjugator );
end);
