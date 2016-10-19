function [ descriptorList ] = getDescriptors( im )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
     if(size(im,3)==3)
        im =rgb2gray(im);
    end
    im=im2single(im);
    [~,descriptorList]=vl_sift(im);   
    %[~,descriptorList]=vl_covdet(im);
end

