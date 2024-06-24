clc
clear
%%

%% Start EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%% Generate filename input list and output path

% filePath = 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\01_PretestGrandAverage\Preproc_sets'
% filePath = 'I:\Other computers\TUFG_HLAB_2023\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\CNN\2_Pretest_Out\OK';
filePath =   '2_Pretest_Out_Resamp'
outputPath = '2_Pretest_Out_Resamp_clean'

num_file = 1;
fileNames = ls(fullfile(filePath, "*.set")); 
fileNames = string(fileNames);

%% remove from the list the filenames that don't require trial rejection

% for 128Hz resampled data
% 11->AMT015
% 12->AMT016
% 14->AMT018
% 15->AMT019
% 17->AMT021
% 18->AMT022
% 19->AMT022
good_sets = [11,12,14,15,17,18,19];

%%  Iterate to remove the rejected trials

while num_file <= length(fileNames) 

    % Load dataset
    fileName = convertStringsToChars(fileNames(num_file, 1))
    EEG = pop_loadset('filename',fileName,'filepath',filePath);  


    if ~ismember(num_file,good_sets)
        % Find in the dataset the indeces of the rejected trials
        reject_trials = find(EEG.reject.rejmanual)
        % remove the fields in the EEG dataset to eliminate the trial
        % information
        EEG.data(:,:,reject_trials)=[];
        % remove event data
        EEG.event(reject_trials) = [];
        EEG.epoch(reject_trials) = [];
        EEG.reject.rejmanual(reject_trials) = [];
        EEG.reject.rejmanualE(:,reject_trials) = [];
        %save new dataset
        EEG = pop_saveset( EEG, 'filename',fileName,'filepath',outputPath);
    else
        EEG = pop_saveset( EEG, 'filename',fileName,'filepath',outputPath);
    end
    num_file = num_file+1;
end    




