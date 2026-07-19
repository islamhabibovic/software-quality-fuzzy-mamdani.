function y = pctl(x, p)
    x = sort(x(~isnan(x)));
    n = numel(x);
    if n == 0, y = NaN; return; end
    if n == 1, y = x(1); return; end
    pos = (p/100) * (n - 1) + 1;
    lo = floor(pos); hi = ceil(pos); frac = pos - lo;
    y = x(lo) + frac * (x(hi) - x(lo));
end
