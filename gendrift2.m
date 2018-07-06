function [driftgr,driftgrindx,driftgrnodes,driftgrz] =...
    gendrift2(driftcodes, driftcodetype, driftdesc, driftnodes, nodecoord)


ndriftcodes = length(driftcodes);

for j = 1:ndriftcodes
    dc = driftcodes{j};
    dct = driftcodetype(j);
    dd = driftdesc;
    [aa,bb] = gendrift(dc, dd, dct);
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



function [driftgrdesc, driftgrindx] = gendrift(cod, ddes,typ)

% Type = 1 : AC1, AC2 ....
% Type = 2 : AC01, AC02 ....
% Type = 3 : AC_1, AC_2 ....
% Type = 4 : AC_01, AC_02 ....

nchar = length(ddes{1});

dfmt{1} = '%u';
dfmt{2} = '%02u';
dfmt{3} = '_%u';
dfmt{4} = '_%02u';

dmftt = dfmt{typ};

for i = 1:100
    tdd = [cod, num2str(i, dmftt)];
    ntdd = length(tdd);
    nspace = nchar - ntdd;
    
    for j=1:nspace;
        tdd = [tdd, ' '];
    end
    
    dri = find(strcmp(ddes, tdd));
    
    if dri == 0
        break;
    elseif dri ~= 0
        driftgrdesc{i,1} = tdd;
        driftgrindx(i,1) = dri;
    end
end

end