% PERFORM 3D Binary Files Reader
% by Baris Erkus
%
% Please read the license before use.
%
% ver 0.01
%     Basic reading


clear all; close all;

load('sections.mat');
load('section_spec.mat');

section_type = 'CORE';
section_no = 5;

lensectdesc = 40;

section_description = [section_type, '_', num2str(section_no)];
nsd = length(section_description);
nspace = lensectdesc - nsd;

for i=1:nspace;
    section_description = [section_description, ' '];
end

sect_index = find(strcmp(strsect.sectdesc, section_description)); % single line engine


summax = zeros(nstrsect, 6);
summin = zeros(nstrsect, 6);

for i=2:8;
    for j = 1:nstrsect;
        analys{i,1}.maxforce(j,:) = max(analys{i,1}.section{j,1}.forces);
        analys{i,1}.minforce(j,:) = min(analys{i,1}.section{j,1}.forces);
    end
    summax = summax + analys{i,1}.maxforce;
    summin = summin + analys{i,1}.minforce;
    
    avemax = summax/7;
    avemin = summin/7;

end


gray_level = 0.5;

for ind =1:2;
    
    sect_gr = 4:4+42;
    
    %figure; plot(analys{2,1}.section{sect_index,1}.forces(:,ind));
    figure; hold on;
    for i = 2:8;
        plot(sect_gr, analys{i,1}.minforce(sect_gr,ind), 'color', gray_level*ones(1,3));
        plot(sect_gr, analys{i,1}.maxforce(sect_gr,ind), 'color', gray_level*ones(1,3));
    end
    plot(sect_gr, avemin(sect_gr,ind), 'k', sect_gr, avemax(sect_gr,ind), 'k', 'LineWidth', 2 );
    grid on;
    title(['H',num2str(ind)]);
    
end

for ind =1:2;
    
    sect_gr = 4:4+42;
    
    %figure; plot(analys{2,1}.section{sect_index,1}.forces(:,ind));
    figure; hold on;
    for i = 2:8;
        plot(sect_gr, analys{i,1}.minforce(sect_gr,ind), 'color', gray_level*ones(1,3));
        plot(sect_gr, analys{i,1}.maxforce(sect_gr,ind), 'color', gray_level*ones(1,3));
    end
    plot(sect_gr, avemin(sect_gr,ind), 'k', sect_gr, avemax(sect_gr,ind), 'k', 'LineWidth', 2 );
    grid on;
    title(['H',num2str(ind)]);
    
end