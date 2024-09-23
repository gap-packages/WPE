#############################################################################
##
#M  Order( <e> ) . . . . . . . . . . . . . . . . . for wreath product element
##

InstallMethod( Order, "wreath cycle wreath elements", true, [IsWreathCycle], 1,
function(x)
    local info;

    info := FamilyObj(x)!.info;
    return Order(Yade(x)) * Order(WPE_TopComponent(x));
end);

InstallMethod( Order, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    local info, decomposition;

    info := FamilyObj(x)!.info;
    decomposition := WreathCycleDecomposition(x);
    if IsEmpty(decomposition) then
        return 1;
    fi;
    return Lcm(List(decomposition, Order));
end);

#############################################################################
##
#M  ConjugacyClasses( <G> ) . . . . . . . . . . . . . . .  for wreath product
##
InstallMethod( ConjugacyClasses, "for wreath product", true,
               [HasWreathProductInfo], OVERRIDENICE + 4200,
function(G)
local iso;
    # TODO: remove this hack
    # Ugly Hack: Multiplications in Generic Wreath Product
    # are faster than in Matrix Wreath Product
    if IsMatrixGroup(G) then
        iso := IsomorphismWreathProduct(G);
        return List(WPE_ConjugacyClasses(Image(iso)), C -> ConjugacyClass(G, PreImage(iso, Representative(C))));
    else
        return WPE_ConjugacyClasses(G);
    fi;
end);

#############################################################################
##
#M  RepresentativeAction( <G> [,<Omega>], <d>, <e> [,<gens>,<acts>] [,<act>] ) . . . . . . . . . . . .  for wreath product
##
InstallOtherMethod( RepresentativeActionOp, "for wreath product", true,
               [HasWreathProductInfo, IsObject, IsObject, IsFunction], OVERRIDENICE + 4200,
function(G, g, h, act)
local x, y;
    if act <> OnPoints then
        TryNextMethod();
    fi;

    # Check if g and h are elements in the same representation as the group G
    if IsPermGroup(G) then
        if not (IsPerm(g) and IsPerm(h)) then
            TryNextMethod();
        fi;
    elif IsMatrixGroup(G) then
        if not (IsMatrix(g) and IsMatrix(h)) then
            TryNextMethod();
        fi;
    else
        if not (IsWreathProductElement(g) and IsWreathProductElement(h) and
                FamilyObj(g) = FamilyObj(h) and FamilyObj(One(G)) = FamilyObj(g)) then
            TryNextMethod();
        fi;
    fi;

    # Check if elements are living inside the wreath product
    x := ListWreathProductElement(G, g);
    if x = fail then
        TryNextMethod();
    fi;
    y := ListWreathProductElement(G, h);
    if y = fail then
        TryNextMethod();
    fi;
    return WPE_RepresentativeAction(G, x, y);
end);

InstallOtherMethod( RepresentativeActionOp, "for wreath product", true,
               [HasWreathProductInfo, IsObject, IsObject], OVERRIDENICE + 4200,
function(G, g, h)
    return RepresentativeActionOp(G, g, h, OnPoints);
end);

#############################################################################
##
#M  Centralizer( <G>, <e> ) . . . . . . . . . . . . . . . for wreath products
##
InstallMethod( CentralizerOp, "for wreath product", IsCollsElms,
            [ HasWreathProductInfo, IsObject ], OVERRIDENICE + 4200,
function( G, g )
    local x;

    # Check if g is an element in the same representation as the group G
    if IsPermGroup(G) then
        if not (IsPerm(g)) then
            TryNextMethod();
        fi;
    elif IsMatrixGroup(G) then
        if not (IsMatrix(g)) then
            TryNextMethod();
        fi;
    else
        if not (IsWreathProductElement(g) and FamilyObj(One(G)) = FamilyObj(g)) then
            TryNextMethod();
        fi;
    fi;

    x := ListWreathProductElement(G, g);
    if x = fail then
        TryNextMethod();
    fi;
    return WPE_Centraliser(G, x);
end );

#############################################################################
##
#M  CycleIndex( <G>, <dom>, <act> ) . . . . . . . . . . . . . . . for wreath products
##
InstallMethod(CycleIndexOp, "wreath product", true,
            [HasWreathProductInfo, IsListOrCollection, IsFunction], 4200,
function( G, dom, act )
    local info, comp, K, H;
    if dom <> MovedPoints(G) then
        TryNextMethod();
    fi;
    if act <> OnPoints then
        TryNextMethod();
    fi;
    info := WreathProductInfo(G);
    comp := ComponentsOfWreathProduct(G);
    K := comp[1];
    H := comp[2];
    if IsBound(info.permimpr) and info.permimpr then
        return CycleIndexWreathProductImprimitiveAction(K, H);
    elif IsBound(info.productType) and info.productType then
        return CycleIndexWreathProductProductAction(K, H);
    else
        TryNextMethod();
    fi;
end);
