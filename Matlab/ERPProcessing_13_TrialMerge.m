clc
clear
%%

filePath = 'Train_Trials';

num_file = 1;
fileNames = ls(fullfile(filePath, "*.csv")); 
fileNames = string(fileNames);
nchannels = 22;
ntimepoints = 250;
numel = 22*250;
numTrials = length(fileNames); 
trialset = zeros(numTrials,numel);

while num_file <= numTrials

    fileName = convertStringsToChars(fileNames(num_file, 1));
    inputFile = strcat(filePath,'\',fileName)
    data = readmatrix (inputFile);
    trData = transpose (data);    
    vectTrial = reshape(trData,[1,numel]);
    trialset(num_file,:) = vectTrial;
    num_file = num_file + 1

end
writematrix (fileNames,'PretestTrainTrials_Filenames.txt')
writematrix(trialset,'PretestTrainTrials.csv');


