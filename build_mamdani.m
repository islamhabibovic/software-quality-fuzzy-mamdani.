function fis = build_mamdani(data)
    if nargin < 1, daa = prepare_data(); end

    fis = mamfis('Name', 'SWQuality_Mamdani', ...
                 'AndMethod','min','OrMethod','max', ...
                 'ImplicationMethod','min','AggregationMethod','max', ...
                 'DefuzzificationMethod','centroid');

    inputs = {'Maintainability','Complexity','Reliability'};
    for i = 1:numel(inputs)
        v = data.(inputs{i});
        p25 = pctl(v,25); p50 = pctl(v,50); p75 = pctl(v,75);
        lo = min(v); hi = max(v);
        fis = addInput(fis, [0 100], 'Name', inputs{i});
        
        fis = addMF(fis, inputs{i}, 'trapmf', [lo lo p25 p50], 'Name','Low');
        fis = addMF(fis, inputs{i}, 'trimf',  [p25 p50 p75],   'Name','Medium');
        fis = addMF(fis, inputs{i}, 'trapmf', [p50 p75 hi hi],  'Name','High');
        fprintf('%-16s MF granice iz podataka: p25=%.1f p50=%.1f p75=%.1f\n', inputs{i}, p25, p50, p75);
    end

    
    fis = addOutput(fis, [0 100], 'Name', 'Quality');
    fis = addMF(fis,'Quality','trapmf',[0 0 10 25],   'Name','VeryLow');
    fis = addMF(fis,'Quality','trimf', [15 30 45],    'Name','Low');
    fis = addMF(fis,'Quality','trimf', [35 50 65],    'Name','Medium');
    fis = addMF(fis,'Quality','trimf', [55 70 85],    'Name','High');
    fis = addMF(fis,'Quality','trapmf',[75 90 100 100],'Name','VeryHigh');

    
    ruleList = [
        1 1 1 3 1 1; 1 1 2 3 1 1; 1 1 3 4 1 1;
        1 2 1 2 1 1; 1 2 2 3 1 1; 1 2 3 3 1 1;
        1 3 1 1 1 1; 1 3 2 2 1 1; 1 3 3 2 1 1;
        2 1 1 4 1 1; 2 1 2 4 1 1; 2 1 3 5 1 1;
        2 2 1 3 1 1; 2 2 2 3 1 1; 2 2 3 4 1 1;
        2 3 1 2 1 1; 2 3 2 2 1 1; 2 3 3 3 1 1;
        3 1 1 5 1 1; 3 1 2 5 1 1; 3 1 3 5 1 1;
        3 2 1 4 1 1; 3 2 2 4 1 1; 3 2 3 5 1 1;
        3 3 1 3 1 1; 3 3 2 3 1 1; 3 3 3 4 1 1];
    fis = addRule(fis, ruleList);

    writeFIS(fis, 'SWQuality_Mamdani');
    fprintf('build_mamdani: FIS sa %d pravila kreiran i sacuvan.\n', numel(fis.Rules));
end
