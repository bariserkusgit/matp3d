% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading

clear all; close all;

% Folder Information
dirloc = 'E:\completed\Ova';

analysisdirectory =  'NLTH-001';

dirs = dir(dirloc);
nmodels = length(dirs)-2;

dirnames = cell(nmodels,1);
andirpath= cell(nmodels,1);
model = cell(nmodels,1);
andir = cell(nmodels,1);

% Set Analysis Directory for Each Model
for i = 1:nmodels
    andir{i} = 'NLTH-001';
end

for i = 1:nmodels
    dirnames{i} = dirs(i+2).name;
    andirpath{i} = [dirloc, '\', dirnames{i}, '\', andir{i}];
end

%Save Drift Info to Mat file:
%driftfile = 'zorludriftresults.mat';
%sectionfile = 'zorlusectionresults.mat';

driftfile = 'ovadriftresults.mat';
sectionfile = 'ovasectionresults.mat';


%Drift Definitions

%driftcodetemp = {'X01S', 'Y01S'}; driftcodetypetemp = [2,2];

driftcodetemp = {'P01-H1-', 'P01-H2-'}; driftcodetypetemp = [2,2];

for i = 1:nmodels
    model{i}.driftcodes = driftcodetemp;
    model{i}.driftcodetype = driftcodetypetemp;
end


%model{3}.driftcodes = {'A', 'A_H2'}; model{3}.driftcodetype = [1,4];
%model{4}.driftcodes = {'A', 'A_H2'}; model{4}.driftcodetype = [1,4];

% Type = 1 : AC1, AC2 ....
% Type = 2 : AC01, AC02 ....
% Type = 3 : AC_1, AC_2 ....
% Type = 4 : AC_01, AC_02 ....
%
% dfmt{1} = '%u';
% dfmt{2} = '%02u';
% dfmt{3} = '_%u';
% dfmt{4} = '_%02u';

driftgrtocompare = repmat([1,2],nmodels,1);

% ...     % Column numbers are the drifts groups to compare
%     [1, 2, 1, 2;...   %1. Model
%     1, 2, 3, 4;...    %2. Model.
%     1, 2, 1, 2];      %3. Model.

ndriftgrtocompare = size(driftgrtocompare,2);


%Sections Definitions

sectioncodetemp = {'W-ALL-'}; sectioncodetypetemp = [2];
%sectioncodetemp = {'CORE'}; sectioncodetypetemp = [3];

for i = 1:nmodels
    model{i}.sectioncodes = sectioncodetemp;
    model{i}.sectioncodetype = sectioncodetypetemp;
end

sectiongrtocompare = repmat([1],nmodels,1);
nsectiongrtocompare = size(sectiongrtocompare,2);

% Get Data
for i = 1:nmodels
    
    [model{i}.nstrsect, model{i}.ncut, model{i}.sectname, model{i}.sectdesc] =...
        read_structure_sections_zbs(andirpath{i});
    
    [model{i}.ndrift, model{i}.driftnodes, model{i}.driftname, model{i}.driftdesc] =...
        read_drifts_zbd(andirpath{i});
    
    [model{i}.nnodes, model{i}.nodecoord] = read_node_coordinates_zbc(andirpath{i});
    
    model{i}.nanalysis = read_analysis_number(andirpath{i});
    
    [model{i}.nelgroup, model{i}.nelems, model{i}.nnodsofelems,...
        model{i}.elemgroupdesc, model{i}.elgroupnodes] =...
        read_elements_zbe(andirpath{i});
    
end


%Rearrangement of Drifts Based on the Given Drift Codes and Groups
for i = 1:nmodels
    ndriftcodes(i) = length(model{i}.driftcodes);
    model{i}.ndriftcodes = ndriftcodes(i);
    
    dc = model{i}.driftcodes;
    dct = model{i}.driftcodetype;
    dd = model{i}.driftdesc;
    dn = model{i}.driftnodes;
    nc = model{i}.nodecoord;
    
    [model{i}.driftgr, model{i}.driftgrindx, model{i}.driftgrnodes, model{i}.driftgrz] =...
        gendrift(dc,dct,dd,dn,nc);
    
end

%Read Drifts and Save to MAT file
if ~exist(driftfile)
    for i = 1:nmodels
        [aaa{i}.driftres, aaa{i}.avemaxdrift, aaa{i}.avemindrift] = read_node_drifts_zdxxx(andirpath{i});
        save (driftfile, 'aaa');
    end
else
    load(driftfile);
end

for i = 1:nmodels
    model{i}.driftres = aaa{i}.driftres;
    model{i}.avemaxdrift = aaa{i}.avemaxdrift;
    model{i}.avemindrift = aaa{i}.avemindrift;
    for j = 1: model{i}.ndriftcodes
        dindx = model{i}.driftgrindx{j};
        model{i}.driftgravemax{j} = aaa{i}.avemaxdrift(dindx);
        model{i}.driftgravemin{j} = aaa{i}.avemindrift(dindx);
    end
    
end

%Rearrangement of Section Forces Based on the Given Section Codes and Groups
for i = 1:nmodels
    nsectioncodes(i) = length(model{i}.sectioncodes);
    model{i}.nsectioncodes = nsectioncodes(i);
    
    sc = model{i}.sectioncodes;
    sct = model{i}.sectioncodetype;
    sd = model{i}.sectdesc;
    
    [model{i}.sectiongr, model{i}.sectiongrindx] = gensection(sc,sct,sd);
    
end

%Read Structure Sections Save to MAT File
if ~exist(sectionfile)
    for i = 1:nmodels
        [bbb{i}.sectionres, bbb{i}.avemaxsectionforce, bbb{i}.aveminsectionforce] = read_structure_sections_zfxxx(andirpath{i});
        save (sectionfile, 'bbb');
    end
else
    load(sectionfile);
end


for i = 1:nmodels
    model{i}.sectionres = bbb{i}.sectionres;
    model{i}.avemaxsection = bbb{i}.avemaxsectionforce;
    model{i}.aveminsection = bbb{i}.aveminsectionforce;
    for j = 1: model{i}.nsectioncodes
        dindx = model{i}.sectiongrindx{j};
        model{i}.sectiongravemax{j} = bbb{i}.avemaxsectionforce(dindx,:);
        model{i}.sectiongravemin{j} = bbb{i}.aveminsectionforce(dindx,:);
    end
    
end


% for i = 1:nmodels
%    figure; plot_str(andirpath{i}, 0);
% end


mgtc = 1;
%modelgroupstocompare{mgtc} = [1, 2];
%modelgroupstocompare{mgtc} = [1,3,5,7,9]; mgtc = mgtc+1;
%modelgroupstocompare{mgtc} = [2,4,6,8,10];  mgtc = mgtc+1;
%modelgroupstocompare{mgtc} = [1,2];  mgtc = mgtc+1;
%modelgroupstocompare{mgtc} = [3,4]; mgtc = mgtc+1;
%modelgroupstocompare{mgtc} = [5,6]; mgtc = mgtc+1;
%modelgroupstocompare{mgtc} = [7,8]; mgtc = mgtc+1;
%modelgroupstocompare{mgtc} = [9,10]; mgtc = mgtc+1;
%modelgroupstocompare{mgtc} = [8,10]; mgtc = mgtc+1;
%modelgroupstocompare{mgtc} = [7,9]; mgtc = mgtc+1;
modelgroupstocompare{mgtc} = [1:10];

plotcol = cell(10,1);

for ii = 1:2:9 
plotcol{ii} = 'k';
plotcol{ii+1} = 'b';
end


% Plot Drifts
%
% for k = 1:length(modelgroupstocompare)
% for j = 1:ndriftgrtocompare
%     figure; hold on;
%     titl = '';
%     for i = 1:nmodels
%
%         drindx = driftgrtocompare(i,j);
%
%         drz0 = model{i}.driftgrz{drindx}';
%         drz = drz0(:);
%         drz = drz - min(drz);
%
%         avemax0 = model{i}.driftgravemax{drindx}';
%         avemax0 = [avemax0;avemax0];
%         avemax = avemax0(:);
%
%             curdirectory = dirnames{i};
%             plot(avemax, drz);
%             titl = [titl, curdirectory, ': ', model{i}.driftcodes{drindx}, ' ,'];
%         title(titl);
%     end
% legend(dirnames{modelgroupstocompare{k}});
% end
% end
%
for k = 1:length(modelgroupstocompare)
    for j = 1:ndriftgrtocompare
        figure; hold on;
        titl = '';
        for i = modelgroupstocompare{k}

            drindx = driftgrtocompare(i,j);

            drz0 = model{i}.driftgrz{drindx};
            drz = drz0(:,1);
            drz = drz - min(drz);

            avemax = model{i}.driftgravemax{drindx};
            curdirectory = dirnames{i};
            plot(avemax, drz, plotcol{i});
%            titl = [titl, curdirectory, ': ', model{i}.driftcodes{drindx}, ' ,'];
        end
        titl = [model{i}.driftcodes{1}];
        title(titl);
        legend(dirnames{modelgroupstocompare{k}});
    end
end



sectforcestoplot = [2,5];
sectforcenames{1} = 'F_X';
sectforcenames{2} = 'F_Y';
sectforcenames{3} = 'F_Z';
sectforcenames{4} = 'M_X';
sectforcenames{5} = 'M_Y';
sectforcenames{6} = 'M_Z';

%Plot Section Forces

% for k = 1:length(modelgroupstocompare)
%     for j = 1:nsectiongrtocompare
%         for s = 1:sectforcestoplot
%             figure; hold on;
%             titl = '';
%             for i = modelgroupstocompare{k}
%                 
%                 secindx = sectiongrtocompare(i,j);
%                 avemax = model{i}.sectiongravemax{secindx};
%                 
%                 drindx = driftgrtocompare(i,j);
%                 drz0 = model{i}.driftgrz{drindx};
%                 drz = drz0(:,1);
%                 drz = drz - min(drz);
%                 curdirectory = dirnames{i};
%                 
%                 plot(avemax(:,s), drz, plotcol{i});
% %               titl = [titl, curdirectory, ': ', model{i}.sectioncodes{secindx},sectforcenames{s}, ', '];
% 
%             end
%             titl = [model{i}.sectioncodes{1}, sectforcenames{s}];
%             title(titl);            
%             legend(dirnames{modelgroupstocompare{k}});
%         end
%     end
% end


