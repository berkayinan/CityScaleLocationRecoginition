queryPath='C:\Users\Berkay\Documents\GeoTest\';
trainImagePath='C:\Users\Berkay\Documents\StreetView\';
NpathsParam=1;
branchFactor=8;
returnCount=1000;
close all;
verbose=true;
foundCount=0;
for queryListID=17
    queryID=testGPS(queryListID,1);
    filename=strcat(queryPath,'q(',num2str(queryID),').jpg');
    if verbose==true
        imshow(imread(filename));
    end
    %filename='C:\Users\Berkay\Documents\StreetView\000160_3.jpg';
    queryDescriptors=getDescriptors(imread(filename));
    locationVotes=zeros(5,1000);
    for k=1:size(queryDescriptors,2)
        leafID=greedyNpaths(queryDescriptors(:,k),NpathsParam,tree,branchFactor);
        if(leafID==-1)
            continue;
        end
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
    
    resDist=zeros(1,returnCount);
    for tt=1:returnCount
      if verbose==true
        filename=strcat(trainImagePath,num2str(I_col(tt),'%06.f'),'_',num2str(I_row(tt)),'.jpg');
        figure();
        imshow(imread(filename));
      end
    resDist(tt)=lldistkm(groundTruth,trainGPS(I_col(tt),1:2));
    end
    if(min(resDist)>0.1)
        disp('NOT IN THE TRAINING SET');
    else
        [bestResultDistance,bestResultIndex]=min(resDist(1:10))
        if(bestResultDistance<0.12)
            foundCount=foundCount+1;
        end
    end
    resDist(1:5)*1000

end