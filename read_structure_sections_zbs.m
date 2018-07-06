function [nstrsect, ncut, sectname, sectdesc] = read_structure_sections_zbs(path_of_analysis)
% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading


% 2.4 Structure Sections
% File name = ZBS
% File type = binary direct access. Record length = 52 bytes
% 
% One control record, plus one record for each structure section.
% 
% Control record :
% No. of structure sections (integer*4).
% Rest not used.
% 
% Record for each structure section :
% Number of cut elements (integer*4).
% Section name (character*8).
% Section description (character*40).
% 
% The structure section names are always "SC1", "SC2", etc.
% 
% Given the description for a structure section (from the graphic
% interface), search this file to get the section number. The number of cut
% elements can act as a check.

file_name = 'ZBS';
file_path = [path_of_analysis, '\', file_name];
fileID = fopen(file_path);

for i = 1:1
    % Control Record
    nstrsect = fread(fileID, [1,1], 'integer*4');     %Number of structure sections
    
    %temp readings
    temp = fread(fileID, [1,8],  '*char');
    temp = fread(fileID, [1,40], '*char');
end

ncut = zeros(nstrsect,1);
sectname = cell(nstrsect,1);
sectdesc = cell(nstrsect,1);

%For each drift record
for i = 1:nstrsect
    ncut(i,1) = fread(fileID, [1,1], 'integer*4');      %Number of cut elements
    sectname{i,1} = fread(fileID, [1,8],  '*char');     %Section name
    sectdesc{i,1} = fread(fileID, [1,40], '*char');     %Section description
end
fclose(fileID);


end

