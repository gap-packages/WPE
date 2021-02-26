gap> SetInfoLevel(InfoXMLParser,0);
gap> SetInfoLevel(InfoGAPDoc,0);
gap> examples := ExtractExamples("doc", "intro.xml", ["../gap/WreathProductElements.gd", "../gap/WreathProductElements.gi"], "Chapter");;
gap> RunExamples(examples, rec(ignoreComments := true));
# Running list 1 . . .
true
gap> 