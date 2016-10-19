function [ result ] = calculateEntropy( NDB,NL,a,b )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% term1=(-(a+b)/NDB)*( (a/(a+b))*log2(a/(a+b)) + (b/(a+b))*log2(b/(a+b)));
% term3=((NDB-NL-b)/(NDB-a-b)) * log2((NDB-NL-b)/(NDB-a-b));
% term2=(-(NDB-a-b)/NDB)*( ((NL-a)/(NDB-a-b))*log2(((NL-a)/(NDB-a-b)))+term3 );
% result=term1+term2+term3;

p1=a/(a+b);
p2=b/(a+b);
p3=(NL-a)/(NDB-a-b);
p4=(NDB-NL-b)/(NDB-a-b);
p5=(a+b)/NDB;
p6=(NDB-a-b)/NDB;

t1=-p5*(p1*log2(p1)+p2*log2(p2));
t2=-p6*(p3*log2(p3)+p4*log2(p4));
result=t1+t2;
end

