clear all; close all;

load nodedrifts.mat

anno = 4;
driftno = 45;

for i = 1:nodres{anno,1}.timen
    drif(i,1:3) = nodres{anno,1}.timset{i,1}.drift(driftno,1:3);
    
end

plot(drif(:,3));