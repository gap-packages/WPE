#
# WPE: Provides efficient methods for working with wreath product elements.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "WPE" );

docTests := TestDirectory(DirectoriesPackageLibrary( "WPE", "tst/files/doc"),
  rec(
    testOptions := rec(
      width := 120,
      compareFunction := "uptowhitespace",

    ),
  )
);

machineTests := TestDirectory(DirectoriesPackageLibrary( "WPE", "tst/files/machine-generated"),
  rec()
);

humanTests := TestDirectory(DirectoriesPackageLibrary( "WPE", "tst/files/human-created"),
  rec()
);

if not (docTests and machineTests and humanTests) then
  FORCE_QUIT_GAP(1); # if we ever get here, there was an error
else
  FORCE_QUIT_GAP(0); # everything is fine
fi;
