#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "WreathProductElements" );

TestDirectory(DirectoriesPackageLibrary( "WreathProductElements", "tst/files" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
