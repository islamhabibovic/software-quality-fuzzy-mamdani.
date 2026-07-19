function data = prepare_data()
    opts = detectImportOptions('versions.csv', 'VariableNamingRule', 'preserve');
    T = readtable('versions.csv', opts);

   
    LOC  = T{:,5};    
    NOC  = T{:,6};    
    NOP  = T{:,7};    
    EXTC = T{:,9};    
    PROB = T{:,10};   
    repo = string(T{:,2});
    ver  = string(T{:,3});

    
    ok = ~isnan(LOC) & ~isnan(NOC) & ~isnan(NOP) & ~isnan(EXTC) & ~isnan(PROB);
    LOC=LOC(ok); NOC=NOC(ok); NOP=NOP(ok); EXTC=EXTC(ok); PROB=PROB(ok);
    repo=repo(ok); ver=ver(ok);

    
    avg_class_size = LOC ./ NOC;     
    pkg_density    = NOC ./ NOP;     
    ext_coupling   = EXTC ./ NOC;    
    prob_ratio     = PROB ./ NOC * 100;   

    sc = @(x) (x - min(x)) ./ (max(x) - min(x)) * 100;   

    Maintainability = 100 - sc(pkg_density);   
    Complexity      = sc(avg_class_size);      
    Reliability     = 100 - sc(ext_coupling);  
    Quality         = 100 - sc(prob_ratio);    
    DefectClass     = double(prob_ratio > median(prob_ratio));  

    data = table(repo, ver, Maintainability, Complexity, Reliability, ...
                 prob_ratio, Quality, DefectClass);
    writetable(data, 'quality_versions.csv');
    fprintf('prepare_data: %d upotrebljivih verzija (%d projekta).\n', height(data), numel(unique(repo)));
end
