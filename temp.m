clear all; close all;

load results.mat

anno = 2;
driftno = 30;

for i = 1:nodres{anno,1}.timen
    drif(i,1:3) = nodres{anno,1}.timset{i,1}.disps(driftno,1:3);
    
end

plot(drif(:,3));