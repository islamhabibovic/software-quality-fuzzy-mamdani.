function fisOpt = optimize_mamdani(fis, data)
if nargin < 2, data = prepare_data(); end
if nargin < 1, fis = build_mamdani(data); end
X = [data.Maintainability, data.Complexity, data.Reliability];
Y = data.Quality;
c = [10 30 50 70 90];
e0 = rmse_fis(setc(fis, c), X, Y);
fprintf('RMSE prije: %.3f\n', e0);
s = 8;
for it = 1:60
    imp = false;
    for k = 1:5
        for d = [-s, s]
            t = c; t(k) = t(k) + d;
            e = rmse_fis(setc(fis, t), X, Y);
            if e < e0, e0 = e; c = t; imp = true; end
        end
    end
    if ~imp, s = s/2; end
    if s < 0.5, break; end
end
fisOpt = setc(fis, c);
fprintf('RMSE poslije: %.3f\n', e0);
writeFIS(fisOpt, 'SWQuality_opt');

function e = rmse_fis(f, X, Y)
e = sqrt(mean((evalfis(f, X) - Y).^2));

function f = setc(fis, c)
c = sort(min(max(c, 0), 100));
f = fis;
mf = f.Outputs(1).MembershipFunctions;
mf(1).Parameters = [0 0 c(1) c(2)];
mf(2).Parameters = [c(1) c(2) c(3)];
mf(3).Parameters = [c(2) c(3) c(4)];
mf(4).Parameters = [c(3) c(4) c(5)];
mf(5).Parameters = [c(4) c(5) 100 100];
f.Outputs(1).MembershipFunctions = mf;