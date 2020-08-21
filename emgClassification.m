% Basic EMG Classification Experiment
% Collected EMG from the forearm for fourteen gestures and eight trials
% Trials were sampled by 300 samples in order to increase the sample size
% and 100 samples were discarded inbetween each sample as buffer
% Attempting to classify the gestures using the variance as feature and SVM
% as the classification technique
% The code presents twp options for considered channel size
% Option 1: Consider all 10 channel for classification
% Option 2: Apply subtraction referencing for dual channels

% *** Updated for the Different Sized Data Samples and RMS *** %
PathInitialization();
% Loading data from experiment into matlab as the loadVariable name
filename = 'ni19920909-emg-6-muscles-forearm-2016-12-22-12-40-08.mat'; %%%
% loadVariable = 'eegTrialData';
% load(filename,loadVariable,'handGripImages');
loadVariable = 'eegTrialData';
load(filename,loadVariable,'handGripImages');

trialSize = 0;
for i=1:size(eegTrialData,1)
     if ~isempty(eegTrialData(i).data) 
         trialSize = trialSize + 1;
     end
end

nTrials = trialSize/size(handGripImages,2); % nTrials = sum([eegeegTrialData.label]==1)
nGrasps = size(handGripImages,2);

% Upload data and resize each sample by the minimum number of trial size
   eegExecData = [];
   maxValue = 0;
   for i=1:trialSize
       a(i,1) = size(eegTrialData(i).data,1);
       tempMax = max(max(eegTrialData(i).data));
       if tempMax > maxValue
           maxValue = tempMax;
       end
  end
  
  countTrial = zeros(1,nGrasps);
  minSample = min(a);
  nChannels = size(eegTrialData(1).data,2);
  
  %%
  % Option 1: Consider all channels (Filter if necessary)
  for i=1:trialSize
      c = eegTrialData(i).label;
      countTrial(1,c) = countTrial(1,c) + 1;
      eegExecData(c,countTrial(1,c)).data = eegTrialData(i).data(1:minSample,:);
      % Filter Data
  %       eegExecData(c,countTrial(1,c)).data = filter(emgBandPass, eegTrialData(i).data(1:minSample,:)); 
      eegExecData(c,countTrial(1,c)).label = eegTrialData(i).label;
  end
  
%   % Option 2: Apply referencing (Filter if necessary)
%   for i=1:trialSize
%       c = eegTrialData(i).label;
%       countTrial(1,c) = countTrial(1,c) + 1;
%       countChan = 0;
%       for j=1:2:nChannels
%       countChan = countChan + 1;
%       eegExecData(c,countTrial(1,c)).data(:,countChan) = eegTrialData(i).data(1:minSample,j)-eegTrialData(i).data(1:minSample,j+1);
%       %       % Filter Data
%       %       eegExecData(c,countTrial(1,c)).data(:,countChan) = filter(emgBandPass, eegTrialData(i).data(1:minSample,j)-eegTrialData(i).data(1:minSample,j+1)); 
%       end
%       eegExecData(c,countTrial(1,c)).label = eegTrialData(i).label;
%   end
  nChannels = size(eegExecData(1).data,2);
 %%
  
 % Divide sample size to 301 for increasing trial size
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

% Apply whitening filter
%sampledData = whiteningFilter(sampledData);

% Reshape data for DimReductStats
nSamples = size(sampledData,2);
inputData = [];
for i=1:nGrasps
    tempMat = [];
        for j = 1:nSamples
            if ~isempty(sampledData{i,j})
            tempMat(j,:,:) = sampledData{i,j};
            end
        end
    inputData{i,1} = tempMat;
end


% % Compute MAD, Var and mean of each trial as features
% featureMatrix = [];
% tempMatrix =[];
% DimReductObj = DimReductStats('stats',{'mad','rms','var','mean'});
% for indx = 1:nGrasps
%         if ~isempty(inputData{indx,1})
%         nNESample = size(inputData{indx,1},1);
%         tempMatrix{indx,1} = DimReductObj.Reduce(inputData{indx,1});
%         featureMatrix{indx,1} = [tempMatrix{indx,1}(1:nNESample,:) tempMatrix{indx,1}(nNESample+1:2*nNESample,:)...
%             tempMatrix{indx,1}(2*nNESample+1:3*nNESample,:) tempMatrix{indx,1}(3*nNESample+1:4*nNESample,:)]';
%         end
% end

featureMatrix = [];
tempMatrix =[];
DimReductObj = DimReductStats('stats',{'mad','rms','var'});
for indx = 1:nGrasps
        if ~isempty(inputData{indx,1})
        nNESample = size(inputData{indx,1},1);
        tempMatrix{indx,1} = DimReductObj.Reduce(inputData{indx,1});
        featureMatrix{indx,1} = [tempMatrix{indx,1}(1:nNESample,:) tempMatrix{indx,1}(nNESample+1:2*nNESample,:)...
            tempMatrix{indx,1}(2*nNESample+1:3*nNESample,:)]';
        end
end

% Apply PCA for all possible component sizes and plot the accuracies 
count = 0;
accuracy = [];
initial = 2;
for nComponents = initial:15
    %for nComponents = initial:size(featureMatrix{1,1},1)
    count = count + 1;
    componentSortMethod = 'firstNComponents';
    DimReductPCAObj = DimReductPCA('componentSortMethod',componentSortMethod,...
                                   'nComponents',nComponents);

    DimReductPCAObj.Learn(featureMatrix);                           
    pcaData = DimReductPCAObj.Reduce(featureMatrix);

    % Reshape the data for classifier
    pcaFeature = [];
    for i=1:size(pcaData,1)
        pcaFeature{1,i} = pcaData{i,1};
    end

    kFoldK = 10;
    ClassifierObj = ClassifierSVM('k',kFoldK,'rejectOutlier',true);

    [~,acc,confusionMatrix] = ClassifierObj.CrossValidate(pcaFeature,...
            'trialDim',2);

    accuracy(count,1) = acc;
end
plot(initial:15,accuracy,'LineWidth',3)
%plot(initial:size(featureMatrix{1,1},1),accuracy,'LineWidth',3)
grid on;
xlabel('Number of Components');
ylabel('SVM Result');
legend('Accuracy')
title('12 Channel Plot of 2049')


%%
% % Compute MAD, Var and mean of each trial as features
% featureMatrix = [];
% tempMatrix = [];
% varMatrix = [];
% DimReductObj = DimReductStats('stats',{'mad','var','mean'});
% for i=1:3
%     for indx = 1:nGrasps
%         if ~isempty(inputData{indx,1})
%         nNESample = size(inputData{indx,1},1);
%         tempMatrix{indx,1} = DimReductObj.Reduce(inputData{indx,1});
%         featureMatrix{indx,1} = [tempMatrix{indx,1}(1:nNESample,:) tempMatrix{indx,1}(nNESample+1:2*nNESample,:) tempMatrix{indx,1}(2*nNESample+1:3*nNESample,:)]';
%         varMatrix{indx,1} = featureMatrix{indx,1}((i-1)*nChannels+1:i*nChannels,:);
%         end
%     end
%  for repeat = 1:5
%     kFoldK = 10;
%     ClassifierObj = ClassifierSVM('k',kFoldK,'rejectOutlier',true);
% 
%     [~,acc(repeat,i),confusionMatrix] = ClassifierObj.CrossValidate(varMatrix,...
%             'trialDim',2);
%  end
% end
% fprintf('Accuracy is %f for only MAD features (5 Chan)\n', mean(acc(:,1)));
% fprintf('Accuracy is %f for only variance features\n',  mean(acc(:,2)));
% fprintf('Accuracy is %f for only mean features\n',  mean(acc(:,3)));
% 
%  % (1:nSamples) -> MAD, (nSamples+1:2*nSamples) -> variance
%         % (2*nSamples+:3*nSamples) -> mean
        
        
        
        
        
% featureMatrix = [];
% tempMatrix = [];
% varMatrix = [];
% DimReductObj = DimReductStats('stats',{'rms'});
%     for indx = 1:nGrasps
%         if ~isempty(inputData{indx,1})
%         nNESample = size(inputData{indx,1},1);
%         tempMatrix{indx,1} = DimReductObj.Reduce(inputData{indx,1});
%         featureMatrix{indx,1} = [tempMatrix{indx,1}(1:nNESample,:)]';
%         varMatrix{indx,1} = featureMatrix{indx,1};
%         end
%     end
%  for repeat = 1:5
%     kFoldK = 10;
%     ClassifierObj = ClassifierSVM('k',kFoldK,'rejectOutlier',true);
% 
%     [~,acc(repeat),confusionMatrix] = ClassifierObj.CrossValidate(varMatrix,...
%             'trialDim',2);
%  end
% fprintf('Accuracy is %f for only RMS features (5 Chan)\n', mean(acc));