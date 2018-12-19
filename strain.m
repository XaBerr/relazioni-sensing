function y = strain( deltaM, c0, n, f1, f2)
    y = (c0 / n * (1 / f1 - 1 / f2)) / deltaM;
end