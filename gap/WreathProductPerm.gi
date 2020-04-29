#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#
# Implementations
#

InstallMethod( IsomorphismToGenericWreathProduct, "Perm to Generic", true, [HasWreathProductInfo and IsPermGroup], 0,
function(G)
    local W, iso;

    if WreathProductInfo(G).permimpr <> true then
        Error("G must be an imprimitive wreath product");
    fi;

    W := WPE_GenericPermWreathProduct(G);
    iso := GroupHomomorphismByFunction(G,W,g->WPE_ConvertPermToRep(G,W,g), rep -> WPE_ConvertRepToPerm(G,W,rep));
    return iso;
end);

InstallGlobalFunction( WPE_GenericPermWreathProduct,
function(G)
    local infoPerm,K,H,alpha,I,info,fam,typ,gens,hgens,id,i,e,W,p,n;

    infoPerm := WreathProductInfo(G);
    K := infoPerm.groups[1];
    H := infoPerm.groups[2];
    I := infoPerm.I;
    n := infoPerm.degI;
    alpha := infoPerm.alpha;
    
    fam:=NewFamily("WreathProductElemFamily",IsWreathProductElement);
    typ:=NewType(fam,IsWreathProductElementDefaultRep);
    fam!.defaultType:=typ;

    info:=rec(
        groups:=[K,H],
        family:=fam,
        I:=I,
        degI:=n,
        alpha:=alpha,
        embeddings:=StructuralCopy(infoPerm.embeddings)
    );
    fam!.info:=info;

    if CanEasilyCompareElements(One(K)) then
    SetCanEasilyCompareElements(fam,true);
    fi;
    if CanEasilySortElements(One(K)) then
        SetCanEasilySortElements(fam,true);
    fi;

    gens:=[];
    id:=ListWithIdenticalEntries(n,One(K));
    Add(id,One(I));
    info.identvec:=ShallowCopy(id);

    for p in List(Orbits(I,[1..n]),i->i[1]) do
        for i in GeneratorsOfGroup(K) do
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
    if HasSize(K) then
        if IsFinite(K) then
        SetSize(W,Size(K)^n*Size(I));
        else
        SetSize(W,infinity);
        fi;
    fi;
    if HasIsFinite(K) then
        SetIsFinite(W,IsFinite(K));
    fi;
    return W;
end);

InstallGlobalFunction( WPE_ConvertPermToRep,
function(G, W, g)
    local info, base, top, f, i, rep;

    info := WreathProductInfo(G);
    top := g^Projection(G);
    f := g * Image(Embedding(G, info.degI + 1), top)^(-1);
    base := [];
    for i in [1..info.degI] do
        Add(base, RestrictedPerm(f, info.components[i])^info.perms[i]);
    od;
    rep := Concatenation(base, [top]);
    return Objectify(WreathProductInfo(W).family!.defaultType, rep);
end);

InstallGlobalFunction( WPE_ConvertRepToPerm,
function(G, W, rep)
    local info, base, top, i, prod;

    info := WreathProductInfo(G);
    top := Image(Embedding(G, info.degI + 1), rep![info.degI + 1]);
    base := [];
    for i in [1..info.degI] do
        Add(base, Image(Embedding(G, i), rep![i]));
    od;
    prod := Product(Concatenation(base, [top]));
    return prod;
end);

InstallGlobalFunction( WPE_ConvertPointToTupel,
function(G, point)
    local info, i;
    info := WreathProductInfo(G);
    for i in [1..info.degI] do
        if point in info.components[i] then
            return [point^info.perms[i], i]; 
        fi;
    od;
    Error("point not in action set of G");
end);

InstallGlobalFunction( WPE_ConvertTupelToPoint,
function(G, tupel)
    local info, i;
    info := WreathProductInfo(G);
    i := tupel[2];
    return tupel[1]^(info.perms[i]^(-1));
end);