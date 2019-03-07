function [dataWavs,trainWavs]=generateFeatures(audioPath)
% Matt Ruffner
% EE699 Speech Processing
% March 4th, 2019
% function to compute and label mfcc feature data from wav files
% uses load() if data has already been computed
% returns dataWavs with clips in the following order
%------------------------------------------
% break, eight, eighty, destination, zero
%   1      2       3          4          5
%------------------------------------------
inWavs = dir(audioPath);

testNames = {'BREAK.*.wav','EIGHT\d.*.wav','EIGHTY.*.wav','DESTIN.*.wav','ZERO.*.wav'};
categories = {'GENERAL1', 'GENERAL2', 'GENERAL3'};
types = {'FAST', 'SLOW', 'SOFT', 'TRAIN'};

dataWavs = cell(1,5);
fileSizes=zeros(54,5);
for x=3:size(inWavs)
    % provess one file at a time
    curFile=struct('name',inWavs(x).name, 'size',inWavs(x).bytes);
    
    % label the data based on filename
    % word type first
    wordType = -1;
    for y=1:length(testNames)
        if ~isempty( regexpi(curFile.name,testNames{y}, 'match') )
            wordType = y;
        end
    end 
    
    % now general 1/2/3 category
    for y=1:length(categories)
        if ~isempty( regexpi(curFile.name,categories{y}, 'match') )
            curFile.cat=categories{y};
        end
    end 
    
    % now pronunciation type
    for y=1:length(types)
        if ~isempty( regexpi(curFile.name,types{y}, 'match') )
            curFile.type=types{y};
        end
    end 
    
    % append data and fs labels
    fullFilePath = strcat(audioPath,curFile.name);
    fs = audioinfo(fullFilePath);
    fileData = audioread(fullFilePath);
    curFile.fs = fs.SampleRate;
    curFile.audio = v_melcepst(fileData,curFile.fs);
    
    % TODO: check wordType != -1
    dataWavs{wordType}{end+1}=curFile;
end

trainWavs=cell(1,5);
for x=1:5
    sizeVec=zeros(1,length(dataWavs{x}));
    for y=1:length(dataWavs{x})
        sizeVec(y)=dataWavs{x}{y}.size;
    end
    
    % calc median size to find test data clip
    sizeVec=sort(sizeVec);
    midPoint=floor(length(sizeVec))/2;
    for y=1:length(dataWavs{x})
        if dataWavs{x}{y}.size == sizeVec(midPoint)
           trainWavs{x}=dataWavs{x}{y}; 
        end
    end
end