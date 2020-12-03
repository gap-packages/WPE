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

## <#GAPDoc Label="Top">
## <ManSection>
## <Func Name="Top" Arg="x"/>
## <Description>
##   returns the top component of <A>x</A>.
##   The argument <A>x</A> must be a generic wreath product element.
##   (see&nbsp;<Ref Sect="Intro Notation"/>)
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "Top" );

## <#GAPDoc Label="Base">
## <ManSection>
## <Func Name="Base" Arg="x, [i]"/>
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
DeclareGlobalFunction( "Base" );

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

#############################################################################
# Perm Representation:
#############################################################################

## <#GAPDoc Label="WPE_GenericPermWreathProduct">
## <ManSection>
## <Func Name="WPE_GenericPermWreathProduct" Arg="G"/>
## <Description>
##   returns a generic wreath product from a perm wreath product.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "WPE_GenericPermWreathProduct" );

## <#GAPDoc Label="WPE_ConvertPermToRep">
## <ManSection>
## <Func Name="WPE_ConvertPermToRep" Arg="G, W, g"/>
## <Description>
##   returns the generic representation of an element <A>g</A> in <A>G</A>,
##   where <A>G</A> is a wreath product in permutation representation
##   and <A>W</A> is the same wreath product in generic representation.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "WPE_ConvertPermToRep" );

## <#GAPDoc Label="WPE_ConvertRepToPerm">
## <ManSection>
## <Func Name="WPE_ConvertRepToPerm" Arg="G, W, x"/>
## <Description>
##   returns the permutation representation of an element <A>x</A> in <A>W</A>,
##   where <A>G</A> is a wreath product in permutation representation
##   and <A>W</A> is the same wreath product in generic representation.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "WPE_ConvertRepToPerm" );

#! @Description
#! G = K wr H, where K acts on n points and H acts on m points,
#! is embedded in S_{n + m} in its imprimitive action.
#! Convert a point from the induced action in the symmetric group
#! into a tupel (i,j) on which the abstract wreath product acts.
#! @Returns permutation
#! @Arguments G, W, rep
DeclareGlobalFunction( "WPE_ConvertPointToTupel" );

#! @Description
#! @Returns permutation
#! @Arguments G, W, rep
DeclareGlobalFunction( "WPE_ConvertTupelToPoint" );

#############################################################################
# Matrix Representation:
#############################################################################

#! @Description
#! Creates a generic wreath product from a matrix group
#! @Returns generic wreath product
#! @Arguments G
DeclareGlobalFunction( "WPE_GenericMatWreathProduct" );

#! @Description
#! Convert perm g from matrix wreath product G = K wr H
#! into expanded rep of abstract wreath product.
#! Expanded rep is a tupel (g_1, ..., g_m, pi), where g_i in K, pi in H.
#! @Returns generic wreath product element
#! @Arguments G, W, g
DeclareGlobalFunction( "WPE_ConvertMatToRep" );

#! @Description
#! Convert rep from abstract wreath product into matrix of
#! matrix wreath product G = K wr H.
#! @Returns permutation
#! @Arguments G, W, rep
DeclareGlobalFunction( "WPE_ConvertRepToMat" );
