#
# WreathProductElements: Provides efficient methods for working with generic wreath products.
#
# Implementations
#

InstallGlobalFunction( WPE_ImprimitiveConvertPointToTuple,
function(G, point)
    local info, i;
    info := WreathProductInfo(G);
    for i in [1..info.degI] do
        if point in info.components[i] then
            return [point^info.perms[i], i];
        fi;
    od;
    Error("point not in action set of G");
end);

InstallGlobalFunction( WPE_ImprimitiveConvertTupleToPoint,
function(G, tuple)
    local info, i;
    info := WreathProductInfo(G);
    i := tuple[2];
    return tuple[1]^(info.perms[i]^(-1));
end);

InstallGlobalFunction( WPE_ImprimitiveAction,
function(tuple, x)
    local basePoint, topPoint;
    topPoint := tuple[2]^WPE_TopComponent(x);
    basePoint := tuple[1]^WPE_BaseComponent(x, tuple[2]);
    return [basePoint, topPoint];
end);

InstallGlobalFunction( WPE_ProductAction,
function(tuple, x)
    local sigma;
    sigma := WPE_TopComponent(x)^-1;
    return List( [1 .. Length(tuple)], i -> tuple[i^sigma]^WPE_BaseComponent(x, i^sigma));
end);