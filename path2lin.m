function [ result ] = path2lin( path,branchingFactor )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
descPath=path-1;
result=0;
for i=1:length(path(:,1))
    result=result*branchingFactor;
    result=result+descPath(i,:);
end
result=result+1;
end

