clear all;
trainImagePath='C:\Users\Berkay\Documents\StreetView\';
for subsetID=1:10
    subsetSize=100;
    nPositions=5;
    tic;
    for locationID=((subsetSize*(subsetID-1))+1):(subsetSize*(subsetID))
        locations(locationID).id=locationID;
        fprintf('Location ID: %d\n',locationID);
        for position=1:nPositions
            filename=strcat(trainImagePath,num2str(locationID,'%06.f'),'_',num2str(position),'.jpg');
            locations(locationID).descriptors{position}=getDescriptors(imread(filename));
        end
    end
    filename=strcat('loc',num2str(subsetID));
    SIFT_Time=toc
    save(filename,'locations');
    %%
    %Build subtree
    fprintf('Clustering');
    allDescriptors=cell2mat([locations(((subsetSize*(subsetID-1))+1):(subsetSize*(subsetID))).descriptors]);
    disp(datestr(datetime('now')));
    tic;
    branchFactor=7;
    depth=6;
    nLeaves=branchFactor^depth;
    [tree,asgn]=vl_hikmeans(allDescriptors,branchFactor,nLeaves,'method','elkan');
    cluster_time=toc
    filename=strcat('tree',num2str(subsetID));
    save(filename,'tree','asgn');
    %%
    %Calculate Occurences
    occurence=zeros(nLeaves,subsetSize);
    numberOfImagesInSubTree=subsetSize*nPositions;
    currentAsgnIndex=1;
    tic;
    relativeIndex=1;
    for locationID=((subsetSize*(subsetID-1))+1):(subsetSize*(subsetID))
        fprintf('Entropy: Location ID: %d\n',locationID);
        for position=1:nPositions
            descLen=size(locations(locationID).descriptors{position},2);
            paths=asgn(:,currentAsgnIndex:(currentAsgnIndex+descLen-1));
            currentAsgnIndex=currentAsgnIndex+descLen;
            histogram=vl_hikmeanshist(tree,paths);
            realHistogram=histogram((end-(nLeaves-1)):end);
            occurence(:,relativeIndex)=occurence(:,relativeIndex)+realHistogram;
        end
        relativeIndex=relativeIndex+1;
    end
    Occurance_time=toc
    %%
    %%
    currentAsgnIndex=1;
    infoPercentage=20;
    tic;
    relativeIndex=1;
    for locationID=((subsetSize*(subsetID-1))+1):(subsetSize*(subsetID))
        fprintf('Choose: Location ID: %d\n',locationID);
        for position=1:nPositions
           descLen=size(locations(locationID).descriptors{position},2);
           paths=asgn(:,currentAsgnIndex:(currentAsgnIndex+descLen-1));
           currentAsgnIndex=currentAsgnIndex+descLen;
           linIndex=path2lin(paths,branchFactor);
           entropy=zeros(1,length(linIndex));
           for k=1:length(linIndex)
             totalOcc=sum(occurence(linIndex(k),:));
             entropy(k)=calculateEntropy(numberOfImagesInSubTree,nPositions,occurence(linIndex(k),relativeIndex),totalOcc-occurence(linIndex(k),relativeIndex));
           end
           entropy(isnan(entropy))=-Inf;
           [~,minIndex]=sort(entropy); 
           truncateIndexes=minIndex(1:floor(length(minIndex)*infoPercentage/100));
           informativeLocations(locationID).descriptors{position}=locations(locationID).descriptors{position}(:,truncateIndexes);
           informativeLocations(locationID).indexes{position}=truncateIndexes;
        end
        relativeIndex=relativeIndex+1;
    end
    Info_time=toc
    fprintf('Saving informative features\n');
    tic;
    filenameInfo=strcat('informative',num2str(subsetID));
    save(filenameInfo,'informativeLocations');
    filesave_time=toc
end
%% implement Final Locations,query and you are done.

