%% Experiment parameters
subjectId = 'ss19892303';
expNote = 'training-mi-online';
dataFolder = 'data';

% Experiment timings
nExecs = 2;
nTrials = 20;
timePreExecution = 2;
trialTime = 5;

% Path to images
imageFolder = 'images';
handGripImages = { 'Adducted Thumb Right.png' , ...
                   'Medium Wrap Right.png' , ...
                   'Open Palm Right.png' , ...
                   'Parallel Extension Right.png'};%, ...
                   %'Adducted Thumb Left.png' , ...
                   %'Medium Wrap Left.png' , ...
                   %'Open Palm Left.png' , ...
                   %'Parallel Extension Left.png'};
               
%% Daq parameters
daqType = 'gUsbAmp'; % gUsbAmp or noAmp
channelsToAcquire = 1:16;
sampleRate = 256;
ampFilterNdx = 49;
notchFilterNdx = 3;
triggerFlag = 1;
channelNames = {   'Fc3', ... % 1
                   'Fc1', ... % 2
                   'Fcz', ... % 3
                   'Fc2', ... % 4
                   'Fc4', ... % 5
                   'C5', ... % 6
                   'C3', ... % 7
                   'C1', ... % 8
                   'Cz', ... % 9
                   'C2', ... % 10
                   'C4', ... % 11
                   'CP3', ... % 12
                   'CP1', ... % 13
                   'CPz', ... % 14
                   'CP2', ... % 15
                   'CP4'}; %16

%% Presentation parameters
screenNumber = 0;

% Text to the right
textInstructions = ['Follow the instructions \n shown below the picture'];

% Text box parameters
textPosRatio = [0 0 1 1];
color = [255 255 255 255]';
textSize = 24;

% Picture parameters
sizeIcon = [700 700];
instTxtPosRatio = [0.1, 0.75, 0.7, 0.85];

% Text for action execution and imagination
textExecution = 'Execute action';
textTrial = 'Imagine action';

quitFlag = true;
