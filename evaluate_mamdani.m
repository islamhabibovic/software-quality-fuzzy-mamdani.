function evaluate_mamdani(fis, data)
    if nargin < 2, data = prepare_data(); end
    if nargin < 1, fis  = build_mamdani(data); end

    X = [data.Maintainability, data.Complexity, data.Reliability];
    fuzzyQ = evalfis(fis, X);
    prob   = data.prob_ratio;
    defect = data.DefectClass;        

    
    R = corrcoef(fuzzyQ, prob); r = R(1,2);
    fprintf('\n=== SLAGANJE ===\n');
    fprintf('r(fuzzy Quality, prob_ratio) = %.3f (negativan = vise kvaliteta -> manje problema)\n', r);

   
    thr  = median(fuzzyQ);
    pred = double(fuzzyQ < thr);
    TP = sum(pred==1 & defect==1); TN = sum(pred==0 & defect==0);
    FP = sum(pred==1 & defect==0); FN = sum(pred==0 & defect==1);
    acc  = (TP+TN)/numel(defect);
    prec = TP/max(TP+FP,1); rec = TP/max(TP+FN,1);
    f1   = 2*prec*rec/max(prec+rec,eps);
    fprintf('\n=== KLASIFIKACIJA (prag fuzzyQ = %.1f) ===\n', thr);
    fprintf('Accuracy=%.3f  Precision=%.3f  Recall=%.3f  F1=%.3f\n', acc, prec, rec, f1);
    fprintf('Confusion: TP=%d FN=%d FP=%d TN=%d\n', TP, FN, FP, TN);
    fprintf('NAPOMENA: separacija je trivijalna jer postoje samo 2 projekta.\n');

   
    fprintf('\n=== UTICAJ ULAZA (korelacija sa prob_ratio) ===\n');
    names = {'Maintainability','Complexity','Reliability'};
    for i = 1:3
        Ri = corrcoef(X(:,i), prob);
        fprintf('  %-16s r = %+.3f\n', names{i}, Ri(1,2));
    end

   
    figure('Position',[100 100 1200 360]);
    base = median(X,1); xs = 0:5:100; cols = {'b','r',[0 0.5 0]};
    for i = 1:3
        subplot(1,3,i); y = zeros(size(xs));
        for k = 1:numel(xs)
            inp = base; inp(i) = xs(k); y(k) = evalfis(fis, inp);
        end
        plot(xs, y, 'LineWidth', 2.5, 'Color', cols{i}); grid on; ylim([0 100]);
        xlabel(names{i}); ylabel('Quality'); title(['Senzitivnost: ' names{i}]);
    end
    sgtitle('Kvantitativna analiza uticaja ulaza na kvalitet','FontWeight','bold');
    saveas(gcf, 'fig_v2_senzitivnost.png');

    
    figure('Position',[100 100 640 480]);
    gensurf(fis, gensurfOptions('InputIndex',[1 2],'OutputIndex',1, ...
            'ReferenceInputs',[NaN NaN base(3)],'NumGridPoints',[20 20]));
    title('Quality(Maintainability, Complexity)'); view(45,30); colorbar;
    saveas(gcf, 'fig_v2_surface.png');

  
    figure('Position',[100 100 560 420]);
    scatter(prob, fuzzyQ, 70, 'filled'); grid on;
    xlabel('% problematicnih klasa (stvarno)'); ylabel('Fuzzy Quality');
    title(sprintf('Fuzzy ocjena vs problemi (r = %.2f)', r));
    saveas(gcf, 'fig_v2_scatter.png');

    fprintf('\nevaluate_mamdani: gotovo (fig_v2_*.png sacuvani).\n');
end
