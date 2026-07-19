clear; clc; close all;

% Make the dataset in ../data reachable (repo layout: src/ + data/)
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'data'));

fprintf('==== [1/4] Priprema podataka ====\n');
data = prepare_data();

fprintf('\n==== [2/4] Izgradnja Mamdani FIS-a (granice iz podataka) ====\n');
fis = build_mamdani(data);

fprintf('\n==== [3/4] Evaluacija ====\n');
evaluate_mamdani(fis, 