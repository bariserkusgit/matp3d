function [analys, avemaxdrift, avemindrift] = read_node_drifts_zdxxx(path_of_analysis)

% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading


% 4 Node Results, Including Drifts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4.1 Drifts

% File name = ZDxxx, where xxx = analysis number.
% File type = binary direct access.
% Record length = 12 bytes (3 REAL*4). Same for static and dynamic
% analysis.

% Item 1 = current drift value.
% Item 2 = maximum positive value of this drift to this point
% Item 3 = maximum negative value.

% The file contains NTIM+1 sets of NDRFT records, where NTIM = no.
% of time or load steps (set 1 = state at start of analysis) and NDRFT =
% no. of drifts.

% See *DRIFT : HORIZONTAL DRIFTS in ECHO.txt for drift numbers.

% See *NODE : NODE COORDINATES in ECHO.txt for node numbers.


nanalysis = read_analysis_number(path_of_analysis);

for i = 1:nanalysis
    file_name{i} = ['ZD', num2str(i,'%03u')];
    file_path{i} = [path_of_analysis, '\', file_name{i}];
end

[NDRFT, temp1, temp2, temp3] = read_drifts_zbd(path_of_analysis);


for i = 1:nanalysis
    fileID = fopen(file_path{i});
    eofile = 0;
    
    j = 1;
    while eofile == 0;
        for k=1:NDRFT
            try
                analys{i,1}.drift{k,1}(j,1:3) = fread(fileID, [1,3], 'real*4');
                %nodres{i,1}.timset{j,1}.drift(k,1:3) = fread(fileID, [1,3], 'real*4');
            catch
                eofile = 1;
                analys{i,1}.timen = j-1;
                disp(['End of file reached. Data No: ', num2str(analys{i,1}.timen)]);
                break;
            end
            
        end
        
        j = j+1;
    end    
    fclose(fileID);
end

for i = 1:nanalysis
    for k = 1:NDRFT
        analys{i,1}.maxdrift(k,1) = analys{i,1}.drift{k,1}(end,2);
        analys{i,1}.mindrift(k,1) = analys{i,1}.drift{k,1}(end,3);
    end
end


if nanalysis >=2
    summax = zeros(NDRFT,1);
    summin = zeros(NDRFT,1);
    for i = 2:nanalysis
        summax = summax + analys{i,1}.maxdrift;
        summin = summin + analys{i,1}.mindrift;
    end
    avemaxdrift = summax / (nanalysis - 1);
    avemindrift = summin / (nanalysis - 1);
else
    avemaxdrift = analys{i,1}.maxdrift;
    avemindrift = analys{i,1}.mindrift;
end

end


