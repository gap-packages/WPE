# Global variables are defined outside of this file
# str           ID                      : identifier of this example
# int           nrRandomElements        : number of random elements
# rec(K, H)     groups                  : groups K and H
G := WreathProduct(groups.K, groups.H);;
fileOut := Concatenation("./out_randomElements/", ID, ".csv");;
PrintTo(fileOut, "");;
randomElements := EmptyPlist(nrRandomElements);;
for i in [1 .. nrRandomElements] do
    g := PseudoRandom(G);;
    h := PseudoRandom(G);;
    randomElements[i] := rec(g := g, h := h);;
od;;
PrintCSV(fileOut, randomElements);;