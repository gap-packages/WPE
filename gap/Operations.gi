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
               [HasWreathProductInfo], OVERRIDENICE + 42,
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
               [HasWreathProductInfo, IsObject, IsObject, IsFunction], OVERRIDENICE + 42,
function(G, g, h, act)
local x, y;
    if act <> OnPoints then
        TryNextMethod();
    fi;
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
               [HasWreathProductInfo, IsObject, IsObject], OVERRIDENICE + 42,
function(G, g, h)
    return RepresentativeActionOp(G, g, h, OnPoints);
end);

#############################################################################
##
#M  Centralizer( <G>, <e> ) . . . . . . . . . . . . . . . for wreath products
##
InstallMethod( CentralizerOp, "perm group,elm", IsCollsElms,
            [ HasWreathProductInfo, IsObject ], OVERRIDENICE + 42,
function( G, g )
    local x;
    x := ListWreathProductElement(G, g);
    if x = fail then
        TryNextMethod();
    fi;
    return WPE_Centraliser(G, x);
end );