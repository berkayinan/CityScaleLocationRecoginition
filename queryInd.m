queryPath='C:\Users\Berkay\Documents\GeoTest\';
trainImagePath='C:\Users\Berkay\Documents\StreetView\';
NpathsParam=1;
branchFactor=8;
close all;
for queryListID=32
    queryID=testGPS(queryListID,1);
    filename=strcat(queryPath,'q(',num2str(queryID),').jpg');
    imshow(imread(filename));
    %filename='C:\Users\Berkay\Documents\StreetView\000160_3.jpg';
    queryDescriptors=getDescriptors(imread(filename));
    locationVotes=zeros(5,1000);
    for k=1:size(queryDescriptors,2)
        leafID=greedyNpaths(queryDescriptors(:,k),NpathsParam,tree,branchFactor);
        for j=1:length(leafMap{leafID})
            numberOfFeaturesAtThisLocation=length(informativeLocations(leafMap{leafID}(j)).indexes{posMap{leafID}(j)});
            locationVotes(posMap{leafID}(j),leafMap{leafID}(j))=locationVotes(posMap{leafID}(j),leafMap{leafID}(j))+(1/length(leafMap{leafID})*(1/numberOfFeaturesAtThisLocation));
        end
    end
    [sortedVotes,maxIndex]=sort(locationVotes(:),'descend');
    [I_row, I_col] = ind2sub(size(locationVotes),maxIndex);
    groundTruth=testGPS(queryListID,2:3);
    I_col(1:10)'
    I_row(1:10)'
    sortedVotes(1:10)'
    
    for tt=1:8
    filename=strcat(trainImagePath,num2str(I_col(tt),'%06.f'),'_',num2str(I_row(tt)),'.jpg');
    figure();
    imshow(imread(filename));
    end
end