#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#


#############################################################################
# Wreath Product Elements:
#############################################################################

#! @Description
DeclareAttribute( "CagedCycleDecomposition", IsWreathProductElement );
#! @Description
DeclareAttribute( "NormalCycleDecomposition", IsWreathProductElement );
#! @Description
DeclareAttribute( "NormalConjugator", IsWreathProductElement );
#! @Description
DeclareProperty( "IsCagedCycle", IsWreathProductElement );
#! @Description
DeclareProperty( "IsNormalCycle", IsWreathProductElement );
#! @Description
DeclareAttribute( "Territory", IsWreathProductElement );
#! @Description
DeclareGlobalFunction( "Top" );
#! @Description
DeclareGlobalFunction( "Base" );
#! @Description
DeclareAttribute( "WPE_Determinant", IsCagedCycle );
#! @Description
DeclareGlobalFunction( "WPE_ChooseDeterminantPoint" );


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
