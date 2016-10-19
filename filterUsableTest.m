lastIdx=1
filteredTest=cell(1,3);
for i=1:460
    testDist=zeros(1,1000);
    for j=1:1000
        testDist(j)=lldistkm(testGPS(i,2:3),trainGPS(j,1:2));
    end
    [minVal,minIdx]=min(testDist);
    
    if(minVal<1e-1)
        filteredTest{lastIdx}={testGPS(i,1),minVal,minIdx};
        lastIdx=lastIdx+1;
    else
        minVal,testGPS(i,1)
    end
end