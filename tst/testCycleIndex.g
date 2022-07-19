TestCycleIndexProductAction := function(K, H, p)
    local q;
    q := CycleIndexWreathProductProductAction(K, H);
    return p = ExtRepPolynomialRatFun(q);
end;

TestCycleIndexImprimitiveAction := function(K, H, p)
    local q;
    q := CycleIndexWreathProductImprimitiveAction(K, H);
    return p = ExtRepPolynomialRatFun(q);
end;