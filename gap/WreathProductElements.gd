#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#

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

#! @Description
#! Decompose an element rep of G = K wr H that is given 
#! in expanded representation into wreath cycles as follows.
#! We write rep as a product of strongly caged elements 
#! with pairwise disjoint territory.
#! Let rep = (g_1, ..., g_m, pi), where g_i in K, pi in H.
#! Decompose pi into cycles, say pi = c_1 ... c_l.
#! For a set I &lt;= {1,...,m} we define b_I as an element of K^m by setting 
#!   - (b_I)_i := g_i if i in I.
#!   - (b_I)_i := 1_K else.
#! For each cycle c_r we define top_r := (b_supp(c_r), c_r).
#! For each point i such that i not in terr(rep) and g_i &lt;> 1_K
#! we define base_i := b_i.
#! Then rep can be written as a product 
#! of the top_r and base_i elements
#! and each element is a strongly caged element 
#! with pairwise disjoint territory,
#! thus in particular these elements commute pairwise.
#! @Returns list of generic wreath product element
#! @Arguments G, rep
DeclareGlobalFunction( "WPE_WreathCycleDecomposition" );

DeclareGlobalFunction( "WPE_IsCagedCycle" );