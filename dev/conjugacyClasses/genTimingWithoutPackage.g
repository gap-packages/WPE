# Global variables are defined outside of this file
# rec(K, H)     groups                  : groups K and H
G := WreathProduct(groups.K, groups.H);;
fileOut := "out_timingsWithoutPackage.csv";;
ProfileFunctions(ConjugacyClasses);;
C := ConjugacyClasses(G);;
prof := ProfileInfo([ConjugacyClasses], 1, 0);;
UnprofileFunctions(ConjugacyClasses);;
ClearProfile();;
AppendTo(fileOut, Length(C), ",", prof.ttim, "\n");;
