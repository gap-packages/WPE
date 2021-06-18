#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#
# Implementations
#

InstallMethod(IsomorphismToGenericWreathProduct,"wreath products",true,[HasWreathProductInfo],1,
function(G)
    local info, W, typ, iso;
    info := WreathProductInfo(G);
    if not IsPermGroup(info.groups[2]) then
        ErrorNoReturn("Top group of <G> must be a permutation group");
    fi;
    W := WPE_GenericWreathProduct(info.groups[1], info.groups[2], IdentityMapping(info.groups[2]));
    typ := FamilyObj(One(W))!.info.family!.defaultType;
    iso := GroupHomomorphismByFunction(G, W,
           g-> Objectify(typ, ListWreathProductElement(G, g)),
           x -> WreathProductElementList(G, ListWreathProductElement(W, x)));
    return iso;
end);

# Code from GAP lib
InstallGlobalFunction(WPE_GenericWreathProduct,
function(G, H, alpha)
    local I, n, fam, typ, gens, hgens, id, i, e, info, W, p, dom;
    I:=Image(alpha,H);

    # avoid sparse first points.
    dom:=MovedPoints(I);
    if Length(dom)=0 then
        dom:=[1];
        n:=1;
    elif Maximum(dom)>Length(dom) then
        alpha:=alpha*ActionHomomorphism(I,dom);
        I:=Image(alpha,H);
        n:=LargestMovedPoint(I);
    else
        n:=LargestMovedPoint(I);
    fi;

    fam:=NewFamily("WreathProductElemFamily",IsWreathProductElement);
    typ:=NewType(fam,IsWreathProductElementDefaultRep);
    fam!.defaultType:=typ;
    info:=rec(groups:=[G,H],
            family:=fam,
                I:=I,
            degI:=n,
            alpha:=alpha,
            embeddings:=[]);
    fam!.info:=info;
    if CanEasilyCompareElements(One(G)) then
        SetCanEasilyCompareElements(fam,true);
    fi;
    if CanEasilySortElements(One(G)) then
        SetCanEasilySortElements(fam,true);
    fi;

    gens:=[];
    id:=ListWithIdenticalEntries(n,One(G));
    Add(id,One(I));
    info.identvec:=ShallowCopy(id);

    for p in List(Orbits(I,[1..n]),i->i[1]) do
        for i in GeneratorsOfGroup(G) do
        e:=ShallowCopy(id);
        e[p]:=i;
        Add(gens,Objectify(typ,e));
        od;
    od;

    info.basegens:=ShallowCopy(gens);
    hgens:=[];
    for i in GeneratorsOfGroup(H) do
        e:=ShallowCopy(id);
        e[n+1]:=Image(alpha,i);
        Add(hgens,Objectify(typ,e));
    od;
    Append(gens,hgens);
    info.hgens:=hgens;
    SetOne(fam,Objectify(typ,id));
    W:=Group(gens,One(fam));
    SetWreathProductInfo(W,info);
    SetIsWholeFamily(W,true);
    if HasSize(G) then
        if IsFinite(G) then
        SetSize(W,Size(G)^n*Size(I));
        else
        SetSize(W,infinity);
        fi;
    fi;
    if HasIsFinite(G) then
        SetIsFinite(W,IsFinite(G));
    fi;
    return W;
end);

InstallMethod(PrintObj,"wreath elements",true,[IsWreathProductElement],1,
function(x)
local i,info;
  info:=FamilyObj(x)!.info;
  Print("WreathProductElement(");
  for i in [1..info!.degI] do
    Print(WPE_BaseComponent(x, i));
    if i < info!.degI then
        Print(",");
    fi;
  od;
  Print(";",WPE_TopComponent(x),")");
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
    suppTop := MovedPoints(WPE_TopComponent(x));
    suppBase := Filtered([1..info.degI], i -> not IsOne(WPE_BaseComponent(x, i)));
    id := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(id, One(info.groups[2]));
    decomposition := [];

    # wreath cycles that are of base type
    for i in Filtered(suppBase, x -> not x in suppTop) do
        wreathCycle := ShallowCopy(id);
        wreathCycle[i] := WPE_BaseComponent(x, i);
        wreathCycle := Objectify(info.family!.defaultType,wreathCycle);

        SetIsSparseWreathCycle(wreathCycle,true);
        Add(decomposition, wreathCycle);
    od;

    # wreath cycles that are of top type
    if IsEmpty(suppTop) then
        return decomposition;
    fi;
    topCycleList := Cycles(WPE_TopComponent(x), suppTop);
    for topCycle in topCycleList do
        wreathCycle := ShallowCopy(id);
        wreathCycle[info.degI + 1] := CycleFromList(topCycle);
        for i in topCycle do
            wreathCycle[i] := WPE_BaseComponent(x, i);
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
    Add(sparseWreathCycle, WPE_TopComponent(x));
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
    ord := Order(WPE_TopComponent(x));
    i := WPE_ChooseYadePoint(x);
    max := Maximum(Territory(x));
    yade := Yade(x);
    conj := ListWithIdenticalEntries(info.degI, One(info.groups[1]));
    Add(conj, One(info.groups[2]));
    y := One(info.groups[1]);
    j := i;
    for k in [1..ord] do
        y := WPE_BaseComponent(x, j)^-1 * y;
        if j = max then
            y := y * yade;
        fi;
        j := i^(WPE_TopComponent(x)^k);
        conj[j] := y;
    od;

    return [Objectify(info.family!.defaultType,conj)];
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
    if IsOne(WPE_TopComponent(x)) then
        return Number([1..info.degI], i -> not IsOne(WPE_BaseComponent(x, i))) = 1;
    fi;

    # wreath cycle of top type
    suppTop := MovedPoints(WPE_TopComponent(x));
    if Length(CycleStructurePerm(WPE_TopComponent(x))) + 1 <> Length(suppTop) then
        return false;
    fi;
    return ForAll([1..info.degI], i -> i in suppTop or IsOne(WPE_BaseComponent(x, i)));
end);

InstallMethod( IsSparseWreathCycle,"wreath cycle wreath elements",true,[IsWreathCycle],1,
function(x)
    local info, terr, max;

    info := FamilyObj(x)!.info;
    terr := Territory(x);
    max := Maximum(terr);
    return ForAll(terr, i -> i = max or IsOne(WPE_BaseComponent(x, i)));
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
    suppTop := MovedPoints(WPE_TopComponent(x));
    suppBase := Filtered([1..info.degI], i -> not IsOne(WPE_BaseComponent(x, i)));
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
    ord := Order(WPE_TopComponent(x));

    return Product([0..ord-1], k -> WPE_BaseComponent(x, i^(WPE_TopComponent(x)^k)));
end);

InstallMethod( Order,"wreath cycle wreath elements",true,[IsWreathCycle],1,
function(x)
    local info;

    info := FamilyObj(x)!.info;
    return Order(Yade(x)) * Order(WPE_TopComponent(x));
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

InstallGlobalFunction( ComponentsOfGenericWreathProduct,
function(W)
    if not HasWreathProductInfo(W) then
        return Error("W is not a wreath product");
    fi;
    return Immutable(WreathProductInfo(W).groups);
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

InstallGlobalFunction( TopGroupOfGenericWreathProduct,
function(W)
    if not HasWreathProductInfo(W) then
        return Error("W is not a wreath product");
    fi;
    return WPE_TopGroup(W);
end);

InstallMethod( WPE_TopGroup, "generic wreath product", true, [HasWreathProductInfo], 0,
function(W)
    local info;

    info := WreathProductInfo(W);
    return Image(Embedding(W, info!.degI + 1));
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

InstallGlobalFunction( BaseGroupOfGenericWreathProduct,
function(arg)
    local info, W, i;

    if Length(arg) > 2 then
        return Error("wrong number of arguments");
    fi;
    W := arg[1];
    if not HasWreathProductInfo(W) then
        return Error("W is not a wreath product");
    fi;
    info := WreathProductInfo(W);
    if Length(arg) = 1 then
        return WPE_BaseGroup(W);
    else
        i := arg[2];
        if not IsInt(i) then
            return Error("i must be an integer");
        fi;
        if i < 1 or i > info.degI then
        return Error("Index out of bounds");
        fi;
        return WPE_BaseGroup(W,i);
    fi;
end);

InstallMethod( WPE_BaseGroup, "generic wreath product", true, [HasWreathProductInfo], 0,
function(W)
    local info;

    info := WreathProductInfo(W);
    return Group(Concatenation(List([1..info.degI], i -> List(GeneratorsOfGroup(info.groups[1]), x -> x^Embedding(W,i)))));
end);

InstallOtherMethod( WPE_BaseGroup, "generic wreath product and integer", true, [HasWreathProductInfo, IsInt], 0,
function(W, i)
    return Image(Embedding(W, i));
end);