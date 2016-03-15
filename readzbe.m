

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

clear all; close all;

fileID = fopen('ZBE');

% Control Record
nelgroup = fread(fileID, [1,1], 'integer*4'); %Number of element groups


for i = 1: nelgroup
    
    elgroup(i).nels = fread(fileID, [1,1], 'integer*4');     %No of Elements in group i
    elgroup(i).nnod = fread(fileID, [1,1], 'integer*4');     %No of nodes per element (NNOD)
    elgroup(i).desc = char(fread(fileID, [1,40], 'char*1')); %Element group description
    
    for j = 1:elgroup(i).nels
        for k = 1:elgroup(i).nnod
            elgroup(i).elemnode(j,k) = fread(fileID, [1,1], 'integer*4');
        end
    end
end
fclose(fileID);