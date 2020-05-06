#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#
# Implementations
#

InstallMethod(PrintObj,"wreath elements",true,[IsWreathProductElement],1,
function(x)
local i,info;
  info:=FamilyObj(x)!.info;
  Print("WreathProductElement(");
  for i in [1..info!.degI] do
    Print(x![i]);
    if i < info!.degI then
        Print(",");
    fi;
  od;
  Print(";",x![info!.degI+1],")");
end);

InstallGlobalFunction( WPE_WreathCycleDecomposition,
function(x)
    local info, decomposition, suppTop, suppBase, id, gamma, wreathCycle, permCycleList, permCycle;

    info := FamilyObj(x)!.info;
    suppTop := MovedPoints(x![info.degI + 1]);
    suppBase := Filtered([1..info.degI], i -> x![i] <> One(info.groups[1]));
    id := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(id, One(info.groups[2]));
    decomposition := [];

    for gamma in Filtered(suppBase, x -> not x in suppTop) do
        wreathCycle := ShallowCopy(id);
        wreathCycle[gamma] := x![gamma];
        Add(decomposition, Objectify(info.family!.defaultType,wreathCycle));
    od;

    permCycleList := Cycles(x![info.degI + 1], suppTop);
    for permCycle in permCycleList do
        wreathCycle := ShallowCopy(id);
        wreathCycle[info.degI + 1] := CycleFromList(permCycle);
        for gamma in permCycle do
            wreathCycle[gamma] := x![gamma];
        od;
        Add(decomposition, Objectify(info.family!.defaultType,wreathCycle));
    od;

    return decomposition;
end);

InstallGlobalFunction( WPE_IsCagedCycle,
function(x)
    local info, suppTop, suppBase, counter, gamma;
    info := FamilyObj(x)!.info;

    if IsOne(x![info.degI + 1]) then
        return Number([1..info.degI], i -> not IsOne(x![i])) = 1;
    fi;

    suppTop := MovedPoints(x![info.degI + 1]);
    if Length(CycleStructurePerm(x![info.degI + 1])) + 1 <> Length(suppTop) then
        return false;
    fi;
    return ForAll([1..info.degI], gamma -> gamma in suppTop or IsOne(x![gamma]));
end);
