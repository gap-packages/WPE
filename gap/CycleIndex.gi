#############################################################################
##  CycleIndex.gi
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
# Cross Product of Polynomials
#############################################################################
#
# Implement the new binary operation of polynomials from [HH68],
# which we call cross product of polynomials.
#
#############################################################################

# helper function to tranform a list of the form [x_1,y_1,x_2,y_2,...,x_n,y_n]
# of length 2n in to the list [[x_1,y_1], [x_2,y_2],...,[x_n,y_n]]
BindGlobal("WPE_ExtPoly_TransformList",
function(list)
    return List(
        List(
            [1 .. Length(list) / 2],
            z -> 2 * z),
        i -> [list[i - 1], list[i]]);
end);

# cross product of indeterminates
BindGlobal("WPE_CrossPoly_Indeterminants",
function(x,y)
    local res;

    res := [];
    res[2] := x[2] * y[2] * Gcd(x[1],y[1]);
    res[1] := Lcm(x[1],y[1]);

    return res;
end);

# cross product of monomials
BindGlobal("WPE_CrossPoly_Monomials",
function(x,y)
    local res, listOfIndeterminatePowersOf_x, listOfIndeterminatePowersOf_y,
    listOfIndeterminatePowersOf_res, tuple, indet1, indet2, temp;

    listOfIndeterminatePowersOf_x := WPE_ExtPoly_TransformList(x);
    listOfIndeterminatePowersOf_y := WPE_ExtPoly_TransformList(y);
    listOfIndeterminatePowersOf_res := [];

    for indet1 in listOfIndeterminatePowersOf_x do
        for indet2 in listOfIndeterminatePowersOf_y do
            temp := WPE_CrossPoly_Indeterminants(indet1,indet2);
            if IsBound(listOfIndeterminatePowersOf_res[temp[1]]) then
                listOfIndeterminatePowersOf_res[temp[1]][2] :=
                listOfIndeterminatePowersOf_res[temp[1]][2] + temp[2];
            else
                listOfIndeterminatePowersOf_res[temp[1]] := temp;
            fi;
        od;
    od;

    res := [];
    for tuple in listOfIndeterminatePowersOf_res do
        Add(res, tuple[1]);
        Add(res, tuple[2]);
    od;

    return res;
end);

# cross product for polynomials in external representation
BindGlobal("WPE_CrossPoly_ExtPoly",
function(p,q)
    local pAsListOfMonomials, qAsListOfMonomials, resultAsSetOfMonomials, mono1,
    mono2, size, i, monomialRep, coeff1, coeff2, res, tuple, temp, newMonomRep, first, last, new_coeff, j;

    pAsListOfMonomials := WPE_ExtPoly_TransformList(p);
    qAsListOfMonomials := WPE_ExtPoly_TransformList(q);

    resultAsSetOfMonomials := Set([]);
    for mono1 in pAsListOfMonomials do
        for mono2 in qAsListOfMonomials do
            temp := [WPE_CrossPoly_Monomials(mono1[1],mono2[1]),
            mono1[2] * mono2[2]];
            while temp in resultAsSetOfMonomials do
                RemoveSet(resultAsSetOfMonomials, temp);
                temp[2] := 2 * temp[2];
            od;
            AddSet(resultAsSetOfMonomials, temp);
        od;
    od;

    # Deduplicate Set
    size := Size(resultAsSetOfMonomials);
    i := 1;
    while i < size do
        first := i;
        monomialRep := resultAsSetOfMonomials[first][1];
        last := Last([1..Length(resultAsSetOfMonomials)], x -> resultAsSetOfMonomials[x][1] = resultAsSetOfMonomials[first][1]);
        new_coeff := Sum([first..last], x -> resultAsSetOfMonomials[x][2]);
        for j in Reversed([first..last]) do
            RemoveSet(resultAsSetOfMonomials,resultAsSetOfMonomials[j]);
        od;
        AddSet(resultAsSetOfMonomials, [monomialRep, new_coeff]);
        i := i + 1;
        size := Size(resultAsSetOfMonomials);
    od;

    res := [];
    for tuple in resultAsSetOfMonomials do
        Add(res, tuple[1]);
        Add(res, tuple[2]);
    od;

    return res;
end);

# cross product for polynomials
BindGlobal("WPE_CrossPoly_Poly",
function(p,q)
    local fam, res;
    fam:=RationalFunctionsFamily(FamilyObj(1));;
    return PolynomialByExtRep(fam,WPE_CrossPoly_ExtPoly(ExtRepPolynomialRatFun(p),ExtRepPolynomialRatFun(q)));
end);

#############################################################################
# Cycle Index for Product Action
#############################################################################

BindGlobal("WPE_CycleIndexPA_Factors",
function(x, i)
    local i_s1, i_s2, factors_i, factors_x, j;

    factors_i := FactorsInt(i);
    factors_x := FactorsInt(x);

    i_s2 := 1;
    for j in Filtered(factors_i, y -> not y in factors_x) do
        i_s2 := i_s2 * j;
    od;

    return [i / i_s2, i_s2];
end);

BindGlobal("WPE_CycleIndexPA_NrTuples",
function(S, i, k)
    local res, T, t, innerSum;

    res := 0;

    for T in Combinations(S) do
        if T = [] then
            continue;
        fi;
        innerSum := 0;
        for t in T do
            innerSum := innerSum + t * k[t];
        od;
        res := res + (-1) ^ (Size(S) - Size(T)) * innerSum ^ i;
    od;

    return res;
end);

# [HH68] Lemma 2.4
# rho = (beta, e, ..., e; sigma_i) wreath cycle:
# - beta has cycle structure k = (k_1, ..., k_m)
# - sigma_i is a i-cycle
# Returns #d-cycles in rho
BindGlobal("WPE_CycleIndexPA_SparseWreathCycle",
function(d, i, k)
    local m, K, res, S, lcmS, data, i_s1, i_s2, j, D;
    m := Sum([1 .. Length(k)], l -> k[l] * l);
    if Length(k) <> m then
        Error("Not a valid cycle type <k>");
    fi;
    K := Filtered([1 .. m], l -> k[l] <> 0);
    res := 0;
    for S in Combinations(K) do
        if S = [] then
            continue;
        fi;
        lcmS := Lcm(S);
        data := WPE_CycleIndexPA_Factors(lcmS, i);
        i_s1 := data[1];
        i_s2 := data[2];
        j := First(DivisorsInt(i_s2), j -> d = j * i_s1 * lcmS);
        if j <> fail then
            D := List(DivisorsInt(j), l -> l * i_s1 * lcmS);
            res := res + Sum(D, t -> WPE_CycleIndexPA_NrTuples(S, t / lcmS, k) * MoebiusMu(d / t));
        fi;
    od;
    return 1 / d * res;
end);

BindGlobal("WPE_CycleIndexPA_Partitions",
function(n)
    local Parts, res, part, hPart, i;

    Parts := Partitions(n);
    res := [];

    for part in Parts do
        hPart := [];
        for i in [1..n] do
            Add(hPart, Number(part, j -> j = i));
        od;
        Add(res, hPart);
    od;

    return res;
end);

# [HH68] Theorem 3.2
# Return cycle index of wreath product with symmetric top group.
BindGlobal("WPE_CycleIndexPA_SymmetricTop",
function(B, n)
    local Z_B, b, m, R, res, J, poly_J, factor, i, polys_i, poly_i, prex, x, mon_k, b_k, k, prey, y, mono, d, poly_pow, _;

    Z_B := ExtRepPolynomialRatFun(CycleIndex(B));
    b := Size(B);
    m := NrMovedPoints(B);
    R := PolynomialRing(Rationals, [1 .. m]);

    # Pre-compute list of inner polynomials
    # Inner iteration over partition of n
    polys_i := EmptyPlist(n);
    for i in [1 .. n] do
        poly_i := Zero(R);

        for prex in [1 .. Length(Z_B) / 2] do
            x := 2 * (prex - 1) + 1;
            mon_k := Z_B[x];
            b_k := Z_B[x + 1] * b;
            # Contains exponents of indeterminates
            k := ListWithIdenticalEntries(m, 0);
            for prey in [1 .. Length(mon_k) / 2] do
                y := 2 * (prey - 1) + 1;
                k[mon_k[y]] := mon_k[y + 1];
            od;

            # Interation over D
            mono := One(R);
            for d in [1 .. m ^ n] do
                mono := mono * Indeterminate(Rationals, d) ^ WPE_CycleIndexPA_SparseWreathCycle(d, i, k);
            od;

            poly_i := poly_i + b_k * mono;
        od;
        Add(polys_i, poly_i);
    od;

    # Outer iteration over partition of n
    res := Zero(R);
    for J in WPE_CycleIndexPA_Partitions(n) do
        factor := 1;
        poly_J := Indeterminate(Rationals, 1);
        for i in [1 .. n] do
            factor := factor * Factorial(J[i]) * (i * b) ^ J[i];

            poly_pow := Indeterminate(Rationals, 1);
            for _ in [1 .. J[i]] do
                poly_pow := WPE_CrossPoly_Poly(poly_pow, polys_i[i]);
            od;

            poly_J := WPE_CrossPoly_Poly(poly_J, poly_pow);
        od;

        res := res + 1 / factor * poly_J;
    od;

    return res;

end);

# [PR73] Theorem 2
# Return cycle index of wreath product with symmetric top group.
BindGlobal("WPE_CycleIndexPA_GenericTop",
function(B, H)
    local Z_H, Z_B, b, h, R, n, m, res, J, poly_J, i, polys_i, poly_i, prex, x, mon_k, b_k, k, prey, y, mono, d, poly_pow, _;

    Z_B := ExtRepPolynomialRatFun(CycleIndex(B));
    Z_H := ExtRepPolynomialRatFun(CycleIndex(H));
    b := Size(B);
    h := Size(H);
    n := Maximum(1, NrMovedPoints(H));
    m := NrMovedPoints(B);
    R := PolynomialRing(Rationals, [1 .. m ^ n]);

    # Pre-compute list of inner polynomials
    # Inner iteration over partition of n
    polys_i := EmptyPlist(n);
    for i in [1 .. n] do
        poly_i := Zero(R);

        for prex in [1 .. Length(Z_B) / 2] do
            x := 2 * (prex - 1) + 1;
            mon_k := Z_B[x];
            b_k := Z_B[x + 1] * b;
            # Contains exponents of indeterminates
            k := ListWithIdenticalEntries(m, 0);
            for prey in [1 .. Length(mon_k) / 2] do
                y := 2 * (prey - 1) + 1;
                k[mon_k[y]] := mon_k[y + 1];
            od;

            # Interation over D
            mono := One(R);
            for d in [1 .. m ^ n] do
                mono := mono * Indeterminate(Rationals, d) ^ WPE_CycleIndexPA_SparseWreathCycle(d, i, k);
            od;

            poly_i := poly_i + b_k * mono;
        od;
        Add(polys_i, poly_i / b);
    od;

    res := Zero(R);
    for prex in [1 .. Length(Z_H) / 2] do
        x := 2 * (prex - 1) + 1;
        mon_k := Z_H[x];
        b_k := Z_H[x + 1];

        # Contains exponents of indeterminates
        k := ListWithIdenticalEntries(n, 0);
        for prey in [1 .. Length(mon_k) / 2] do
            y := 2 * (prey - 1) + 1;
            k[mon_k[y]] := mon_k[y + 1];
        od;

        poly_J := Indeterminate(Rationals, 1);
        for i in [1 .. n] do
            poly_pow := Indeterminate(Rationals, 1);
            for _ in [1 .. k[i]] do
                poly_pow := WPE_CrossPoly_Poly(poly_pow, polys_i[i]);
            od;

            poly_J := WPE_CrossPoly_Poly(poly_J, poly_pow);
        od;

        res := res + poly_J * b_k;
    od;

    return res;
end);

# [Pól37] Pages 178-180
BindGlobal("WPE_CycleIndexIA_GenericTop",
function(B, H)
    local Z_B, Z_H, b, h, n, m, R, polys_i, poly_i, res, prex, x, mon_k, b_k, h_k, k, prey, y, mono, i, j;

    if IsTrivial(B) then
        return CycleIndex(H);
    fi;

    if IsTrivial(H) then
        return CycleIndex(B);
    fi;

    Z_B := ExtRepPolynomialRatFun(CycleIndex(B));
    Z_H := ExtRepPolynomialRatFun(CycleIndex(H));
    b := Size(B);
    h := Size(H);
    n := Maximum(1, NrMovedPoints(H));
    m := NrMovedPoints(B);
    R := PolynomialRing(Rationals, [1 .. m * n]);

    polys_i := EmptyPlist(n);
    for i in [1 .. n] do
        poly_i := Zero(R);

        for prex in [1 .. Length(Z_B) / 2] do
            x := 2 * (prex - 1) + 1;
            mon_k := Z_B[x];
            b_k := Z_B[x + 1];
            # Contains exponents of indeterminates
            k := ListWithIdenticalEntries(m, 0);
            for prey in [1 .. Length(mon_k) / 2] do
                y := 2 * (prey - 1) + 1;
                k[mon_k[y]] := mon_k[y + 1];
            od;

            mono := One(R);
            for j in [1 .. m] do
                mono := mono * Indeterminate(Rationals, j * i) ^ k[j];
            od;

            poly_i := poly_i + b_k * mono;
        od;

        Add(polys_i, poly_i);
    od;

    res := Zero(R);
    for prex in [1 .. Length(Z_H) / 2] do
        x := 2 * (prex - 1) + 1;
        mon_k := Z_H[x];
        h_k := Z_H[x + 1];
        # Contains exponents of indeterminates
        k := ListWithIdenticalEntries(n, 0);
        for prey in [1 .. Length(mon_k) / 2] do
            y := 2 * (prey - 1) + 1;
            k[mon_k[y]] := mon_k[y + 1];
        od;

        mono := One(R);
        for i in [1 .. n] do
            mono := mono * polys_i[i] ^ k[i];
        od;

        res := res + h_k * mono;
    od;

    return res;
end);

InstallGlobalFunction(CycleIndexWreathProductProductAction,
function(K, H)
    if IsNaturalSymmetricGroup(H) then
        return WPE_CycleIndexPA_SymmetricTop(K, Maximum(1, NrMovedPoints(H)));
    else
        return WPE_CycleIndexPA_GenericTop(K, H);
    fi;
end);

InstallGlobalFunction(CycleIndexWreathProductImprimitiveAction,
function(K, H)
    return WPE_CycleIndexIA_GenericTop(K, H);
end);