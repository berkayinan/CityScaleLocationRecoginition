for queryListID=1:460
    fprintf('query ID: %d/460\n',queryListID);
    queryID=testGPS(queryListID,1);
    filename=strcat(queryPath,'q(',num2str(queryID),').jpg');
    queryStruct{queryListID}.descriptors=getDescriptors(imread(filename));
    queryStruct{queryListID}.ID=queryID;
end