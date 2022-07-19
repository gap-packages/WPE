# Global variables are defined outside of this file
# rec(K, H)     groups                  : groups K and H
LoadPackage("WPE");;
G := WreathProduct(groups.K, groups.H);;
# If G is a matrix group, the construction of representatives is slow.
if IsMatrixGroup(G) then
    G := Image(IsomorphismWreathProduct(G));
fi;
fileOut := "out_timingsWithPackage.csv";;
ProfileFunctions(WPE_ConjugacyClasses);;
C := WPE_ConjugacyClasses(G);;
prof := ProfileInfo([WPE_ConjugacyClasses], 1, 0);;
UnprofileFunctions(WPE_ConjugacyClasses);;
ClearProfile();;
AppendTo(fileOut, Length(C), ",", prof.ttim, "\n");;
