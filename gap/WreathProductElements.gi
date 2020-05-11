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

InstallMethod( CagedCycleDecomposition,"generic wreath elements",true,[IsCagedCycle],1, function(x) return [x]; end);

InstallMethod( CagedCycleDecomposition,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local 
      info,             # wreath product info
      decomposition,    # caged cycle decomposition of x
      suppTop,          # support of top component, list
      suppBase,         # non-trivial base component indices, list
      id,               # identity vector
      i,                # index point, loop var
      cagedCycle,       # caged cycle, loop var 
      topCycleList,     # cycle decomposition of top component, list
      topCycle;         # cycle of top component, loop var

    # initialization
    info := FamilyObj(x)!.info;
    suppTop := MovedPoints(x![info.degI + 1]);
    suppBase := Filtered([1..info.degI], i -> x![i] <> One(info.groups[1]));
    id := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(id, One(info.groups[2]));
    decomposition := [];

    # caged cycles that are of base type
    for i in Filtered(suppBase, x -> not x in suppTop) do
        cagedCycle := ShallowCopy(id);
        cagedCycle[i] := x![i];
        cagedCycle := Objectify(info.family!.defaultType,cagedCycle);

        SetIsNormalCycle(cagedCycle,true);
        Add(decomposition, cagedCycle);
    od;

    # caged cycles that are of top type
    if IsEmpty(suppTop) then
        return decomposition;
    fi;
    topCycleList := Cycles(x![info.degI + 1], suppTop);
    for topCycle in topCycleList do
        cagedCycle := ShallowCopy(id);
        cagedCycle[info.degI + 1] := CycleFromList(topCycle);
        for i in topCycle do
            cagedCycle[i] := x![i];
        od;
        cagedCycle := Objectify(info.family!.defaultType,cagedCycle);

        SetIsCagedCycle(cagedCycle,true);
        Add(decomposition, cagedCycle);
    od;

    return decomposition;
end);

InstallMethod( NormalCycleDecomposition,"normal cycle wreath elements",true,[IsNormalCycle],2, function(x) return [x]; end);

InstallMethod( NormalCycleDecomposition,"caged cycle wreath elements",true,[IsCagedCycle],1, 
function(x)
    local info, det, i, normalCycle;

    info := FamilyObj(x)!.info;
    det := WPE_Determinant(x);
    i := Maximum(Territory(x));
    normalCycle := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(normalCycle, x![info.degI + 1]);
    normalCycle[i] := det;

    SetIsNormalCycle(normalCycle, true);

    return [Objectify(info.family!.defaultType,normalCycle)];
end);

InstallMethod( NormalCycleDecomposition,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, decomposition;

    info := FamilyObj(x)!.info;
    decomposition := CagedCycleDecomposition(x);
    return Concatenation(List(decomposition, NormalCycleDecomposition));
end);

InstallMethod( NormalConjugator,"normal cycle wreath elements",true,[IsNormalCycle],2, function(x) return [One(x)]; end);

InstallMethod( NormalConjugator,"caged cycle wreath elements",true,[IsCagedCycle],1,
function(x)
    local info, i, j, max, det, ord, k, y, conj;

    info := FamilyObj(x)!.info;
    ord := Order(x![info.degI + 1]);
    i := WPE_ChooseDeterminantPoint(x);
    max := Maximum(Territory(x));
    det := WPE_Determinant(x);
    conj := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(conj, One(info.groups[2]));
    conj := Objectify(info.family!.defaultType,conj);
    y := One(info.groups[1]);
    j := i;
    for k in [1..ord] do
        y := x![j]^-1 * y;
        if j = max then
            y := y * det;
        fi;
        j := i^(x![info.degI + 1]^k);
        conj![j] := y;
    od;

    return [conj];
end);

InstallMethod( NormalConjugator,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, decomposition;

    info := FamilyObj(x)!.info;
    decomposition := CagedCycleDecomposition(x);
    return Concatenation(List(decomposition, NormalConjugator));
end);

InstallTrueMethod( IsCagedCycle,IsNormalCycle);
InstallTrueMethod( IsWreathProductElement,IsCagedCycle);

InstallMethod( IsCagedCycle,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, suppTop;
    info := FamilyObj(x)!.info;

    # caged cycle of base type
    if IsOne(x![info.degI + 1]) then
        return Number([1..info.degI], i -> not IsOne(x![i])) = 1;
    fi;

    # caged cycle of top type
    suppTop := MovedPoints(x![info.degI + 1]);
    if Length(CycleStructurePerm(x![info.degI + 1])) + 1 <> Length(suppTop) then
        return false;
    fi;
    return ForAll([1..info.degI], i -> i in suppTop or IsOne(x![i]));
end);

InstallMethod( IsNormalCycle,"caged cycle wreath elements",true,[IsCagedCycle],1,
function(x)
    local info, terr, max;

    info := FamilyObj(x)!.info;
    terr := Territory(x);
    max := Maximum(terr);
    return ForAll(terr, i -> i = max or IsOne(x![i]));
end);

InstallMethod( IsNormalCycle,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    if IsCagedCycle(x) then
        return IsNormalCycle(x);
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

InstallGlobalFunction( WPE_ChooseDeterminantPoint,
function(x)
    return First(Territory(x));
end);

InstallMethod( WPE_Determinant,"caged cycle wreath elements",true,[IsCagedCycle],1,
function(x)
    return WPE_Determinant(x, WPE_ChooseDeterminantPoint(x));
end);

InstallOtherMethod( WPE_Determinant,"caged cycle wreath elements",true,[IsCagedCycle, IsInt],1,
function(x, i)
    local info, ord;

    if not i in Territory(x) then
        Error("i not in territory of x");
    fi;

    info := FamilyObj(x)!.info;
    ord := Order(x![info.degI + 1]);

    return Product([0..ord-1], k -> x![i^(x![info.degI + 1]^k)]);
end);

InstallMethod( Order,"caged cycle wreath elements",true,[IsCagedCycle],1,
function(x)
    local info;

    info := FamilyObj(x)!.info;
    return Order(WPE_Determinant(x)) * Order(x![info.degI + 1]);
end);

InstallMethod( Order,"generic wreath elements",true,[IsWreathProductElement],0,
function(x)
    local info, decomposition;

    info := FamilyObj(x)!.info;
    decomposition := CagedCycleDecomposition(x);
    if IsEmpty(decomposition) then
        return 1;
    fi;
    return Lcm(List(decomposition, Order));
end);

InstallGlobalFunction( Top,
function(x)
    local info;
    if not IsWreathProductElement(x) then
        return Error("x is not a wreath product element");
    fi;
    info := FamilyObj(x)!.info;
    return x![info.degI + 1];
end);

InstallGlobalFunction( Base,
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
        return List([1..info.degI], i -> x![i]);
    else
        i := arg[2];
        if not IsInt(i) then
            return Error("i must be an integer");
        fi;
        if i < 1 or i > info.degI then
        return Error("Index out of bounds");
        fi;
        return x![i];
    fi;
end);