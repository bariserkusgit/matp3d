function [nnodes, nodecoord] = read_node_coordinates_zbc(path_of_analysis)

% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading

% 2.1 Node Coordinates

% File name = ZBC
% File type = binary direct access. Record length = 24 bytes

% One control record, plus one record for each node.

% Control record :
% No. of nodes (integer*4).
% Rest not used.

% Record for each node :
% H1 coordinate (real*8).
% H2 coordinate (real*8).
% V coordinate (real*8).

% Given the coordinates of a node, search this file to obtain the node
% number.

file_name = 'ZBC';
file_path = [path_of_analysis, '\', file_name];
fileID = fopen(file_path);


for i=1:1
    %Control Record
    nnodes = fread(fileID, [1,1], 'integer*4');    %Number of nodes
    
    %temp readings
    temp(i,1) = fread(fileID, [1,1], 'integer*4')';  %temp reading
    temp(i,1) = fread(fileID, [1,1], 'real*8')';  %temp reading
    temp(i,1)  = fread(fileID, [1,1], 'real*8')';  %temp reading
end

nodecoord = zeros(nnodes,3);

for i=1:nnodes
    nodecoord(i,1) = fread(fileID, [1,1], 'real*8')';  %H1
    nodecoord(i,2) = fread(fileID, [1,1], 'real*8')';  %H2
    nodecoord(i,3) = fread(fileID, [1,1], 'real*8')';  %Vert
end

fclose(fileID);

end
