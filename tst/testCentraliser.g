TestCentraliser := function(G, g, Cgens)
    local C;
    C := Centraliser(G, g);
    if C <> Group(Cgens) then
        return false;
    fi;
    return true;
end;