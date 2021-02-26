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

InstallMethod( WreathCycleDecomposition,"generic wreath elements",true,[IsWreathCycle],1, function(x) return [x]; end);

InstallMethod( WreathCycleDecomposition,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local
      info,             # wreath product info
      decomposition,    # wreath cycle decomposition of x
      suppTop,          # support of top component, list
      suppBase,         # non-trivial base component indices, list
      id,               # identity vector
      i,                # index point, loop var
      wreathCycle,      # wreath cycle, loop var
      topCycleList,     # cycle decomposition of top component, list
      topCycle;         # cycle of top component, loop var

    # initialization
    info := FamilyObj(x)!.info;
    suppTop := MovedPoints(x![info.degI + 1]);
    suppBase := Filtered([1..info.degI], i -> x![i] <> One(info.groups[1]));
    id := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(id, One(info.groups[2]));
    decomposition := [];

    # wreath cycles that are of base type
    for i in Filtered(suppBase, x -> not x in suppTop) do
        wreathCycle := ShallowCopy(id);
        wreathCycle[i] := x![i];
        wreathCycle := Objectify(info.family!.defaultType,wreathCycle);

        SetIsSparseWreathCycle(wreathCycle,true);
        Add(decomposition, wreathCycle);
    od;

    # wreath cycles that are of top type
    if IsEmpty(suppTop) then
        return decomposition;
    fi;
    topCycleList := Cycles(x![info.degI + 1], suppTop);
    for topCycle in topCycleList do
        wreathCycle := ShallowCopy(id);
        wreathCycle[info.degI + 1] := CycleFromList(topCycle);
        for i in topCycle do
            wreathCycle[i] := x![i];
        od;
        wreathCycle := Objectify(info.family!.defaultType,wreathCycle);

        SetIsWreathCycle(wreathCycle,true);
        Add(decomposition, wreathCycle);
    od;

    return decomposition;
end);

InstallMethod( SparseWreathCycleDecomposition,"sparse wreath cycle wreath elements",true,[IsSparseWreathCycle],2, function(x) return [x]; end);

InstallMethod( SparseWreathCycleDecomposition,"wreath cycle wreath elements",true,[IsWreathCycle],1,
function(x)
    local info, yade, i, sparseWreathCycle;

    info := FamilyObj(x)!.info;
    yade := Yade(x);
    i := Maximum(Territory(x));
    sparseWreathCycle := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(sparseWreathCycle, x![info.degI + 1]);
    sparseWreathCycle[i] := yade;

    SetIsSparseWreathCycle(sparseWreathCycle, true);

    return [Objectify(info.family!.defaultType,sparseWreathCycle)];
end);

InstallMethod( SparseWreathCycleDecomposition,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, decomposition;

    info := FamilyObj(x)!.info;
    decomposition := WreathCycleDecomposition(x);
    return Concatenation(List(decomposition, SparseWreathCycleDecomposition));
end);

InstallMethod( ConjugatorWreathCycleToSparse,"sparse wreath cycle wreath elements",true,[IsSparseWreathCycle],2, function(x) return [One(x)]; end);

InstallMethod( ConjugatorWreathCycleToSparse,"wreath cycle wreath elements",true,[IsWreathCycle],1,
function(x)
    local info, i, j, max, yade, ord, k, y, conj;

    info := FamilyObj(x)!.info;
    ord := Order(x![info.degI + 1]);
    i := WPE_ChooseYadePoint(x);
    max := Maximum(Territory(x));
    yade := Yade(x);
    conj := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(conj, One(info.groups[2]));
    conj := Objectify(info.family!.defaultType,conj);
    y := One(info.groups[1]);
    j := i;
    for k in [1..ord] do
        y := x![j]^-1 * y;
        if j = max then
            y := y * yade;
        fi;
        j := i^(x![info.degI + 1]^k);
        conj![j] := y;
    od;

    return [conj];
end);

InstallMethod( ConjugatorWreathCycleToSparse,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, decomposition;

    info := FamilyObj(x)!.info;
    decomposition := WreathCycleDecomposition(x);
    return Concatenation(List(decomposition, ConjugatorWreathCycleToSparse));
end);

InstallTrueMethod( IsWreathCycle,IsSparseWreathCycle);
InstallTrueMethod( IsWreathProductElement,IsWreathCycle);

InstallMethod( IsWreathCycle,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, suppTop;
    info := FamilyObj(x)!.info;

    # wreath cycle of base type
    if IsOne(x![info.degI + 1]) then
        return Number([1..info.degI], i -> not IsOne(x![i])) = 1;
    fi;

    # wreath cycle of top type
    suppTop := MovedPoints(x![info.degI + 1]);
    if Length(CycleStructurePerm(x![info.degI + 1])) + 1 <> Length(suppTop) then
        return false;
    fi;
    return ForAll([1..info.degI], i -> i in suppTop or IsOne(x![i]));
end);

InstallMethod( IsSparseWreathCycle,"wreath cycle wreath elements",true,[IsWreathCycle],1,
function(x)
    local info, terr, max;

    info := FamilyObj(x)!.info;
    terr := Territory(x);
    max := Maximum(terr);
    return ForAll(terr, i -> i = max or IsOne(x![i]));
end);

InstallMethod( IsSparseWreathCycle,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    if IsWreathCycle(x) then
        return IsSparseWreathCycle(x);
    else
        return false;
    fi;
end);

InstallMethod( Territory,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, suppTop, suppBase;

    info := FamilyObj(x)!.info;
    suppTop := MovedPoints(x![info.degI + 1]);
    suppBase := Filtered([1..info.degI], i -> x![i] <> One(info.groups[1]));
    return DuplicateFreeList(Concatenation(suppTop, suppBase));
end);

InstallGlobalFunction( WPE_ChooseYadePoint,
function(x)
    return First(Territory(x));
end);

InstallMethod( Yade,"wreath cycle wreath elements",true,[IsWreathCycle],1,
function(x)
    return Yade(x, WPE_ChooseYadePoint(x));
end);

InstallOtherMethod( Yade,"wreath cycle wreath elements",true,[IsWreathCycle, IsInt],1,
function(x, i)
    local info, ord;

    if not i in Territory(x) then
        Error("i not in territory of x");
    fi;

    info := FamilyObj(x)!.info;
    ord := Order(x![info.degI + 1]);

    return Product([0..ord-1], k -> x![i^(x![info.degI + 1]^k)]);
end);

InstallMethod( Order,"wreath cycle wreath elements",true,[IsWreathCycle],1,
function(x)
    local info;

    info := FamilyObj(x)!.info;
    return Order(Yade(x)) * Order(x![info.degI + 1]);
end);

InstallMethod( Order,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, decomposition;

    info := FamilyObj(x)!.info;
    decomposition := WreathCycleDecomposition(x);
    if IsEmpty(decomposition) then
        return 1;
    fi;
    return Lcm(List(decomposition, Order));
end);

InstallGlobalFunction( TopComponentOfGenericWreathProductElement,
function(x)
    if not IsWreathProductElement(x) then
        return Error("x is not a wreath product element");
    fi;
    return WPE_TopComponent(x);
end);

InstallMethod( WPE_TopComponent, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    local info;

    info := FamilyObj(x)!.info;
    return x![info.degI + 1];
end);

InstallGlobalFunction( BaseComponentOfGenericWreathProductElement,
function(arg)
    local info, x, i;

    if Length(arg) > 2 then
        return Error("wrong number of arguments");
    fi;
    x := arg[1];
    if not IsWreathProductElement(x) then
        return Error("x is not a wreath product element");
    fi;
    info := FamilyObj(x)!.info;
    if Length(arg) = 1 then
        return WPE_BaseComponent(x);
    else
        i := arg[2];
        if not IsInt(i) then
            return Error("i must be an integer");
        fi;
        if i < 1 or i > info.degI then
        return Error("Index out of bounds");
        fi;
        return WPE_BaseComponent(x, i);
    fi;
end);


InstallMethod( WPE_BaseComponent, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    local info;

    info := FamilyObj(x)!.info;
    return List([1..info.degI], i -> x![i]);
end);


InstallOtherMethod( WPE_BaseComponent, "generic wreath elements and integer", true, [IsWreathProductElement, IsInt], 0,
function(x, i)
    local info;

    info := FamilyObj(x)!.info;
    return x![i];
end);
