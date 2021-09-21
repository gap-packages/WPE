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