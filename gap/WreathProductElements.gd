#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#


#############################################################################
# Wreath Product Elements:
#############################################################################

## <#GAPDoc Label="Territory">
## <ManSection>
## <Attr Name="Territory" Arg="x"/>
## <Description>
##   returns the territory of <A>x</A>.
##   The argument <A>x</A> must be a generic wreath product element.
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "Territory", IsWreathProductElement );

## <#GAPDoc Label="IsWreathCycle">
## <ManSection>
## <Attr Name="IsWreathCycle" Arg="x"/>
## <Description>
##   tests whether <A>x</A> is a wreath cycle.
##   The argument <A>x</A> must be a generic wreath product element.
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareProperty( "IsWreathCycle", IsWreathProductElement );

## <#GAPDoc Label="IsSparseWreathCycle">
## <ManSection>
## <Attr Name="IsSparseWreathCycle" Arg="x"/>
## <Description>
##   tests whether <A>x</A> is a sparse wreath cycle.
##   The argument <A>x</A> must be a generic wreath product element.
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareProperty( "IsSparseWreathCycle", IsWreathProductElement );

## <#GAPDoc Label="WreathCycleDecomposition">
## <ManSection>
## <Attr Name="WreathCycleDecomposition" Arg="x"/>
## <Description>
##   returns the wreath cycle decomposition of <A>x</A>.
##   The argument <A>x</A> must be a generic wreath product element.
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "WreathCycleDecomposition", IsWreathProductElement );

## <#GAPDoc Label="SparseWreathCycleDecomposition">
## <ManSection>
## <Attr Name="SparseWreathCycleDecomposition" Arg="x"/>
## <Description>
##   returns the sparse wreath cycle decomposition of <A>x</A>.
##   The argument <A>x</A> must be a generic wreath product element.
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "SparseWreathCycleDecomposition", IsWreathProductElement );

## <#GAPDoc Label="ConjugatorWreathCycleToSparse">
## <ManSection>
## <Attr Name="ConjugatorWreathCycleToSparse" Arg="x"/>
## <Description>
##   returns a list of wreath product elements <M>c_1, \ldots, c_l</M>,
##   such that for each wreath cycle <M>w_k</M> in the decompositon of <A>x</A>,
##   the element <M>w_k^{{c_k}}</M> is the corresponding sparse wreath cycle
##   in the sparse wreath cycle decomposition of <A>x</A>.
##   The argument <A>x</A> must be a generic wreath product element.
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "ConjugatorWreathCycleToSparse", IsWreathProductElement );

## <#GAPDoc Label="ComponentsOfGenericWreathProduct">
## <ManSection>
## <Func Name="ComponentsOfGenericWreathProduct" Arg="W"/>
## <Description>
##   returns the groups [K, H] of <A>W = K wr H</A>.
##   The argument <A>W</A> must be a generic wreath product.
##   (see&nbsp;<Ref Sect="Intro Notation"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "ComponentsOfGenericWreathProduct" );

## <#GAPDoc Label="TopComponentOfGenericWreathProductElement">
## <ManSection>
## <Func Name="TopComponentOfGenericWreathProductElement" Arg="x"/>
## <Description>
##   returns the top component of <A>x</A>.
##   The argument <A>x</A> must be a generic wreath product element.
##   (see&nbsp;<Ref Sect="Intro Notation"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "TopComponentOfGenericWreathProductElement" );
DeclareOperation( "WPE_TopComponent", [IsWreathProductElement] );

## <#GAPDoc Label="TopGroupOfGenericWreathProduct">
## <ManSection>
## <Func Name="TopGroupOfGenericWreathProduct" Arg="W"/>
## <Description>
##   returns the top group of the generic wreath product <A>W</A>.
##   (see&nbsp;<Ref Sect="Intro Notation"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "TopGroupOfGenericWreathProduct" );
DeclareOperation( "WPE_TopGroup", [HasWreathProductInfo] );

## <#GAPDoc Label="BaseComponentOfGenericWreathProductElement">
## <ManSection>
## <Func Name="BaseComponentOfGenericWreathProductElement" Arg="x, [i]"/>
## <Description>
##   returns the base component of <A>x</A>.
##   If the optional argument <A>i</A> is provided,
##   the function returns the <A>i</A>-th base component of <A>x</A>.
##   The argument <A>x</A> must be a generic wreath product element
##   and the optional argument <A>i</A> must be an integer.
##   (see&nbsp;<Ref Sect="Intro Notation"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "BaseComponentOfGenericWreathProductElement" );
DeclareOperation( "WPE_BaseComponent", [IsWreathProductElement] );

## <#GAPDoc Label="BaseGroupOfGenericWreathProduct">
## <ManSection>
## <Func Name="BaseGroupOfGenericWreathProduct" Arg="W, [i]"/>
## <Description>
##   returns the base group of the generic wreath product <A>W</A>.
##   If the optional argument <A>i</A> is provided,
##   the function returns the <A>i</A>-th factor of the base group of <A>W</A>.
##   (see&nbsp;<Ref Sect="Intro Notation"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "BaseGroupOfGenericWreathProduct" );
DeclareOperation( "WPE_BaseGroup", [HasWreathProductInfo] );


#! @Description
DeclareAttribute( "Yade", IsWreathCycle );

#! @Description
DeclareGlobalFunction( "WPE_ChooseYadePoint" );


#############################################################################
# Isomorphism:
#############################################################################

## <#GAPDoc Label="IsomorphismToGenericWreathProduct">
## <ManSection>
## <Oper Name="IsomorphismToGenericWreathProduct" Arg="G"/>
## <Description>
##   returns an isomorphism from a specialized wreath product <A>G</A>
##   to a generic wreath product.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareOperation( "IsomorphismToGenericWreathProduct", [HasWreathProductInfo] );
DeclareGlobalFunction( "WPE_GenericWreathProduct" );

#############################################################################
# Conjugacy Problem:
#############################################################################

DeclareGlobalFunction( "WPE_RepresentativeAction" );
DeclareGlobalFunction( "WPE_RepresentativeAction_PartitionByTopAndYadeClass" );
DeclareGlobalFunction( "WPE_RepresentativeAction_PartitionBlockTopByYadeClass" );
DeclareGlobalFunction( "WPE_RepresentativeAction_BlockMapping" );
DeclareGlobalFunction( "WPE_RepresentativeAction_Top" );
DeclareGlobalFunction( "WPE_RepresentativeAction_Base" );

#############################################################################
# Conjugacy Classes:
#############################################################################

DeclareGlobalFunction( "WPE_ConjugacyClasses" );
DeclareGlobalFunction( "WPE_ConjugacyClassesWithFixedTopClass" );

#############################################################################
# Territory Decomposition:
#############################################################################

DeclareGlobalFunction( "WPE_PartitionDataOfWreathCycleDecompositionByLoad" );
DeclareGlobalFunction( "WPE_PartitionDataOfBlockTopByYadeClass" );

#############################################################################
# Centraliser:
#############################################################################

DeclareGlobalFunction( "WPE_PsiFunc" );
DeclareGlobalFunction( "WPE_StabDecomp" );
DeclareGlobalFunction( "WPE_Centraliser_Image" );
DeclareGlobalFunction( "WPE_Centraliser" );
