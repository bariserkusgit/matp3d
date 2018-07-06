function [sectiongr, sectiongrindx] = gensection(sectioncodes, sectioncodetype, sectiondesc)


nsectioncodes = length(sectioncodes);

sectiongr = cell(nsectioncodes,1);
sectiongrindx = cell(nsectioncodes,1);

for j = 1:nsectioncodes
    sc = sectioncodes{j};
    sct = sectioncodetype(j);
    sd = sectiondesc;
    [aa,bb] = gensectioncodes(sc, sct, sd);
    sectiongr{j} = aa;
    sectiongrindx{j} = bb;    
end

end