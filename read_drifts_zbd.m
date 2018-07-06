function [ndrift, driftnodes, driftname, driftdesc] = read_drifts_zbd(path_of_analysis)

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


file_name = 'ZBD';
file_path = [path_of_analysis, '\', file_name];
fileID = fopen(file_path);

for i = 1:1
    % Control Record
    ndrift = fread(fileID, [1,1], 'integer*4');     %Number of drifts
    
    %temp readings
    temp = fread(fileID, [1,1], 'integer*4');      
    temp = fread(fileID, [1,1], 'integer*4');      
    temp = fread(fileID, [1,1], 'integer*4');      
    temp = fread(fileID, [1,8],  '*char');     
    temp = fread(fileID, [1,40], '*char');     
end

driftnodes = zeros(ndrift,4);
driftname = cell(ndrift,1);
driftdesc = cell(ndrift,1);

%For each drift record
for i = 1:ndrift
    driftnodes(i,1) = fread(fileID, [1,1], 'integer*4');      %Upper or Node I
    driftnodes(i,2) = fread(fileID, [1,1], 'integer*4');      %Lower or Node J
    driftnodes(i,3) = fread(fileID, [1,1], 'integer*4');      %Node K number
    driftnodes(i,4) = fread(fileID, [1,1], 'integer*4');      %Node L number
    driftname{i,1} = fread(fileID, [1,8],  '*char');     %Drift name
    driftdesc{i,1} = fread(fileID, [1,40], '*char');     %Drift description
end
fclose(fileID);


end