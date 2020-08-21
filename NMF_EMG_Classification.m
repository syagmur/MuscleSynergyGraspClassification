% NNMF implementation on EMG data by NNMF function of MATLAB
% The code provides two options for channel size
% Option1: Consider all 12 data channels separately
% Option 2: Since the data is collected from 6 different muscle groups with bipolar
% electrodes, we considered difference of two bipolar channels as 1 channel.
% Therefore channel size is decreased to 6.

clc; clear all;

% Loading data from experiment into matlab as the loadVariable name
filename = 'ry19900622-emg-6-muscles-forearm-2016-12-22-13-17-51.mat';

loadVariable = 'eegTrialData';
load(filename,loadVariable,'handGripImages');

trialSize = 0;
for i=1:size(eegTrialData,1)
     if ~isempty(eegTrialData(i).data) 
         trialSize = trialSize + 1;
     end
end

nTrials = trialSize/size(handGripImages,2); % nTrials = sum([eegTrialData.label]==1)
nGrasps = size(handGripImages,2);

% Upload data and resize each sample by the minimum number of trial size
% Find the max element of the data for normalizing
   
maxValue = 0;
   
for i=1:trialSize
	a(i,1) = size(eegTrialData(i).data,1);
    tempMax = max(max(eegTrialData(i).data));
     if tempMax > maxValue
         maxValue = tempMax;
     end
end
  
minSample = min(a);
nChannels = size(eegTrialData(1).data,2);
  

% %   Option 1: Consider all channels (Filter if necessary)
eegExecData = [];  
countTrial = zeros(1,nGrasps);
for i=1:trialSize
      c = eegTrialData(i).label;
      countTrial(1,c) = countTrial(1,c) + 1;
      eegExecData(c,countTrial(1,c)).data = (eegTrialData(i).data(1:minSample,:));
% %       Filter Data
%         eegExecData(c,countTrial(1,c)).data = filter(emgBandPass, (eegTrialData(i).data(1:minSample,:)/maxValue).^2); 
      eegExecData(c,countTrial(1,c)).label = eegTrialData(i).label;
end
  
%%
% %   Option 2: Apply referencing (Filter if necessary)

%   for i=1:trialSize
%       c = eegTrialData(i).label;
%       countTrial(1,c) = countTrial(1,c) + 1;
%       countChan = 0;
%       for j=1:2:nChannels
%       countChan = countChan + 1;
%       eegExecData(c,countTrial(1,c)).data(:,countChan) = (eegTrialData(i).data(1:minSample,j)-eegTrialData(i).data(1:minSample,j+1));
% % %            Filter Data
% %             eegExecData(c,countTrial(1,c)).data(:,countChan) = filter(emgBandPass, ((eegTrialData(i).data(1:minSample,j)-eegTrialData(i).data(1:minSample,j+1))/maxValue).^2);
%       end
%       eegExecData(c,countTrial(1,c)).label = eegTrialData(i).label;
%   end

nChannels = size(eegExecData(1).data,2);
 %%
  
 % Divide sample size to 301 in order to increase the number of trials
sampledData = [];
for indx = 1:size(eegExecData,1)
    c = 0;
   for jndx =1:size(eegExecData,2) 
    tempData = [];
    kndx = 1;
        while kndx < size(eegExecData(indx,jndx).data,1)-300
            c = c+1;
            sampledData{indx,c} = eegExecData(indx,jndx).data(kndx:kndx+300,:);
            kndx = kndx + 400;
        end
   end
end

% % Use MAV as EMG Amplitude
ampData = [];
ampLabel = [];
count = 0;
for indx=1:size(sampledData,1)
    for jndx=1:size(sampledData,2)
        if ~isempty(sampledData{indx,jndx})
            count = count + 1;
            for kndx=1:size(sampledData{1,1},2)
            ampData(count,kndx) = meanabs(sampledData{indx,jndx}(:,kndx)); 
            ampLabel(count,1) = indx;
            end
        end
    end
end

% % Use RMS as EMG Amplitude
% ampData = [];
% ampLabel = [];
% count = 0;
% for indx=1:size(sampledData,1)
%     for jndx=1:size(sampledData,2)
%         if ~isempty(sampledData{indx,jndx})
%             count = count + 1;
%             count = count + 1;
%             ampData(count,:) = rms(sampledData{indx,jndx}); 
%             ampLabel(count,1) = indx;
%         end
%     end
% end

indices = crossvalind('KFold', ampData(:,1), 10);
maxSynergies = nChannels; % If considered synergy number = nChannels
nSamples = size(ampData,1);

for cross = 1:10
    clearvars trainData testData trainLabel testLabel resultLabel trainW testW trainH testH;
    
    trainData = ampData(indices ~= cross,:);
    testData = ampData(indices == cross,:);
    trainLabel = ampLabel(indices ~= cross,:);
    testLabel = ampLabel(indices == cross,:);
    nSamples = size(trainData,1);
    
    %Create 3 dimensional matrices of W and H. For each number of synergies,
    %and 2D slice will be populated. Slices will contain some zeroes (as lower
    %number of synergies won't have enough elements to populate the full 2D
    %matrix)
    
    [trainW0,trainH0] = nnmf(trainData,maxSynergies,'replicates',100,'algorithm','mult');
    [trainW,trainH] = nnmf(trainData,maxSynergies,'w0',trainW0,'h0',trainH0,'algorithm','als');
    VAF = 1 - sum(sum((trainW*trainH).^2))/sum(sum(trainData.^2));
    
    %testW = mrdivide(testData,trainH);
    for columnNumber = 1:size(testData,1)
    testW(columnNumber,:) = lsqnonneg(trainH',testData(columnNumber,:)')';
    end
    %testW = testData*pinv(trainH);
    
    svmStruct = templateSVM('Standardize',1,'KernelFunction','gaussian');
    svmModel = fitcecoc(trainW, trainLabel, 'Learners',svmStruct);
    resultLabel = predict(svmModel, testW);
    perf = classperf(testLabel,resultLabel);
    acc(cross) = perf.CorrectRate;
end
performance = mean(acc);


