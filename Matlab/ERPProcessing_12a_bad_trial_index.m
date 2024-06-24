%% Start EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%% Generate filename input list and output path

% filePath = 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\01_PretestGrandAverage\Preproc_sets'
% filePath = 'I:\Other computers\TUFG_HLAB_2023\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\CNN\2_Pretest_Out\OK';
filePath =   '2_Test_Out_Resamp'

num_file = 1;
fileNames = ls(fullfile(filePath, "*.set")); 
fileNames = string(fileNames);

fName ='Output_TXT/badtrials.txt';

while num_file <= length(fileNames) 

    % Load dataset
    fileName = convertStringsToChars(fileNames(num_file, 1))
    EEG = pop_loadset('filename',fileName,'filepath',filePath);  
    reject_trials = find(EEG.reject.rejmanual)
    dlmwrite(fName, reject_trials, '-append', 'newline', 'pc', 'delimiter', '\t');
    num_file = num_file+1;        
end    