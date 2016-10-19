function [ leafID ] = greedyNpaths( queryDescriptor,N,tree,branchFactor)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    depth=tree.depth;
    K=tree.K;
    distances=vl_alldist(double(queryDescriptor),double(tree.centers));
    [~,minIndex]=sort(distances);
    currentTree=tree.sub(minIndex(1:N));
    currentPaths=zeros(depth,N);
    currentPaths(1,:)=minIndex(1:N);
    tempPaths=currentPaths;
    tempTree=currentTree;
    centerList=zeros(128,N*K);
    for curDepth=2:depth-1
        for i=1:N
            centerList(:,((i-1)*K+1):(i*K))=currentTree(i).centers;%check
        end
        distances=vl_alldist(double(queryDescriptor),centerList);
        [~,minIndex]=sort(distances);
        for i=1:N
            tempTree(i)=currentTree(ceil(minIndex(i)/K)).sub(mod(minIndex(i)-1,K)+1);
            tempPaths(:,i)=currentPaths(:,ceil(minIndex(i)/K));
            tempPaths(curDepth,i)=mod(minIndex(i)-1,K)+1;
        end
        currentTree=tempTree;
        currentPaths=tempPaths;
    end
    %%Find the final word
    lastCenterList=[];
    trackTree=[];
    trackChild=[];
    for i=1:N
       % currentTree(i).centers
        %centerList(:,((i-1)*K+1):(i*K))=currentTree(i).centers;%check
        lastCenterList=[lastCenterList,currentTree(i).centers];
        trackTree=[trackTree i*ones(1,length(currentTree(i).centers))];
        trackChild=[trackChild 1:length(currentTree(i).centers)];
    end
    distances=vl_alldist(double(queryDescriptor),double(lastCenterList));
    [~,minIndex]=min(distances);
    currentPaths(depth,trackTree(minIndex))=trackChild(minIndex);
    finalPath=currentPaths(:,trackTree(minIndex));
    leafID=path2lin(finalPath,branchFactor);
end

