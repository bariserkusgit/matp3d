% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading


% Modal properties are saved only for the unloaded state (State 000).
% Modal properties are normalized to fi'*M*fi = 1, where fi = mode shape
% matrix and M = mass matrix.

% File name = ZK000
% File type = binary direct access. Record length = 24 bytes

% One control record, plus one set of records for each mode shape.

% Control record :
% No. of mode shapes (integer*2).
% Total H1 mass, in mass units (real*4).
% Total H2 mass, in mass units (real*4).
% Total V mass, in mass units (real*4).
% Rest not used.

% Records for each mode shape :

% Record 1 :
% Mode period, seconds (real*4).
% Rest not used.

% Record 2 :
% H1 mass participation factor (real*4).
% H2 mass participation factor (real*4).
% V mass participation factor (real*4).
% Rest not used.

% Next NNODS records, where NNODS = no. of nodes : mode shape :
% H1 translation, in global displacement units (real*4).
% H2 translation, in global displacement units (real*4).
% V translation, in global displacement units (real*4).
% H1 rotation, in radians (real*4).
% H2 rotation, in radians (real*4).
% H3 rotation, in radians (real*4).

% Next NSSEC records, where NSSEC = no. of structure sections :
% H1 force on section, in global force units (real*4).
% H2 force, in global force units (real*4).
% V force, in global force units (real*4).
% H1 moment, in global force and displacement units (real*4).
% H2 moment, in global force and displacement units (real*4).
% V moment, in global force and displacement units (real*4).

% Next NDRFT records, where NDRFT = no. of drifts :
% Drift ratio (real*4).
% Rest not used.
% Repeat for next mode shape.


clear all; close all;
file_name = 'ZK000';
fileID = fopen(file_name);

for i = 1:1
    % Control Record
    nmode = fread(fileID, [1,1], 'integer*2');    % No. of mode shapes (integer*2).
    massH1 = fread(fileID, [1,1], 'real*4');      % Total H1 mass, in mass units (real*4).
    massH2 = fread(fileID, [1,1], 'real*4');      % Total H2 mass, in mass units (real*4).
    massV = fread(fileID, [1,1], 'real*4');       % Total V mass, in mass units (real*4).
    
    mass = [massH1, massH2, massV];
end
fclose(fileID);

fileID = fopen(file_name);
temp(1,1:6) = fread(fileID, [1,6], 'real*4');


%For each mode shape
for i = 1:nmode
    modes(i).T = fread(fileID, [1,1], 'real*4');   %Mode period, seconds (real*4).
    
    for ii=1:5
        temp = fread(fileID, [1,1], 'real*4');
    end
    
    modes(i).mpfH1 = fread(fileID, [1,1], 'real*4');      % H1 mass participation factor (real*4).
    modes(i).mpfH2 = fread(fileID, [1,1], 'real*4');      % H2 mass participation factor (real*4).
    modes(i).mpfV  = fread(fileID, [1,1], 'real*4');      % V mass participation factor (real*4).
    temp = fread(fileID, [1,3], 'real*4');        % Temp
    
    modes(i).mpf = [modes(i).mpfH1, modes(i).mpfH2, modes(i).mpfV];
    
    for j = 1:2786
        modes(i).disp(j,1:6) = fread(fileID, [1,6], 'real*4');
    end
    
    for k = 1:175
        modes(i).force(k,1:6) = fread(fileID, [1,6], 'real*4');
    end
    
    for k = 1:88
        modes(i).drift(k,1) = fread(fileID, [1,1], 'real*4');
        temp = fread(fileID, [1,5], 'real*4');        % Temp
    end
    
end
fclose(fileID);
























