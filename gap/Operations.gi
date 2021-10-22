#############################################################################
##
#M  ConjugacyClasses( <G> ) . . . . . . . . . . . . . . . . .  for wreath product
##
InstallMethod( ConjugacyClasses, "for wreath product", true,
               [HasWreathProductInfo], OVERRIDENICE + 42,
function(G)
local iso;
    # TODO: remove this hack
    # Ugly Hack: Multiplications in Generic Wreath Product
    # are faster than in Matrix Wreath Product
    if IsMatrixGroup(G) then
        iso := IsomorphismToGenericWreathProduct(G);
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
               [HasWreathProductInfo, IsObject, IsObject], OVERRIDENICE + 42,
function(G, w, v)
local x, y;
    x := ListWreathProductElement(G, w);
    if x = fail then
        TryNextMethod();
    fi;
    y := ListWreathProductElement(G, v);
    if y = fail then
        TryNextMethod();
    fi;
    return WPE_RepresentativeAction(G, x, y);
end);