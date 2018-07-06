function [analys, avemaxsectionforce, aveminsectionforce] = read_structure_sections_zfxxx(path_of_analysis)

% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading

% 5 Structure Sections

% File name = ZFxxx, where xxx = analysis number.
% File type = binary direct access.
% Record length for static analysis = 36 bytes (6 REAL*4, 6 INTEGER*2).
% Record length for dynamic analysis = 60 bytes (6 REAL*4, 6 INTEGER*2, 6 REAL*4).

% Items 1-6 = H1, H2, V forces and H1, H2, V moments.

% These include P-delta effects (which means, for example, that for static
% push-over analysis the H shear may be larger than the H load).
% For dynamic analysis these are static forces only, not including beta-K
% damping forces.

% Items 7-11 = Shear strength D/C ratios, in parts per thousand (% x 10),
% for up to 5 performance levels.

% These are nonzero only if shear strength capacities have been specified.
% To get the D/C ratio, convert to REAL and divide by 1000.

% Item 12 = 0 (not used).

% Items 13-18 (dynamic only) = beta-K forces and moments.

% The file contains NTIM+1 sets of NSSEC records, where
% NTIM = no.of time or load steps (set 1 = state at start of analysis)
% NSSEC = no. of structure sections.

% See *SECTION : STRUCTURE SECTION in ECHO.txt for structure
% section numbers.


nanalysis = read_analysis_number(path_of_analysis);

file_name = cell(nanalysis,1);
file_path = cell(nanalysis,1);

for i = 1:nanalysis
    file_name{i} = ['ZF', num2str(i,'%03u')];
    file_path{i} = [path_of_analysis, '\', file_name{i}];
end

[NSSEC, temp1, temp2, temp3] = read_structure_sections_zbs(path_of_analysis);

analysis_type = [1, 2*ones(1, nanalysis-1)]; % 1: Static, 2: Dynamic

for i = 1:nanalysis
    fileID = fopen(file_path{i});
    eofile = 0;
    j = 1;
    while eofile == 0;
        for k=1:NSSEC
            try
                analys{i,1}.sectionforces{k,1}(j,1:6) =...
                    fread(fileID, [1,6], 'real*4');   % Items 1-6 = H1, H2, V forces and H1, H2, V moments.
                analys{i,1}.sectionforces{k,1}(j,1:5) =...
                    fread(fileID, [1,5], 'integer*2');   % Items 7-11 = Shear strength D/C ratios, in parts per thousand (% x 10),
                temp = fread(fileID, [1,1], 'integer*2');   % Item 12 = 0 (not used).
                if analysis_type(i) == 2
                    analys{i,1}.sectionforces{k,1}(j,1:6) =...
                        fread(fileID, [1,6], 'real*4'); % Items 13-18 (dynamic only) = beta-K forces and moments.
                end
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
    for k = 1:NSSEC
        analys{i,1}.maxsectionforce(k,1:6) = max(analys{i,1}.sectionforces{k,1});
        analys{i,1}.minsectionforce(k,1:6) = min(analys{i,1}.sectionforces{k,1});
    end
end


if nanalysis >=2
    summax = zeros(NSSEC,6);
    summin = zeros(NSSEC,6);
    for i = 2:nanalysis
        summax = summax + analys{i,1}.maxsectionforce;
        summin = summin + analys{i,1}.minsectionforce;
    end
    avemaxsectionforce = summax / (nanalysis - 1);
    aveminsectionforce = summin / (nanalysis - 1);
else
    avemaxsectionforce = analys{i,1}.maxsectionforce;
    aveminsectionforce = analys{i,1}.minsectionforce;
end

end





