neighborList=cell(1,1000);
for i=1:1000
    fprintf('Neighbor %d/1000\n',i);
    for j=1:1000
        if(lldistkm(trainGPS(i,1:2),trainGPS(j,1:2))<0.04)
            if(isempty(neighborList{i}))
                 neighborList{i}=j;
             else
                neighborList{i}=[neighborList{i} j];
            end
        end
    end
end