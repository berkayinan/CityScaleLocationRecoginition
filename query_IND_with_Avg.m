queryPath='C:\Users\Berkay\Documents\GeoTest\';
trainImagePath='C:\Users\Berkay\Documents\StreetView\';
NpathsParam=1;
averaging=false;
branchFactor=8;
returnCount=1000;
close all;
verbose=true;
if verbose==true
    returnCount=1000;
end
foundCount=0;
okResult=zeros(1,100);
precision=zeros(100,5000);
tic;
for queryListID=1:100
    fprintf('Query List ID: %d/100\n',queryListID);
    queryID=queryStruct{queryListID}.ID;
    
    if verbose==true
        filename=strcat(queryPath,'q(',num2str(queryID),').jpg');
        imshow(imread(filename));
    end
    %filename='C:\Users\Berkay\Documents\StreetView\000160_3.jpg';
    queryDescriptors=queryStruct{queryListID}.descriptors;
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
    newLocationVotes=zeros(5,1000);
    if averaging==true
        for ii=1:1000                                   %%HARD CODED FOR LOOP, CHANGE IT SOME TIME
            for jj=1:5
                newLocationVotes(jj,ii)=sum(sum(locationVotes(:,neighborList{ii})))/size(neighborList{ii},2);
            end
        end
    else
        newLocationVotes=locationVotes;
    end
    [sortedVotes,maxIndex]=sort(newLocationVotes(:),'descend');
    [I_row, I_col] = ind2sub(size(newLocationVotes),maxIndex);
    groundTruth=testGPS(queryListID,2:3);
    if verbose==true
        I_col(1:10)'
        I_row(1:10)'
        sortedVotes(1:10)'
    end
    resDist=zeros(1,5000); %%HC
    for tt=1:5000
     resDist(tt)=lldistkm(groundTruth,trainGPS(I_col(tt),1:2));
    end
    
    if(min(resDist)>0.08)
        disp('NOT IN THE TRAINING SET');
    else
        goodResult=find(resDist<0.08);
        if(isempty(goodResult)==0)
              okResult(queryListID)=goodResult(1);
              precision(queryListID,:)=resDist<0.08;
        end
        if(goodResult(1)==1)
            disp('found');
        end
        %fprintf('Good result: %d\n',goodResult(1));      
    end

    if verbose==true
        fprintf('Distances for first 5\n')
        resDist(1:5)*1000
        for tt=1:5
            filename=strcat(trainImagePath,num2str(I_col(tt),'%06.f'),'_',num2str(I_row(tt)),'.jpg');
            figure();
            imshow(imread(filename));
         end
    end

end
test_Time=toc