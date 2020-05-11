#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", "2018.02.14") then
    Error("AutoDoc version 2018.02.14 or newer is required.");
fi;

AutoDoc( rec( scaffold := rec(
        includes := [
            "intro.xml",
            "iso.xml",
            "operations.xml"
            ],
        ), autodoc := true ) );
