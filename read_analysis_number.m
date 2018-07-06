function [nanalysis] = read_analysis_number(path_of_analysis)

% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading


file_name = 'ZC*';
file_path = [path_of_analysis, '\', file_name];
nanalysis = length(dir(file_path));
