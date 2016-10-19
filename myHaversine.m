function [ d ] = myHaversine( lat1,lon1,lat2,lon2 )
%MYHAVERSINE Summary of this function goes here
%   Detailed explanation goes here

dlon = lon2 - lon1 ;
dlat = lat2 - lat1 ;
a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * ((sin(dlon/2))^2) ;
c = 2 * atan2( sqrt(a), sqrt(1-a) ) ;
R=6373;
d = R * c;
end

