% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01



clear all; close all;

fileID = fopen('ZBC');
A = fread(fileID, [1,1], 'integer*4'); %Control Record
fclose(fileID);

fileID = fopen('ZBC');
B = fread(fileID, [3,A+1], 'real*8',0,'n')';
fclose(fileID);