#
# WPE: Provides efficient methods for working with wreath product elements.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "WPE" );

TestDirectory(DirectoriesPackageLibrary( "WPE", "tst/files"),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
