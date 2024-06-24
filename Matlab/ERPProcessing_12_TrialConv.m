clc
clear
%%

%Start EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


% filePath = 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\01_PretestGrandAverage\Preproc_sets'
% filePath = 'I:\Other computers\TUFG_HLAB_2023\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\CNN\2_Pretest_Out\OK';
filePath = '2_Test_Out_Resamp'

num_file = 1;
fileNames = ls(fullfile(filePath, "*.set")); 
fileNames = string(fileNames);

outputPath = 'TXT_trials_resamp'

while num_file <= length(fileNames) 

    fileName = convertStringsToChars(fileNames(num_file, 1))
    EEG = pop_loadset('filename',fileName,'filepath',filePath);

    %consider removing Fp1 (Ch1) and Fp

    %resample data at 128 hz, probably place it here

    %new_Fs = 128;

    %baseline time (miliseconds)
    trial_baseline = 200;

    Fs = 128;

    %samples to remove corresponding to baseline
    baseline_timepoints = round((Fs*trial_baseline)/1000)+1;

    %EEG = pop_resample(EEG, new_Fs);

    trials = EEG.data;

    numtrials = size(trials,3);

    for i=1:numtrials
        trial = trials(:,(baseline_timepoints:end),i); 
        subjCode = erase(fileName,'.set');
        outputFile = strcat(outputPath,'\',subjCode,'_tr_',num2str(i),'.txt')
        writematrix(trial,outputFile);        
    end
    num_file = num_file+1

end