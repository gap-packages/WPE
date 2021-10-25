# Global variables are defined outside of this file
# str           ID                      : identifier of this example
# rec(K, H)     groups                  : groups K and H
# elm           g, h                    : random elements
G := WreathProduct(groups.K, groups.H);;
fileOut := Concatenation("./out_timingsWithoutPackage/", ID, ".csv");;
ProfileFunctions(Centraliser);;
Centraliser(G, g);;
prof := ProfileInfo([Centraliser], 1, 0);;
UnprofileFunctions(Centraliser);;
ClearProfile();;
AppendTo(fileOut, prof.ttim, "\n");;
