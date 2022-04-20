#
# WPE: Provides efficient methods for working with wreath product elements.
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", "2018.02.14") then
    Error("AutoDoc version 2018.02.14 or newer is required.");
fi;

AutoDoc( rec( scaffold := rec(
        bib := "wpe",
        includes := [
            "intro.xml",
            "functions.xml",
            "operations.xml",
            ],
        ),
        # disable extraction of examples for now,
        # since Print methods are not handled corrently
        # by the gap test suite.
        #
        # extract_examples := true,
        autodoc := true ) );
