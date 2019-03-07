%% Project 2 
% Matt Ruffner
% EE699 Speech Processing
% March 7th, 2019

% generate/load test data
[testData,trainData] = generateFeatures('audio/');

% create empty confusion matricies for the different analyses
Cf=zeros(5,5);
CfG1=zeros(5,5);
CfG2=zeros(5,5);
CfG3=zeros(5,5);
CfNorm=zeros(5,5);
CfSlow=zeros(5,5);
CfFast=zeros(5,5);
CfSoft=zeros(5,5);

% COMPARE BASED ON SPEAKER AND CONDITION
% iterate over 'training' words
for i=1:5
    % compare with the 5 kinds of 'test' words
    for k=1:length(testData{i})
        Cc=zeros(1,5);
        for j=1:5
            % USE MY DTW FUNCTION
            Cc(j)=ruffdtw(trainData{i}.audio, testData{j}{k}.audio);
            
            % THIS LINE USES THE BUILT IN FUNCTION FOR REFERENCE
            %Cc(j)=dtw(trainData{i}.audio', testData{j}{k}.audio');
        end
        [val pos]=min(Cc);
        % CATEGORIZE BASED ON SPEAKER
        switch testData{1}{k}.cat
            case 'GENERAL1'
                CfG1(i,pos)=CfG1(i,pos)+1;
            case 'GENERAL2'
                CfG2(i,pos)=CfG2(i,pos)+1;
            case 'GENERAL3'
                CfG3(i,pos)=CfG3(i,pos)+1;
        end
        % CATEGORIZE BASED ON ENUNCIATION
        switch testData{1}{k}.type
            case 'FAST'
                CfFast(i,pos)=CfFast(i,pos)+1;
            case 'SLOW'
                CfSlow(i,pos)=CfSlow(i,pos)+1;
            case 'SOFT'
                CfSoft(i,pos)=CfSoft(i,pos)+1;
            case 'TRAIN'
                CfNorm(i,pos)=CfNorm(i,pos)+1;
        end
        Cf(i,pos)=Cf(i,pos)+1;
    end
    % NORMALIZE CONFUSION MATRICIES
    Cf(i,:)=Cf(i,:)./sum(Cf(i,:));
    CfG1(i,:)=CfG1(i,:)./sum(CfG1(i,:));
    CfG2(i,:)=CfG2(i,:)./sum(CfG2(i,:));
    CfG3(i,:)=CfG3(i,:)./sum(CfG3(i,:));
    CfFast(i,:)=CfFast(i,:)./sum(CfFast(i,:));
    CfSlow(i,:)=CfSlow(i,:)./sum(CfSlow(i,:));
    CfSoft(i,:)=CfSoft(i,:)./sum(CfSoft(i,:));
    CfNorm(i,:)=CfNorm(i,:)./sum(CfNorm(i,:));
end

% PLOT CONFUSION MATRICIES
% SCRIPT THANKS TO Vahe Tshitoyan
% https://github.com/vtshitoyan/plotConfMat

figure(1)
plotConfMat(Cf)

figure(2)
plotConfMat(CfG1)

figure(3)
plotConfMat(CfG2)

figure(3)
plotConfMat(CfG3)

figure(4)
plotConfMat(CfNorm)

figure(5)
plotConfMat(CfSlow)

figure(6)
plotConfMat(CfFast)

figure(7)
plotConfMat(CfSoft)
