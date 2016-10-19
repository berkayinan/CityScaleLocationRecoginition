queryPath='C:\Users\Berkay\Documents\GeoTest\';
for queryID=3:3
    filename=strcat(queryPath,'q(',num2str(queryID),').jpg');
    %filename='C:\Users\Berkay\Documents\StreetView\000442_2.jpg';
    queryDescriptors=getDescriptors(imread(filename));
    locationVotes=zeros(1,1000);
    for k=1:size(queryDescriptors,2)
        leafID=greedyNpaths(queryDescriptors(:,k),8,tree,branchFactor);
        for j=1:length(leafMap{leafID})
            numberOfFeaturesAtThisLocation=length([informativeLocations(leafMap{leafID}(j)).indexes{:}]);
            locationVotes(leafMap{leafID}(j))=locationVotes(leafMap{leafID}(j))+(1/length(leafMap{leafID})*(1/numberOfFeaturesAtThisLocation));
        end
    end
    [sortedVotes,maxIndex]=sort(locationVotes,'descend');
    maxIndex(1:5)
    sortedVotes(1:5)
end