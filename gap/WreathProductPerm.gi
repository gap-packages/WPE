#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#
# Implementations
#

InstallMethod( IsomorphismToGenericWreathProduct, "Perm to Generic", true, [HasWreathProductInfo and IsPermGroup], 0,
function(G)
    local
      W,            # generic wreath product
      iso;          # isomorphism from G to W

    if WreathProductInfo(G).permimpr <> true then
        Error("G must be an imprimitive wreath product");
    fi;

    W := WPE_GenericPermWreathProduct(G);
    iso := GroupHomomorphismByFunction(G,W,g->WPE_ConvertPermToRep(G,W,g), x -> WPE_ConvertRepToPerm(G,W,x));
    return iso;
end);

InstallGlobalFunction( WPE_GenericPermWreathProduct,
function(G)
    local
      infoPerm,     # wreath product info of G
      K,H,          # G = K wr H
      alpha,        # homomorphism from H to perm group
      I,            # image under alpha, perm group
      n,            # degree of I
      W,            # generic wreath product
      info,         # wreath product info of W
      fam,          # family of generic wreath product elements
      typ,          # type of generic wreath product elements
      gens,         # generators of W
      hgens,        # top generators of W
      id,           # identity vector
      i,            # generator of K, loop var
      e,            # element of W, loop var
      p;            # index point, loop var

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
    local
      info,         # wreath product info of G
      base,         # base components of g, list
      top,          # top component of g, perm
      f,            # base element in G, embedding of base component of g
      i,            # index point, loop var
      x;            # generic wreath product element

    info := WreathProductInfo(G);
    top := g^Projection(G);
    f := g * Image(Embedding(G, info.degI + 1), top)^(-1);
    base := [];
    for i in [1..info.degI] do
        Add(base, RestrictedPerm(f, info.components[i])^info.perms[i]);
    od;
    x := Concatenation(base, [top]);
    return Objectify(WreathProductInfo(W).family!.defaultType, x);
end);

InstallGlobalFunction( WPE_ConvertRepToPerm,
function(G, W, x)
    local
        info,       # wreath product info of G
        base,       # base components of x, list
        top,        # top component of x, perm
        i,          # index point, loop var
        g;          # perm wreath product element

    info := WreathProductInfo(G);
    top := Image(Embedding(G, info.degI + 1), x![info.degI + 1]);
    base := [];
    for i in [1..info.degI] do
        Add(base, Image(Embedding(G, i), x![i]));
    od;
    g := Product(Concatenation(base, [top]));
    return g;
end);
