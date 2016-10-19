nonvalid=length(find(okResult<1))
perf=zeros(1,max(okResult));
for ii=1:max(okResult)
    perf(ii)=(length(find(okResult<=ii))-nonvalid)/(100-nonvalid);
end

totalPrec=cumsum(sum(precision))/100;

for ii=1:length(totalPrec)
    totalPrec(ii)=totalPrec(ii)/ii;
end