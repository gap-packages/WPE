#############################################################################
##  WreathProductElements.gi
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
# Membership test for elements
#############################################################################


BindGlobal( "WPE_IN",
function(g, G)
    local l, grps, K, H;
    l := ListWreathProductElement(G, g);
    if l = fail then
        return false;
    fi;
    grps := ComponentsOfWreathProduct(G);
    K := grps[1];
    H := grps[2];
    return ForAll([1 .. Length(l) - 1], i -> l[i] in K) and l[Length(l)] in H;
end);

# InstallMethod( \in, "perm, and perm wreath product", true,[IsObject, IsPermGroup and HasWreathProductInfo], OVERRIDENICE + 42, WPE_IN);
# InstallMethod( \in, "matrix, and matrix wreath product", true, [IsMatrix, IsMatrixGroup and HasWreathProductInfo], OVERRIDENICE + 42, WPE_IN);


#############################################################################
# Isomorphism to generic wreath product
#############################################################################


# Dirty Hack
BindGlobal( "WPE_GenericWreathProduct_GAP", ApplicableMethod(WreathProduct,
    [DihedralGroup(8), SymmetricGroup(3), IdentityMapping(SymmetricGroup(3))]
));

BindGlobal( "WPE_GenericWreathProduct",
function(args...)
    local K, H, phi;
    if Length(args) < 2 or Length(args) > 3 then
        ErrorNoReturn("Unknown number of arguments");
    fi;
    K := args[1];
    H := args[2];
    if Length(args) = 3 then
        phi := args[3];
    else
        phi := IdentityMapping(H);
    fi;
    return WPE_GenericWreathProduct_GAP(K, H, phi);
end);


InstallMethod( IsomorphismWreathProduct, "wreath products", true, [HasWreathProductInfo], 1,
function(G)
    local grps, W, typ, iso;
    grps := ComponentsOfWreathProduct(G);
    if not IsPermGroup(grps[2]) then
        ErrorNoReturn("Top group of <G> must be a permutation group");
    fi;
    W := WPE_GenericWreathProduct(grps[1], grps[2]);
    iso := GroupHomomorphismByFunction(G, W,
           g-> WreathProductElementList(W, ListWreathProductElement(G, g)),
           x -> WreathProductElementList(G, ListWreathProductElement(W, x)));
    return iso;
end);


#############################################################################
# Printing of elements
#############################################################################


# Default options, immutable entries
BindGlobal( "WPE_DisplayOptionsDefault", Immutable(rec(
    horizontal := true,
    labels := true,
    labelStyle := "none",
    labelColor := "default",
)));

# Current options, mutable entries
BindGlobal( "WPE_DisplayOptions", ShallowCopy(WPE_DisplayOptionsDefault));

InstallGlobalFunction( DisplayOptionsForWreathProductElements,
function()
    Display(WPE_DisplayOptions);
end);

BindGlobal( "WPE_SetDisplayOptions",
function(optionsBase, optionsUpdate)
    local r;
    for r in RecNames(optionsUpdate) do
        if not IsBound(optionsBase.(r)) then
            ErrorNoReturn("Invalid option to Display: ", r);
        fi;
        if r = "labelStyle" and not optionsUpdate.(r) in ["none", "bold", "faint"] then
            ErrorNoReturn("Invalid value to labelStyle: ", optionsUpdate.(r));
        fi;
        if r = "labelColor" and not optionsUpdate.(r) in ["default", "red", "blue"] then
            ErrorNoReturn("Invalid value to labelStyle: ", optionsUpdate.(r));
        fi;
        optionsBase.(r) := optionsUpdate.(r);
    od;
end);

BindGlobal("WPE_SetLabelFont",
function(options)
    # Intensity
    if options.labelStyle = "bold" then
        WriteAll(STDOut, "\033[1m");
    elif options.labelStyle = "faint" then
        WriteAll(STDOut, "\033[2m");
    fi;
    # Color
    if options.labelColor = "red" then
        WriteAll(STDOut, "\033[31m");
    elif options.labelColor = "blue" then
        WriteAll(STDOut, "\033[34m");
    fi;
end);

BindGlobal("WPE_IsLabelFontDefault",
function(options)
    return options.labelStyle = "none" and options.labelColor = "default";
end);

InstallGlobalFunction( SetDisplayOptionsForWreathProductElements,
function(options)
    WPE_SetDisplayOptions(WPE_DisplayOptions, options);
end);

InstallGlobalFunction( ResetDisplayOptionsForWreathProductElements,
function()
    SetDisplayOptionsForWreathProductElements(WPE_DisplayOptionsDefault);
end);

InstallMethod( ViewObj, "wreath elements", true, [IsWreathProductElement], 1,
function(x)
    local degI;
    degI := WPE_TopDegree(x);
    Print("< wreath product element with ", degI, " base components >");
end);

InstallMethod( PrintObj, "wreath elements", true, [IsWreathProductElement], 1,
function(x)
    local i,L,tenToL,degI;
    degI := WPE_TopDegree(x);
    Print("[ ");
    for i in [1..degI] do
        Print(String(WPE_BaseComponent(x, i)));
        if i < degI then
            Print(", ");
        fi;
    od;
    Print(", ",String(WPE_TopComponent(x))," ]");
end);

InstallMethod( Display, "wreath elements", true, [IsWreathProductElement], 1,
function(x)
    Display(x, rec());
end);

InstallOtherMethod( Display, "wreath elements, and a record", [IsWreathProductElement, IsRecord],
function(x, options)
    local displayOptions, r, degI, widthScreen, strElms, bufferLabels, bufferLines, widthLines,
          bufferElm, blanks, prefix, suffix, i, j, k, d, L, tenToL, line, label;

    # setting display options
    displayOptions := ShallowCopy(WPE_DisplayOptions);
    WPE_SetDisplayOptions(displayOptions, options);

    degI := WPE_TopDegree(x);
    widthScreen := SizeScreen()[1] - 2;

    # string representations of each component
    strElms := EmptyPlist(degI + 1);
    for i in [1..degI] do
        strElms[i] := String(WPE_BaseComponent(x, i));
    od;
    strElms[degI + 1] := String(WPE_TopComponent(x));

    # Print horizontally
    if displayOptions.horizontal then
        bufferLines := ["( "];
        widthLines := 2;
        blanks := Concatenation(List([1..widthLines], k -> " "));
        if displayOptions.labels then
            bufferLabels := blanks;
        fi;
        # Print Components
        for i in [1..degI + 1] do
            # Add prefix
            if widthLines = Length(blanks) then
                prefix := "";
            else
                prefix := " ";
            fi;
            # Add element to buffer
            bufferElm := strElms[i];
            # Add suffix
            suffix := "";
            if i < degI then
                suffix := ",";
            elif i = degI then
                suffix := ";";
            fi;
            # Element does not fit into the line, hence print and clear buffer
            if Length(prefix) + Length(bufferElm) + Length(suffix) + widthLines > widthScreen then
                WPE_SetLabelFont(displayOptions);
                if displayOptions.labels then
                    if Length(bufferLabels) > Length(blanks) then
                        Print(bufferLabels, "\n");
                    fi;
                fi;
                WriteAll(STDOut, "\033[0m");
                if widthLines > Length(blanks) then
                    for line in bufferLines do
                        Print(line, "\n");
                    od;
                fi;
                if displayOptions.labels then
                    if Length(bufferLabels) > Length(blanks) then
                        Print("\n");
                    fi;
                fi;
                # The element is long, thus we need inline breaks.
                # Print element directly and start clean buffer for next element.
                if Length(bufferElm) + Length(suffix) > widthScreen then
                    if displayOptions.labels then
                        if i <= degI then
                            label := String(i);
                        else
                            label := "top";
                        fi;
                        Print(Concatenation(List([1 .. Int((widthScreen - Length(label) - Length(blanks)) / 2) + Length(blanks)], k -> " ")), label, "\n");
                    fi;
                    j := 1;
                    d := widthScreen - Length(blanks) - 3;
                    bufferElm := Concatenation(bufferElm, suffix);
                    while j <= Length(bufferElm) do
                        k := Minimum(Length(bufferElm), j + d);
                        if j > 1 then
                            Print("\\\n");
                        fi;
                        # special case, if element does not fit into first line
                        if j = 1 and bufferLines[1] = "( " then
                            Print("( ", bufferElm{[j..k]});
                        else
                            Print(blanks, bufferElm{[j..k]});
                        fi;
                        j := k + 1;
                    od;

                    # extra space between labels and element
                    if displayOptions.labels and i <= degI then
                        Print("\n");
                    fi;

                    Print("\n");
                    bufferLines := [blanks];
                    widthLines := Length(blanks);
                    bufferLabels := blanks;
                # The element is short, hence add it to the clean buffer
                else
                    bufferLines := [Concatenation(blanks, bufferElm, suffix)];
                    widthLines := Length(blanks) + Length(bufferElm) + Length(suffix);
                    if displayOptions.labels then
                        if i <= degI then
                            label := String(i);
                        else
                            label := "top";
                        fi;
                        d := Int((Length(bufferElm) - Length(label)) / 2);
                        bufferLabels := Concatenation(
                            blanks,
                            Concatenation(List([1 .. d], k -> " ")),
                            label,
                            Concatenation(List([1 .. Length(bufferElm) + Length(suffix) - Length(label) - d], k -> " "))
                        );
                    fi;
                fi;
            # The element fits into the line, thus we add it to buffer
            else
                bufferLines[1] := Concatenation(bufferLines[1], prefix, bufferElm, suffix);
                widthLines := widthLines + Length(prefix) + Length(bufferElm) + Length(suffix);
                if displayOptions.labels then
                    if i <= degI then
                        label := String(i);
                    else
                        label := "top";
                    fi;
                    d := Int((Length(bufferElm) - Length(label)) / 2);
                    bufferLabels := Concatenation(
                        bufferLabels,
                        prefix,
                        Concatenation(List([1 .. d], k -> " ")),
                        label,
                        Concatenation(List([1 .. Length(bufferElm) + Length(suffix) - Length(label) - d], k -> " "))
                    );
                fi;
            fi;
        od;
        # Print suffix
        bufferElm := " )";
        if Length(bufferElm) + widthLines < widthScreen then
            bufferLines[1] := Concatenation(bufferLines[1], bufferElm);
        else
            Append(bufferLines, bufferElm);
        fi;
        WPE_SetLabelFont(displayOptions);
        if displayOptions.labels then
            Print(bufferLabels, "\n");
        fi;
        WriteAll(STDOut, "\033[0m");
        for line in bufferLines do
            Print(line, "\n");
        od;
    # Print vertically
    else
        # Length of Largest Number
        L := 1;
        tenToL := 10;
        while tenToL <= degI do
            L := L + 1;
            tenToL := tenToL * 10;
        od;
        L := Maximum(3, L);
        if displayOptions.labels then
            blanks := Concatenation(List([1 .. L + 2], k -> " "));
        else
            blanks := Concatenation(List([1 .. 2], k -> " "));
        fi;
        # Print Components
        for i in [1..degI + 1] do
            WPE_SetLabelFont(displayOptions);
            if displayOptions.labels then
                if i <= degI then
                    label := i;
                else
                    label := "top";
                fi;
                # Hack for test suite
                if WPE_IsLabelFontDefault(displayOptions) then
                    Print(String(label, L) , ": ");
                else
                    WriteAll(STDOut, String(label, L));
                    WriteAll(STDOut, ": ");
                fi;
            fi;
            WriteAll(STDOut, "\033[0m");
            # The element might be too long, thus we need inline breaks.
            bufferElm := strElms[i];
            j := 1;
            d := widthScreen - Length(blanks) - 3;
            while j <= Length(bufferElm) do
                k := Minimum(Length(bufferElm), j + d);
                if j = 1 then
                    Print(bufferElm{[j..k]});
                else
                    Print("\\\n", blanks, bufferElm{[j..k]});
                fi;
                j := k + 1;
            od;
            Print("\n");
        od;
    fi;
end);


#############################################################################
# (Sparse) Wreath Cycles
#############################################################################


InstallTrueMethod( IsWreathCycle, IsSparseWreathCycle );
InstallTrueMethod( IsWreathProductElement, IsWreathCycle );

BindGlobal( "WPE_IsWreathCycle",
function(x)
    local degI, suppTop;

    degI := WPE_TopDegree(x);

    # wreath cycle of base type
    if IsOne(WPE_TopComponent(x)) then
        if Number([1 .. degI], i -> not IsOne(WPE_BaseComponent(x, i))) = 1 then
            SetIsSparseWreathCycle(x, true);
            return true;
        else
            return false;
        fi;
    fi;

    # wreath cycle of top type
    suppTop := MovedPoints(WPE_TopComponent(x));
    if Length(CycleStructurePerm(WPE_TopComponent(x))) + 1 <> Length(suppTop) then
        return false;
    fi;

    return ForAll([1 .. degI], i -> i in suppTop or IsOne(WPE_BaseComponent(x, i)));
end);

InstallMethod( IsWreathCycle, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    return WPE_IsWreathCycle(x);
end);

InstallOtherMethod( IsWreathCycle, "list rep of wreath elements", true, [IsList], 0,
function(x)
    return WPE_IsWreathCycle(x);
end);

BindGlobal( "WPE_IsSparseWreathCycle",
function(x)
    local info, terr, min;
    if IsWreathCycle(x) then
        info := FamilyObj(x)!.info;
        terr := Territory(x);
        return Number(terr, i -> not IsOne(WPE_BaseComponent(x, i))) <= 1;
    else
        return false;
    fi;
end);

InstallMethod( IsSparseWreathCycle, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    return WPE_IsSparseWreathCycle(x);
end);

InstallOtherMethod( IsSparseWreathCycle, "list rep of wreath elements", true, [IsList], 0,
function(x)
    return WPE_IsSparseWreathCycle(x);
end);


#############################################################################
# Wreath Product Element Attributes
#############################################################################


BindGlobal( "WPE_Territory",
function(x)
    local degI, suppTop, suppBase;

    degI := WPE_TopDegree(x);
    suppTop := MovedPoints(WPE_TopComponent(x));
    suppBase := Filtered([1..degI], i -> not IsOne(WPE_BaseComponent(x, i)));
    return Set(Concatenation(suppTop, suppBase));
end);

InstallMethod( Territory, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    return WPE_Territory(x);
end);

InstallOtherMethod( Territory, "list rep of wreath elements", true, [IsList], 0,
function(x)
    return WPE_Territory(x);
end);

BindGlobal( "WPE_ChooseYadePoint",
function(x)
    return Minimum(Territory(x));
end);

BindGlobal( "WPE_Yade",
function(x, i)
    local ord;

    if not i in Territory(x) then
        Error("i not in territory of x");
    fi;

    ord := Order(WPE_TopComponent(x));

    return Product([0 .. ord-1], k -> WPE_BaseComponent(x, i ^ (WPE_TopComponent(x) ^ k)));
end);

InstallMethod( Yade, "wreath cycle wreath elements", true, [IsWreathCycle], 1,
function(x)
    return WPE_Yade(x, WPE_ChooseYadePoint(x));
end);

InstallOtherMethod( Yade, "list rep of wreath cycle", true, [IsList], 1,
function(x)
    return WPE_Yade(x, WPE_ChooseYadePoint(x));
end);

InstallOtherMethod( Yade, "wreath cycle wreath elements", true, [IsWreathCycle, IsInt], 1,
function(x, i)
    return WPE_Yade(x, i);
end);

InstallOtherMethod( Yade, "list rep of wreath cycle wreath elements", true, [IsList, IsInt], 1,
function(x, i)
    return WPE_Yade(x, i);
end);

#############################################################################
# Wreath Cycle Decomposition
#############################################################################

InstallMethod( WreathCycleDecomposition, "generic wreath elements", true, [IsWreathCycle], 1, function(x) return [x]; end);

InstallMethod( WreathCycleDecomposition, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    local
      info,             # wreath product info
      degI,             # degree of top group
      decomposition,    # wreath cycle decomposition of x
      suppTop,          # support of top component, list
      suppBase,         # non-trivial base component indices, list
      id,               # identity vector
      i,                # index point, loop var
      wreathCycle,      # wreath cycle, loop var
      topCycleList,     # cycle decomposition of top component, list
      topCycle;         # cycle of top component, loop var

    # initialization
    info := FamilyObj(x)!.info;
    degI := WPE_TopDegree(x);
    suppTop := MovedPoints(WPE_TopComponent(x));
    suppBase := Filtered([1 .. degI], i -> not IsOne(WPE_BaseComponent(x, i)));
    id := ListWithIdenticalEntries(degI, One(WPE_BaseComponent(x, 1)));
    Add(id, One(WPE_TopComponent(x)));
    decomposition := [];

    # wreath cycles that are of base type
    for i in Filtered(suppBase, x -> not x in suppTop) do
        wreathCycle := ShallowCopy(id);
        wreathCycle[i] := WPE_BaseComponent(x, i);
        wreathCycle := Objectify(info.family!.defaultType,wreathCycle);

        SetIsSparseWreathCycle(wreathCycle,true);
        Add(decomposition, wreathCycle);
    od;

    # wreath cycles that are of top type
    if IsEmpty(suppTop) then
        return decomposition;
    fi;
    topCycleList := Cycles(WPE_TopComponent(x), suppTop);
    for topCycle in topCycleList do
        wreathCycle := ShallowCopy(id);
        wreathCycle[degI + 1] := CycleFromList(topCycle);
        for i in topCycle do
            wreathCycle[i] := WPE_BaseComponent(x, i);
        od;
        wreathCycle := Objectify(info.family!.defaultType,wreathCycle);

        SetIsWreathCycle(wreathCycle,true);
        Add(decomposition, wreathCycle);
    od;

    return decomposition;
end);

InstallOtherMethod( WreathCycleDecomposition, "list rep of wreath elements", true, [IsList], 0,
function(x)
    local
      degI,             # degree of top group
      decomposition,    # wreath cycle decomposition of x
      suppTop,          # support of top component, list
      suppBase,         # non-trivial base component indices, list
      id,               # identity vector
      i,                # index point, loop var
      wreathCycle,      # wreath cycle, loop var
      topCycleList,     # cycle decomposition of top component, list
      topCycle;         # cycle of top component, loop var

    # initialization
    degI := Length(x) - 1;
    suppTop := MovedPoints(WPE_TopComponent(x));
    suppBase := Filtered([1 .. degI], i -> not IsOne(WPE_BaseComponent(x, i)));
    id := ListWithIdenticalEntries(degI, One(WPE_BaseComponent(x, 1)));
    Add(id, One(WPE_BaseComponent(x, degI + 1)));
    decomposition := [];

    # wreath cycles that are of base type
    for i in Filtered(suppBase, x -> not x in suppTop) do
        wreathCycle := ShallowCopy(id);
        wreathCycle[i] := WPE_BaseComponent(x, i);

        Add(decomposition, wreathCycle);
    od;

    # wreath cycles that are of top type
    if IsEmpty(suppTop) then
        return decomposition;
    fi;
    topCycleList := Cycles(WPE_TopComponent(x), suppTop);
    for topCycle in topCycleList do
        wreathCycle := ShallowCopy(id);
        wreathCycle[degI + 1] := CycleFromList(topCycle);
        for i in topCycle do
            wreathCycle[i] := WPE_BaseComponent(x, i);
        od;

        Add(decomposition, wreathCycle);
    od;

    return decomposition;
end);

#############################################################################
# Sparse Wreath Cycle Decomposition
#############################################################################

InstallMethod( SparseWreathCycleConjugate, "sparse wreath cycle wreath elements", true, [IsSparseWreathCycle], 2, function(x) return [x]; end);

InstallMethod( SparseWreathCycleConjugate, "wreath cycle wreath elements", true, [IsWreathCycle], 1,
function(x)
    local info, degI, yade, i, sparseWreathCycle;

    info := FamilyObj(x)!.info;
    degI := WPE_TopDegree(x);
    yade := Yade(x);
    i := Minimum(Territory(x));
    sparseWreathCycle := ListWithIdenticalEntries(degI, One(WPE_BaseComponent(x, 1)));
    Add(sparseWreathCycle, WPE_TopComponent(x));
    sparseWreathCycle[i] := yade;

    SetIsSparseWreathCycle(sparseWreathCycle, true);

    return [Objectify(info.family!.defaultType,sparseWreathCycle)];
end);

InstallMethod( SparseWreathCycleConjugate, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    local decomposition;

    decomposition := WreathCycleDecomposition(x);
    return Concatenation(List(decomposition, SparseWreathCycleConjugate));
end);

InstallOtherMethod( SparseWreathCycleConjugate, "list rep of wreath elements", true, [IsList], 1,
function(w)
    local decomposition, sparseDecomposition, degI, yade, i, l, sparseWreathCycle, x;

    decomposition := WreathCycleDecomposition(w);
    sparseDecomposition := EmptyPlist(Length(decomposition));

    for l in [1 .. Length(decomposition)] do
        x := decomposition[l];
        degI := WPE_TopDegree(x);
        yade := Yade(x);
        i := Minimum(Territory(x));
        sparseWreathCycle := ListWithIdenticalEntries(degI, One(WPE_BaseComponent(x, 1)));
        Add(sparseWreathCycle, WPE_TopComponent(x));
        sparseWreathCycle[i] := yade;

        sparseDecomposition[l] := sparseWreathCycle;
    od;

    return sparseDecomposition;
end);

InstallMethod( ConjugatorWreathCycleToSparse, "sparse wreath cycle wreath elements", true, [IsSparseWreathCycle], 2, function(x) return [One(x)]; end);

InstallMethod( ConjugatorWreathCycleToSparse, "wreath cycle wreath elements", true, [IsWreathCycle], 1,
function(x)
    local info, degI, i, j, min, yade, ord, k, y, conj;

    info := FamilyObj(x)!.info;
    degI := WPE_TopDegree(x);
    ord := Order(WPE_TopComponent(x));
    i := WPE_ChooseYadePoint(x);
    min := Minimum(Territory(x));
    yade := Yade(x);
    conj := ListWithIdenticalEntries(degI, One(WPE_BaseComponent(x, 1)));
    Add(conj, One(WPE_TopComponent(x)));
    y := One(WPE_BaseComponent(x, 1));
    j := i;
    for k in [1..ord] do
        y := WPE_BaseComponent(x, j) ^ -1 * y;
        if j = min then
            y := y * yade;
        fi;
        j := i^(WPE_TopComponent(x) ^ k);
        conj[j] := y;
    od;

    return [Objectify(info.family!.defaultType,conj)];
end);

InstallMethod( ConjugatorWreathCycleToSparse, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    local decomposition;

    decomposition := WreathCycleDecomposition(x);
    return Concatenation(List(decomposition, ConjugatorWreathCycleToSparse));
end);

InstallOtherMethod( ConjugatorWreathCycleToSparse, "list rep of wreath elements", true, [IsList], 1,
function(w)
    local decomposition, conjDecomposition, degI, i, j, l, min, yade, ord, k, y, conj, x;

    decomposition := WreathCycleDecomposition(w);
    conjDecomposition := EmptyPlist(Length(decomposition));

    for l in [1 .. Length(decomposition)] do
        x := decomposition[l];
        degI := WPE_TopDegree(x);
        ord := Order(WPE_TopComponent(x));
        i := WPE_ChooseYadePoint(x);
        min := Minimum(Territory(x));
        yade := Yade(x);
        conj := ListWithIdenticalEntries(degI, One(WPE_BaseComponent(x, 1)));
        Add(conj, One(WPE_TopComponent(x)));
        y := One(WPE_BaseComponent(x, 1));
        j := i;
        for k in [1..ord] do
            y := WPE_BaseComponent(x, j) ^ -1 * y;
            if j = min then
                y := y * yade;
            fi;
            j := i^(WPE_TopComponent(x) ^ k);
            conj[j] := y;
        od;
        conjDecomposition[l] := conj;
    od;
    return conjDecomposition;
end);

#############################################################################
# Components
#############################################################################

InstallGlobalFunction( ComponentsOfWreathProduct,
function(W)
    if not HasWreathProductInfo(W) then
        return Error("W is not a wreath product");
    fi;
    return Immutable(WreathProductInfo(W).groups);
end);

InstallGlobalFunction( TopComponentOfWreathProductElement,
function(x)
    if not IsWreathProductElement(x) then
        return Error("x is not a wreath product element");
    fi;
    return WPE_TopComponent(x);
end);

BindGlobal( "WPE_TopComponent_Elm",
function(x)
    return x![WPE_TopDegree(x) + 1];
end);

InstallMethod( WPE_TopComponent, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    return WPE_TopComponent_Elm(x);
end);

InstallOtherMethod( WPE_TopComponent, "list rep of wreath elements", true, [IsList], 0,
function(x)
    return WPE_TopComponent_Elm(x);
end);

InstallGlobalFunction( TopGroupOfWreathProduct,
function(W)
    if not HasWreathProductInfo(W) then
        return Error("W is not a wreath product");
    fi;
    return WPE_TopGroup(W);
end);

InstallMethod( WPE_TopGroup, "wreath product", true, [HasWreathProductInfo], 0,
function(W)
    return Image(Embedding(W, WPE_TopDegree(W) + 1));
end);

InstallMethod( WPE_TopDegree, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    local info;

    info := FamilyObj(x)!.info;
    return info.degI;
end);

InstallOtherMethod( WPE_TopDegree, "list rep of wreath elements", true, [IsList], 0,
function(x)
    return Length(x) - 1;
end);

InstallOtherMethod( WPE_TopDegree, "wreath product", true, [HasWreathProductInfo], 0,
function(W)
    local info;

    info := WreathProductInfo(W);
    return info.degI;
end);

InstallGlobalFunction( BaseComponentOfWreathProductElement,
function(arg)
    local degI, x, i;

    if Length(arg) > 2 then
        return Error("wrong number of arguments");
    fi;
    x := arg[1];
    if not IsWreathProductElement(x) then
        return Error("x is not a wreath product element");
    fi;
    degI := WPE_TopDegree(x);
    if Length(arg) = 1 then
        return WPE_BaseComponent(x);
    else
        i := arg[2];
        if not IsInt(i) then
            return Error("i must be an integer");
        fi;
        if i < 1 or i > degI then
        return Error("Index out of bounds");
        fi;
        return WPE_BaseComponent(x, i);
    fi;
end);

BindGlobal( "WPE_BaseComponent_Elm",
function(x)
    local degI;

    degI := WPE_TopDegree(x);
    return List([1 .. degI], i -> WPE_BaseComponent(x, i));
end);

InstallMethod( WPE_BaseComponent, "generic wreath elements", true, [IsWreathProductElement], 0,
function(x)
    return WPE_BaseComponent_Elm(x);
end);

InstallOtherMethod( WPE_BaseComponent, "list rep of wreath elements", true, [IsList], 0,
function(x)
    return WPE_BaseComponent_Elm(x);
end);

BindGlobal( "WPE_BaseComponent_ElmAndInt",
function(x, i)
    return x![i];
end);

InstallOtherMethod( WPE_BaseComponent, "generic wreath elements and integer", true, [IsWreathProductElement, IsInt], 0,
function(x, i)
    return WPE_BaseComponent_ElmAndInt(x, i);
end);

InstallOtherMethod( WPE_BaseComponent, "list rep of wreath elements", true, [IsList, IsInt], 0,
function(x, i)
    return WPE_BaseComponent_ElmAndInt(x, i);
end);

InstallGlobalFunction( BaseGroupOfWreathProduct,
function(arg)
    local degI, W, i;

    if Length(arg) > 2 then
        return Error("wrong number of arguments");
    fi;
    W := arg[1];
    if not HasWreathProductInfo(W) then
        return Error("W is not a wreath product");
    fi;
    degI := WPE_TopDegree(W);
    if Length(arg) = 1 then
        return WPE_BaseGroup(W);
    else
        i := arg[2];
        if not IsInt(i) then
            return Error("i must be an integer");
        fi;
        if i < 1 or i > degI then
            return Error("Index out of bounds");
        fi;
        return WPE_BaseGroup(W, i);
    fi;
end);

InstallMethod( WPE_BaseGroup, "wreath product", true, [HasWreathProductInfo], 0,
function(W)
    local info, degI, grps;

    info := WreathProductInfo(W);
    degI := WPE_TopDegree(W);
    grps := ComponentsOfWreathProduct(W);
    if not IsBound(info.base) then
        info.base := Group(Concatenation(List([1 .. degI], i -> List(GeneratorsOfGroup(grps[1]), x -> x ^ Embedding(W, i)))));
    fi;
    return info.base;
end);

InstallOtherMethod( WPE_BaseGroup, "wreath product and integer", true, [HasWreathProductInfo, IsInt], 0,
function(W, i)
    return Image(Embedding(W, i));
end);
