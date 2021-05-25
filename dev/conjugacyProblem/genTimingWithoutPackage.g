# Global variables are defined outside of this file
# str           ID                      : identifier of this example
# rec(K, H)     groups                  : groups K and H
# elm           g, h                    : random elements
G := WreathProduct(groups.K, groups.H);;
fileOut := Concatenation("./out_timingsWithoutPackage/", ID, ".csv");;
w := g;;
v := g ^ h;;
ProfileFunctions(RepresentativeAction);;
RepresentativeAction(G, w, v);;
prof := ProfileInfo([RepresentativeAction], 1, 0);;
UnprofileFunctions(RepresentativeAction);;
ClearProfile();;
AppendTo(fileOut, prof.ttim, "\n");;
