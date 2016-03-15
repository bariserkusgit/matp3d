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

clear all; close all;

file_name = 'ZBC';
fileID = fopen(file_name);


for i=1:1
    %Control Record
    nnodes = fread(fileID, [1,1], 'integer*4');    %Number of nodes
    
    %temp readings
    temp.H1(i,1) = fread(fileID, [1,1], 'integer*4',0,'n')';  %temp reading
    temp.H2(i,1) = fread(fileID, [1,1], 'real*8',0,'n')';  %temp reading
    temp.V(i,1)  = fread(fileID, [1,1], 'real*8',0,'n')';  %temp reading
end


for i=1:nnodes
    nodecoord.H1(i,1) = fread(fileID, [1,1], 'real*8',0,'n')';  %temp reading
    nodecoord.H2(i,1) = fread(fileID, [1,1], 'real*8',0,'n')';  %temp reading
    nodecoord.V(i,1)  = fread(fileID, [1,1], 'real*8',0,'n')';  %temp reading
end


fclose(fileID);

nodecoor = [nodecoord.H1, nodecoord.H2, nodecoord.V];
