% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading


% 2.3 Drifts

% File name = ZBD
% File type = binary direct access. Record length = 64 bytes

% One control record, plus one record for each drift.

% Control record :
% No. of drifts (integer*4).
% Rest not used.

% Record for each drift :
% Upper, or Node I, number (integer*4).
% Lower, or Node J, number (integer*4).
% Node K number (integer*4). Zero for a simple drift.
% Node L number (integer*4). Zero for a simple drift.
% Drift name (character*8).
% Drift description (character*40).

% The drift names are always "DR1", "DR2", etc.

% Given the description for a drift (from the graphic interface), search this
% file to get the drift number. Alternatively, given the coordinates of the
% nodes that define the drift, search the ZBC file to get the node numbers,
% then search the ZBD file to get the drift number.


clear all; close all;
file_name = 'ZBD';
fileID = fopen(file_name);

for i = 1:1
    % Control Record
    ndrift = fread(fileID, [1,1], 'integer*4');     %Number of drifts
    
    %temp readings
    temp.lower(i,1) = fread(fileID, [1,1], 'integer*4');      
    temp.nodeK(i,1) = fread(fileID, [1,1], 'integer*4');      
    temp.nodeL(i,1) = fread(fileID, [1,1], 'integer*4');      
    temp.driftname{i,1} = fread(fileID, [1,8],  '*char');     
    temp.driftdesc{i,1} = fread(fileID, [1,40], '*char');     
end

%For each drift record
for i = 1:ndrift
    drift.upper(i,1) = fread(fileID, [1,1], 'integer*4');      %Upper or Node I
    drift.lower(i,1) = fread(fileID, [1,1], 'integer*4');      %Lower or Node J
    drift.nodeK(i,1) = fread(fileID, [1,1], 'integer*4');      %Node K number
    drift.nodeL(i,1) = fread(fileID, [1,1], 'integer*4');      %Node L number
    drift.driftname{i,1} = fread(fileID, [1,8],  '*char');     %Drift name
    drift.driftdesc{i,1} = fread(fileID, [1,40], '*char');     %Drift description
end
fclose(fileID);

drift.nodes=[drift.upper, drift.lower, drift.nodeK, drift.nodeL];