function [driftgr,driftgrindx,driftgrnodes,driftgrz] =...
    gendrift(driftcodes, driftcodetype, driftdesc, driftnodes, nodecoord)


ndriftcodes = length(driftcodes);

driftgr = cell(ndriftcodes,1);
driftgrindx = cell(ndriftcodes,1);
driftgrnodes = cell(ndriftcodes,1);
driftgrz = cell(ndriftcodes,1);

for j = 1:ndriftcodes
    dc = driftcodes{j};
    dct = driftcodetype(j);
    dd = driftdesc;
    [aa,bb] = gendriftcodes(dc, dct, dd);
    driftgr{j} = aa;
    driftgrindx{j} = bb;
    
    snode = driftnodes(bb,2);
    enode = driftnodes(bb,1);
    sz = nodecoord(snode, 3);
    ez = nodecoord(enode, 3);
    driftgrnodes{j} = [snode, enode];
    driftgrz{j} = [sz, ez];
    
end

end