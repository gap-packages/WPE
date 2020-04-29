#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#
# Implementations
#

InstallGlobalFunction( WPE_WreathCycleDecomposition,
function(G, rep)
    local info, decomposition, suppTop, suppBase, id, gamma, wreathCycle, permCycleList, permCycle;
    info := WreathProductInfo(G);
    suppTop := MovedPoints(rep[info.degI + 1]);
    suppBase := Filtered([1..info.degI], i -> rep[i] <> One(info.groups[1]));
    id := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(id, One(info.groups[2]));
    decomposition := [];
    for gamma in Filtered(suppBase, x -> not x in suppTop) do
        wreathCycle := ShallowCopy(id);
        wreathCycle[gamma] := rep[gamma];
        Add(decomposition, wreathCycle);
    od;
    permCycleList := Cycles(rep[info.degI + 1], suppTop);
    for permCycle in permCycleList do
        wreathCycle := ShallowCopy(id);
        wreathCycle[info.degI + 1] := CycleFromList(permCycle);
        for gamma in permCycle do
            wreathCycle[gamma] := rep[gamma];
        od;
        Add(decomposition, wreathCycle);
    od;
    return decomposition;
end);
