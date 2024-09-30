#############################################################################
##  WreathProductElements.gd
#############################################################################
##
##  This file is part of the WPE package.
##
##  This file's authors include Friedrich Rober.
##
##  Please refer to the COPYRIGHT file for details.
##
##  SPDX-License-Identifier: GPL-2.0-or-later
##
#############################################################################


#############################################################################
# Wreath Product Elements:
#############################################################################


## <#GAPDoc Label="Territory">
## <ManSection>
## <Attr Name="Territory" Arg="x"/>
## <Description>
##   returns a list, namely the territory of <A>x</A>.
##   The argument <A>x</A> must be a wreath product element
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "Territory", IsWreathProductElement );

## <#GAPDoc Label="IsWreathCycle">
## <ManSection>
## <Attr Name="IsWreathCycle" Arg="x"/>
## <Description>
##   returns true or false. Tests whether <A>x</A> is a wreath cycle.
##   The argument <A>x</A> must be a wreath product element
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareProperty( "IsWreathCycle", IsWreathProductElement );

## <#GAPDoc Label="IsSparseWreathCycle">
## <ManSection>
## <Attr Name="IsSparseWreathCycle" Arg="x"/>
## <Description>
##   returns true or false. Tests whether <A>x</A> is a sparse wreath cycle.
##   The argument <A>x</A> must be a wreath product element
##   (see&nbsp;<Ref Sect="Sparse Wreath Cycle"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareProperty( "IsSparseWreathCycle", IsWreathProductElement );

## <#GAPDoc Label="WreathCycleDecomposition">
## <ManSection>
## <Attr Name="WreathCycleDecomposition" Arg="x"/>
## <Description>
##   returns a list containing wreath cycles, namely the wreath cycle decomposition of <A>x</A>.
##   The argument <A>x</A> must be a wreath product element
##   (see&nbsp;<Ref Sect="Wreath Cycle"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "WreathCycleDecomposition", IsWreathProductElement );

# TODO: Replace these attributes
DeclareAttribute( "SparseWreathCycleConjugate", IsWreathProductElement );
DeclareAttribute( "ConjugatorWreathCycleToSparse", IsWreathProductElement );

## <#GAPDoc Label="Yade">
## <ManSection>
## <Attr Name="Yade" Arg="x, [i]"/>
## <Description>
##   returns a group element, namely the yade of the wreath cycle <A>x</A>
##   evaluated at the smallest territory point.
##   If the optional argument <A>i</A> is provided,
##   the function returns the yade evaluated at the point <A>i</A>.
##   The argument <A>x</A> must be a wreath cycle
##   and the optional argument <A>i</A> must be an integer
##   from the territory of <A>x</A>
##   (see&nbsp;<Ref Sect="Sparse Wreath Cycle"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "Yade", IsWreathCycle );


#############################################################################
# Display:
#############################################################################


## <#GAPDoc Label="DisplayOptionsForWreathProductElements">
## <ManSection>
## <Func Name="DisplayOptionsForWreathProductElements" Arg=""/>
## <Description>
##   prints the current global display options for wreath product elements.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "DisplayOptionsForWreathProductElements" );

## <#GAPDoc Label="SetDisplayOptionsForWreathProductElements">
## <ManSection>
## <Func Name="SetDisplayOptionsForWreathProductElements" Arg="optrec"/>
## <Description>
##   sets the current global display options for wreath product elements. <P/>
##   The argument <A>optrec</A> must be a record with components that are valid display options. (see <Ref Label="Display Functions"/>)
##   The components for the current global display options are set to the values specified by the components in <A>optrec</A>.
## </Description>
## </ManSection>
## <#/GAPDoc>

DeclareGlobalFunction( "SetDisplayOptionsForWreathProductElements" );
## <#GAPDoc Label="ResetDisplayOptionsForWreathProductElements">
## <ManSection>
## <Func Name="ResetDisplayOptionsForWreathProductElements" Arg=""/>
## <Description>
##   resets the current global display options for wreath product elements to default.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "ResetDisplayOptionsForWreathProductElements" );


#############################################################################
# Components:
#############################################################################


## <#GAPDoc Label="ComponentsOfWreathProduct">
## <ManSection>
## <Func Name="ComponentsOfWreathProduct" Arg="W"/>
## <Description>
##   returns a list of two groups [K, H], where <A>W = K wr H</A>.
##   The argument <A>W</A> must be a wreath product
##   (see&nbsp;<Ref Sect="Wreath Product"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "ComponentsOfWreathProduct" );

## <#GAPDoc Label="TopComponentOfWreathProductElement">
## <ManSection>
## <Func Name="TopComponentOfWreathProductElement" Arg="x"/>
## <Description>
##   returns a group element, namely the top component of <A>x</A>.
##   The argument <A>x</A> must be a wreath product element
##   (see&nbsp;<Ref Sect="Wreath Product"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "TopComponentOfWreathProductElement" );
DeclareOperation( "WPE_TopComponent", [IsWreathProductElement] );

## <#GAPDoc Label="TopGroupOfWreathProduct">
## <ManSection>
## <Func Name="TopGroupOfWreathProduct" Arg="W"/>
## <Description>
##   returns a group, namely the top group <M>\langle 1_K \rangle^m \times H</M> of the wreath product <M>W = K \wr H</M>
##   (see&nbsp;<Ref Sect="Wreath Product"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "TopGroupOfWreathProduct" );
DeclareOperation( "WPE_TopGroup", [HasWreathProductInfo] );

DeclareOperation( "WPE_TopDegree", [IsWreathProductElement] );

## <#GAPDoc Label="BaseComponentOfWreathProductElement">
## <ManSection>
## <Func Name="BaseComponentOfWreathProductElement" Arg="x, [i]"/>
## <Description>
##   returns a group element, namely the base component of <A>x</A>.
##   If the optional argument <A>i</A> is provided,
##   the function returns the <A>i</A>-th base component of <A>x</A>.
##   The argument <A>x</A> must be a wreath product element
##   and the optional argument <A>i</A> must be an integer
##   (see&nbsp;<Ref Sect="Wreath Product"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "BaseComponentOfWreathProductElement" );
DeclareOperation( "WPE_BaseComponent", [IsWreathProductElement] );

## <#GAPDoc Label="BaseGroupOfWreathProduct">
## <ManSection>
## <Func Name="BaseGroupOfWreathProduct" Arg="W, [i]"/>
## <Description>
##   returns a group, namely the base group <M>K^m \times \langle 1_H</M> of the wreath product <M>W = K \wr H</M>.
##   If the optional argument <A>i</A> is provided,
##   the function returns the <A>i</A>-th factor of the base group of <A>W</A>
##   (see&nbsp;<Ref Sect="Wreath Product"/>).
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "BaseGroupOfWreathProduct" );
DeclareOperation( "WPE_BaseGroup", [HasWreathProductInfo] );


#############################################################################
# Isomorphism:
#############################################################################


## <#GAPDoc Label="IsomorphismWreathProduct">
## <ManSection>
## <Oper Name="IsomorphismWreathProduct" Arg="G"/>
## <Description>
##   returns an isomorphism from a specialized wreath product <A>G</A>
##   to a generic wreath product. <P/>
## <Example><![CDATA[
## gap> K := AlternatingGroup(5);;
## gap> H := SymmetricGroup(4);;
## gap> G := WreathProduct(K, H);
## <permutation group of size 311040000 with 10 generators>
## gap> iso := IsomorphismWreathProduct(G);;
## gap> W := Image(iso);
## <group of size 311040000 with 4 generators>
## ]]></Example>
##   For an overview on wreath product representations in &GAP; see <Ref Sect="Wreath Product Representations"/>. <P/>
##   In the background, it uses the low-level functions
##   <C>ListWreathProductElement</C> and <C>WreathProductElementList</C>
##   and wraps the <C>IsList</C> representations into <C>IsWreathProductElement</C> representations. <P/>
##   For performant code, we recommend to use these low-level functions instead of <C>IsomorphismWreathProduct</C>.
##   All functions for <C>IsWreathProductElement</C> also work on <C>IsList</C> objects that represent a wreath product element.
##   However, it is not checked that the <C>IsList</C> object actually represents a wreath product element.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareOperation( "IsomorphismWreathProduct", [HasWreathProductInfo] );


#############################################################################
# Cycle Index:
#############################################################################


## <#GAPDoc Label="CycleIndexWreathProductProductAction">
## <ManSection>
## <Func Name="CycleIndexWreathProductProductAction" Arg="K, H"/>
## <Description>
##   For two permutation groups <A>K</A> and <A>H</A>
##   this function constructs the cycle index polynomial of
##   the wreath product <M>K \wr H</M> in product action. <P/>
##   The implementation is based on <Cite Key="HarrisonHigh"/> and <Cite Key="PalmerRobinson"/>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "CycleIndexWreathProductProductAction");

## <#GAPDoc Label="CycleIndexWreathProductImprimitiveAction">
## <ManSection>
## <Func Name="CycleIndexWreathProductImprimitiveAction" Arg="K, H"/>
## <Description>
##   For two permutation groups <A>K</A> and <A>H</A>
##   this function constructs the cycle index polynomial of
##   the wreath product <M>K \wr H</M> in imprimitive action. <P/>
##   The implementation is based on <Cite Key="Polya"/>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "CycleIndexWreathProductImprimitiveAction");
