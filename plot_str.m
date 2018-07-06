function plot_str(path_of_analysis,pn)


[nelgroup, nelems, nnodsofelems,elemgroupdesc,elgroupnodes] = read_elements_zbe(path_of_analysis);

[nnodes, nodecoord] = read_node_coordinates_zbc(path_of_analysis);


ccodes{1} = [1,0,0];
ccodes{2} = [0,1,0];
ccodes{3} = [0,0,1];
ccodes{4} = [1,0,1];
ccodes{5} = [0,1,1];
ccodes{6} = [1,1,0];
ccodes{7} = [0.5,0.5,0.5];
ccodes{8} = [0,0,0];

if pn == 0
    pn = [1:nelgroup];
end



for i = pn
    
    for j = 1:nelems(i)
        if nnodsofelems(i) == 2
            x = zeros(1,2);
            y = zeros(1,2);
            z = zeros(1,2);
            for k = 1:nnodsofelems(i)
                x(k) = nodecoord(elgroupnodes{i}(j,k),1);
                y(k) = nodecoord(elgroupnodes{i}(j,k),2);
                z(k) = nodecoord(elgroupnodes{i}(j,k),3);
            end
            plot3(x,y,z, 'Color', ccodes{mod(i,length(ccodes))+1});
        elseif nnodsofelems(i) == 4
            xx = zeros(1,5);
            yy = zeros(1,5);
            zz = zeros(1,5);
            for k = 1:nnodsofelems(i)
                xx(k) = nodecoord(elgroupnodes{i}(j,k),1);
                yy(k) = nodecoord(elgroupnodes{i}(j,k),2);
                zz(k) = nodecoord(elgroupnodes{i}(j,k),3);
            end
            xx = [xx(1:2), xx(4), xx(3), xx(1)];
            yy = [yy(1:2), yy(4), yy(3), yy(1)];
            zz = [zz(1:2), zz(4), zz(3), zz(1)];
            plot3(xx,yy,zz, 'Color', ccodes{mod(i,length(ccodes))+1});
        end
        hold on;
    end 
end
%camproj('perspective'); daspect([1 1 1]);
end