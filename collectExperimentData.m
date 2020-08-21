% Main script that collects and saves motor imagery data
clc; clear; sca;
experimentParameters;

% Add stuff to path
mfilepath=fileparts(which('collectExperimentData.m'));
addpath(genpath(fullfile(mfilepath,'./ext')));

folderName = [subjectId '-' expNote '-' strjoin(strtrim(cellstr(num2str(round(clock).')).'), '-')];
mkdir([dataFolder '/' folderName]);

% Initialize daq object
switch daqType
    case 'noAmp'
        daqObj = DAQnoAmp('channelList',channelsToAcquire, ...
                            'fs', sampleRate,...
                            'triggerFlag',true, ...
                            'notchFilterNdx',notchFilterNdx, ...
                            'ampFilterNdx',ampFilterNdx, ...
                            'frontEndFilterFlag', true);
    case 'gUsbAmp'
        daqObj = DAQgUSBAmp('channelList',channelsToAcquire, ...
                            'fs', sampleRate,...
                            'triggerFlag',true, ...
                            'notchFilterNdx',notchFilterNdx, ...
                            'ampFilterNdx',ampFilterNdx, ...
                            'frontEndFilterFlag', true);
        daqObj.USBTriggerTest();
    otherwise
        error('daq not support')
end

daqObj.channelNames = channelNames;

% Launch GUI
continueFlag = launchGUI('daqManagerObj', daqObj);
if ~continueFlag
    daqObj.CloseDevice();
    return
end
    
% Create presentation objects
% Create pres manager
presManObj = presMan('screenNumber', screenNumber);
textBoxInstObj = textBoxFormatted(...
    'windowPointer', presManObj.windowPointer, ...
    'text', textExecution, ...
    'boundPosRatio', [0 0.8 0.8 1], ...
    'horzVert', [0 0],...
    'sizeRatio', [1 1], ...
    'color', color, ...
    'textSize', textSize);

% Create text box
textBoxDashObj = textBoxFormatted(...
    'windowPointer', textBoxInstObj.windowPointer, ...
    'text', textInstructions, ...
    'boundPosRatio', [0.8 0 1 1], ...
    'posRatio', textPosRatio, ...
    'color', color, ...
    'textSize', textSize);

% Creat background
bgObj = textBox('windowPointer', textBoxDashObj.windowPointer);
bgObj.Fill('color', [0 0 0 255]');

bgObj.Draw();
textBoxDashObj.Draw();

% Experiment loop 
% Create data structure for eeg
nGrasps = numel(handGripImages);

eegTrialData = repmat(struct('data',[], 'label', []), nGrasps, nTrials);
eegExecData = repmat(struct('data',[], 'label', []), nGrasps, nExecs);

% Start daq acquisition    
daqObj.OpenDevice();
daqObj.StartAcquisition('fileName', [dataFolder '/' folderName '/' folderName '.bin']);
% Send trigger
if strcmpi(daqType, 'gUsbAmp')
    daqObj.SendTrigger(0)
end

% For each hand positions
for idxGrasp = 1:nGrasps
    
    % Create images
    iconBoxObj = iconBox(...
        'windowPointer', textBoxDashObj.windowPointer, ...
        'boundPosRatio', [0 0 0.8 0.8], ...
        'horzVert', [0 0], ...
        'sizePixel', sizeIcon, ...
        'iconPaths', strcat([imageFolder '/'], handGripImages(idxGrasp)), ...
        'borderColor', [255 255 0 255]', ...
        'borderFlag', true);
    
    if quitFlag
    	quitLogical = presManObj.DrawFlipPause('textBoxObj', textBoxInstObj, ...,
                                 'pauseTime', 0, ...
                                 'quitFlag', quitFlag);
    else
        quitLogical = presManObj.DrawFlipPause('textBoxObj', textBoxInstObj, ...,
                                 'pauseTime', 0, ...
                                 'quitFlag', quitFlag, ...
                                 'maxCheckTime', 0);
    end

    if quitLogical
        warning('User quit session');
        sca;
        daqObj.StopAcquisition();
        daqObj.CloseDevice();
        return
    end      
 
    iconBoxObj.DrawIcons();
    iconBoxObj.DrawBorder();
    iconBoxObj.Flip();       
        
    % For each grip execution
    for idxExec = 1:nExecs
        % Display execution index/total
        textBoxDashObj.text = [textInstructions '\n exec ' num2str(idxExec) ' of ' num2str(nExecs) ...
                               '\n grasp ' num2str(idxGrasp) ' of '  num2str(nGrasps)];
        textBoxDashObj.Fill('color', [0 0 0 255]');
        textBoxDashObj.Draw();
        
        if quitFlag
            quitLogical = presManObj.DrawFlipPause('textBoxObj', textBoxInstObj, ...,
                'pauseTime', 0, ...
                'quitFlag', quitFlag);
        else
            quitLogical = presManObj.DrawFlipPause('textBoxObj', textBoxInstObj, ...,
                'pauseTime', 0, ...
                'quitFlag', quitFlag, ...
                'maxCheckTime', 0);
        end
    
        % Wait for user to press space
        
        if quitLogical
            warning('User quit session');
            sca;
            daqObj.StopAcquisition();
            daqObj.CloseDevice();
            return
        end
        
        % Display time: 2, 1, go -> wait for execution
        presManObj.DrawFlipPause('textBoxObj', textBoxInstObj, ...
                                        'pauseTime', timePreExecution, ...
                                        'maxCheckTime', 0);
        
        textBoxInstObj.text = textExecution;
        textBoxInstObj.Fill('color', [0 0 0 255]');
        textBoxInstObj.Draw();
        textBoxInstObj.Flip();
        
        % Send trigger
        if strcmpi(daqType, 'gUsbAmp')
            daqObj.SendTrigger(1)
        end
                
        pause(trialTime);
        
        % Send trigger
        if strcmpi(daqType, 'gUsbAmp')
            daqObj.SendTrigger(0)
        end
        
        % Collect data in eeg data structure
        try
            [eegExecData(idxGrasp, idxExec).data] = daqObj.GetTrial();
        catch
            sca;
            daqObj.StopAcquisition();
            daqObj.CloseDevice();
            return;
        end
        eegExecData(idxGrasp, idxExec).label = idxGrasp;
                                                     
    end
        
    for idxTrial = 1:nTrials
        % Display execution index/total
        textBoxDashObj.text = [textInstructions '\n trial ' num2str(idxTrial) ' of ' num2str(nTrials) ...
                               '\n grasp ' num2str(idxGrasp) ' of '  num2str(nGrasps)];
        textBoxDashObj.Fill('color', [0 0 0 255]');
        textBoxDashObj.Draw();
        
        % Wait for user to press space
        if quitFlag
            quitLogical = presManObj.DrawFlipPause('textBoxObj', textBoxInstObj, ...,
                                        'pauseTime', 0, ...
                                        'quitFlag', quitFlag);
        else
            quitLogical = presManObj.DrawFlipPause('textBoxObj', textBoxInstObj, ...,
                                        'pauseTime', 0, ...
                                        'quitFlag', quitFlag, ...
                                        'maxCheckTime', 0);
        end
        
        if quitLogical
            warning('User quit session');
            sca;
            daqObj.StopAcquisition();
            daqObj.CloseDevice();
            return
        end
        
        % Display time: 2, 1, go -> wait for execution
        presManObj.DrawFlipPause('textBoxObj', textBoxInstObj, ...
                                        'pauseTime', timePreExecution, ...
                                        'maxCheckTime', 0);
                
        textBoxInstObj.text = textTrial;
        textBoxInstObj.Fill('color', [0 0 0 255]');
        textBoxInstObj.Draw();
        textBoxInstObj.Flip();
        
        % Send trigger
        if strcmpi(daqType, 'gUsbAmp')
            daqObj.SendTrigger(1)
        end
                                                                                                                          
        pause(trialTime);                                    
        
        % Send trigger
        if strcmpi(daqType, 'gUsbAmp')
            daqObj.SendTrigger(0);
        end
        
        % Collect data in eeg data structure
        [eegTrialData(idxGrasp, idxTrial).data] = daqObj.GetTrial();
        eegTrialData(idxGrasp, idxTrial).label = idxGrasp;    
    end
    
    save([dataFolder '/' folderName '/' folderName '.mat'], 'eegTrialData', 'eegExecData', 'handGripImages');   

end 

% Close daq object
daqObj.StopAcquisition();
daqObj.CloseDevice();
sca;

save([dataFolder '/' folderName '/' folderName '.mat'], 'daqObj', 'eegTrialData', 'eegExecData', 'handGripImages');


