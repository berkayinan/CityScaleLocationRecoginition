leafMap=cell(1,size(asgn,2));
relIndex=1;
for locationID=1:1000
    fprintf('Mapping Location %d\n',locationID);
    for position=1:nPositions
        for i=1:size(informativeLocations(locationID).descriptors{position},2)
             lin=path2lin(asgn(:,relIndex),branchFactor);
             relIndex=relIndex+1;
             if(isempty(leafMap{lin}))
                 leafMap{lin}=locationID;
             else
                leafMap{lin}=[leafMap{lin} locationID];
             end
        end
    end
end