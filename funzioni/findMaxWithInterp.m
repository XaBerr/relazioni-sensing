function [yValue, xValue] = findMaxWithInterp( y, x)
    if size(x,1) < size(x, 2)
        x = x.';
    end
    if size(y,1) < size(y, 2)
        y = y.';
    end
    [y, left, right] = cutterGrow(y);
    x = x(left:right);
    if  right - left < 4
        error("Errore i punti sono meno di 4, l'approssimazione non è buona!");
    end
    fitresult = quadraticFit(x, y);
    y = feval(fitresult, x);
    [yValue, pos] = max(y);
    xValue = x(pos);
end

