function [nelgroup, nelems, nnodsofelems,elemgroupdesc,elgroupnodes] = read_elements_zbe(path_of_analysis)

% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading


% 2.2 Elements
% File name = ZBE
% File type = binary sequential.

% One control record, plus one set of records for each element group.

% Control record :
% No. of element groups (integer*4).

% Records for each element group :
% Record 1 :
% No. of elements in group (integer*4).
% No. of nodes per element (NNOD) (integer*4).
% Element group description (character*40).

% Remaining records : one record for each element in the group.
% NNOD items.
% Item 1 : Node number for Node I (integer*4).
% Item 2 (if needed) : Node number for Node J (integer*4).
% Item 3 (if needed) : Node number for Node K (integer*4).
% Etc.

% Given the coordinates of Node I, etc. for an element, and given the
% Element Group number (or description) , search the ZBD file to get the
% node number(s), then search the ZBE file to get the element number.


file_name = 'ZBE';
file_path = [path_of_analysis, '\', file_name];
fileID = fopen(file_path);


% Control Record
nelgroup = fread(fileID, [1,1], 'integer*4'); %Number of element groups

nelems = zeros(nelgroup,1);
nnodsofelems = zeros(nelgroup,1);
elemgroupdesc = cell(nelgroup,1);
elgroupnodes = cell(nelgroup,1);

for i = 1: nelgroup
    
    nelems(i,1) = fread(fileID, [1,1], 'integer*4');           %No of Elements in group i
    nnodsofelems(i,1) = fread(fileID, [1,1], 'integer*4');     %No of nodes per element (NNOD)
    elemgroupdesc{i,1} = fread(fileID, [1,40], '*char');       %Element group description
    
    
    nodes = zeros(nelems(i),nnodsofelems(i));
    
    %Connectivity
    for j = 1:nelems(i)
        for k = 1:nnodsofelems(i)
            nodes(j,k) = fread(fileID, [1,1], 'integer*4');
        end
    end
    elgroupnodes{i} = nodes;
end

fclose(fileID);

end