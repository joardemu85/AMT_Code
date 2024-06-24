clc
clear
%% Initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Change participant codes (AMT0XX) and section according to the iteration
% using Ctrl+F

%% Load Dataset

%This is the dataset generated by the script GenerateEventList.m, we will
%perform all the ERP processing with this one from now on
EEG = pop_loadset('filename','01_AMT018_PT_elist.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\Analysis\EEG\AMT018\02_ERP\01_Pretest\');
EEG = eeg_checkset( EEG );
eeglab redraw;

%% 1. Filter data

%Notch filter at 50Hz
EEG = pop_eegfiltnew(EEG, 'locutoff',50,'revfilt',1);

%Band pass filter from 0.1 Hz to 30Hz
EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'hicutoff',30);

%Rename dataset
EEG.setname='AMT018_PT_filt';
EEG = eeg_checkset( EEG );

%Save filtered dataset
EEG = pop_saveset( EEG, 'filename','02_AMT018_PT_filt.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest\\');
eeglab redraw;

%% 2. Re reference dataset

%rereference the data to Left and Right mastoid average (channels 53 and
%89) while reconstructing previous Cz reference 
EEG = pop_reref( EEG, [53 89] ,'keepref','on');

%Plot rereferenced dataset (Optional)
pop_eegplot( EEG, 1, 1, 1);

%Rename and save
EEG.setname='AMT018_PT_filt_REREF';
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','03_AMT018_PT_filt_REREF.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest\\');

eeglab redraw;

%% 3. Cluster dataset

%change this variable when reprocessing datasets that need removal of bad
%channels
%cluster_eq = {'nch1 = (ch2+ch3+ch9+ch10)/4 Label Fp2', 'nch2 = (ch4+ch5+ch6+ch11+ch12+ch16+ch19)/7 Label Fz', 'nch3 = (ch18+ch22+ch23+ch26)/4 Label Fp1', 'nch4 = (ch13+ch20+ch24+ch28)/4 Label F3', 'nch5 = (ch27+ch33+ch34+ch38)/4 Label F7', 'nch6 = (ch29+ch30+ch35+ch36+ch41)/5 Label C3', 'nch7 = (ch39+ch40+ch43+ch44+ch45)/5 Label T7', 'nch8 = (ch42+ch46+ch48+ch49+ch50+ch55+ch56)/7 Label P3', 'nch9 = ch53 Label LM', 'nch10 = (ch50+ch54+ch59+ch60)/4 Label P7', 'nch11 = (ch57+ch58+ch62+ch66+ch70+ch71)/6 Label Pz', 'nch12 = (ch61+ch63+ch64+ch65)/4 Label O1', 'nch13 = (ch67+ch68+ch74)/3 Label Oz', 'nch14 = (ch69+ch75+ch76+ch80)/4 Label O2', 'nch15 = (ch77+ch78+ch82+ch83+ch84+ch87+ch88)/7 Label P4', 'nch16 = (ch81+ch85+ch86+ch90)/4 Label P8', 'nch17 = ch89 Label RM', 'nch18 = (ch92+ch93+ch94+ch98+ch99)/5 Label C4', 'nch19 = (ch91+ch96+ch97+ch101+ch102)/5 Label T8', 'nch20 = (ch103+ch106+ch107+ch108)/4 Label F8', 'nch21 = (ch100+ch104+ch105+ch109)/4 Label F4',  'nch22 = (ch7+ch31+ch37+ch51+ch52+ch72+ch73+ch79+ch95+ch110)/10 Label CZ'};

cluster_eq = input("Enter the cluster equation for this dataset: ");

EEG = pop_eegchanoperator( EEG, cluster_eq, 'ErrorMsg', 'popup', 'KeepChLoc', 'on', 'Warning', 'on' ); % GUI: 13-Jul-2023 16:51:04

%edit location of channel Cz
%Careful here, the location of Cz changes from 10 to 9 if another channel
%has been previously removed, like in the cases of FP2 and Oz
EEG=pop_chanedit(EEG, 'changefield',{9,'theta','90'},'changefield',{9,'radius','0'},'changefield',{9,'X','-1.1427e-31'},'changefield',{9,'Y','-6.2206e-16'},'changefield',{9,'Z','10.159'},'changefield',{9,'sph_theta','-90'},'changefield',{9,'sph_phi','90'},'changefield',{9,'sph_radius','10.159'},'changefield',{9,'type','EEG'},'setref',{'','LM RM'});

pop_eegplot( EEG, 1, 1, 1);

%Rename and save
EEG.setname='AMT018_PT_filt_REREF_cluster';
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','04_AMT018_PT_filt_REREF_cluster.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest');

eeglab redraw;


%% The ERP processing starts from here
%% 4. Load new event list

EEG= pop_overwritevent( EEG, 'code');% Script: 10-Jul-2023 14:24:10

%load new event list
EEG = pop_importeegeventlist( EEG, 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\AMT018\02_ERP\01_Pretest\AMT018_PT_Elist_New.txt' , 'ReplaceEventList', 'on' ); % GUI: 10-Jul-2023 14:24:10

%Rename dataset
EEG.setname='AMT018_PT_filt_REREF_cluster_impel';
EEG = eeg_checkset( EEG );

%save dataset with new event list
EEG = pop_saveset( EEG, 'filename','05_AMT018_PT_filt_REREF_cluster_impel.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest');
eeglab redraw;

%Plot data to check the event markers (Optional)
pop_eegplot( EEG, 1, 1, 1);


%% Create bins

EEG  = pop_binlister( EEG , 'BDF', 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\InputTXT\binlister_1_pretest.txt', 'ExportEL', 'C:\Users\JorgeD_HirakiLab\Desktop\binlister test\bins.txt', 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' ); % GUI: 14-Jul-2023 10:04:04

%Rename dataset
EEG.setname='AMT018_PT_filt_REREF_cluster_impel_bins';
EEG = eeg_checkset( EEG );

%save dataset with new event list
EEG = pop_saveset( EEG, 'filename','06_AMT018_PT_filt_REREF_cluster_impel_bins.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest');
eeglab redraw;


%% 5. Epoch EEG data (Re run to recover 7th step)

EEG = pop_epochbin( EEG , [-200.0  1000.0],  'pre'); % GUI: 10-Jul-2023 16:10:43

%Plot data to check the event markers (Optional)
pop_eegplot( EEG, 1, 1, 1);

%Rename dataset
EEG.setname='AMT018_PT_filt_REREF_cluster_impel_bins_epoch';
EEG = eeg_checkset( EEG );

%save dataset with new event list
EEG = pop_saveset( EEG, 'filename','07_AMT018_PT_filt_REREF_cluster_impel_bins_epoch.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest');
eeglab redraw;


%% 6. Artifact detection and rejection 

%1. Perform Independent Component Analysis for eye blink removal
ncomp = input ("Enter number of components (nchan - 1): ");
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on','pca',ncomp);

%Export text info from ICA analysis
pop_export(EEG,'C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest\\AMT018_PT_ICAMatrix.txt','transpose','on','precision',4);
pop_export(EEG,'C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest\\AMT018_PT_ICA_Activity','transpose','on','precision',4);
pop_expica(EEG, 'weights', 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\AMT018\02_ERP\01_Pretest\AMT018_PT_ICA_WeightMatrix.txt');

%Rename and saved ICA decomposed dataset
EEG.setname='AMT018_PT_filt_REREF_cluster_impel_bins_epoch_ICA';
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','08_AMT018_PT_filt_REREF_cluster_impel_bins_epoch_ICA.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest');
eeglab redraw;

%visualize components and select the ones to remove (do from GUI)
fprintf("Please perform the component clasification using ICLabel. Press a key to continue after visual check...\n")
pause();
rem_comp = input("Enter the components to remove after inspection: ");

%remove selected components 
EEG = pop_subcomp( EEG, rem_comp, 0);
EEG = eeg_checkset( EEG );

%Plot pruned dataset (Optional)
pop_eegplot( EEG, 1, 1, 1);

%save pruned dataset
EEG.setname='AMT018_filt_REREF_cluster_impel_be_ICApruned';
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','09_AMT018_PT_filt_REREF_cluster_impel_be_ICApruned.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest');

eeglab redraw;


%2. Perform Moving Window Artifact Rejection
mw_thr = input("Enter moving window theshold (100 - 200): ");
EEG  = pop_artmwppth( EEG , 'Channel',  1:21, 'Flag', [ 1 2], 'LowPass',  -1, 'Threshold',  mw_thr, 'Twindow', [ -200 996], 'Windowsize',  200, 'Windowstep',  100 ); % GUI: 10-Jul-2023 17:06:39

%save AR dataset
EEG.setname='AMT018_PT_filt_REREF_cluster_impel_be_ICApruned_mwar';
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','10_AMT018_PT_filt_impel_be_REREF_ICApruned_mw.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest');

eeglab redraw;


%3. perform Step-Like artifact rejection
step_thr = input("Enter step theshold (100 - 200): ");
EEG  = pop_artstep( EEG , 'Channel',  1:21, 'Flag', [ 1 3], 'LowPass',  -1, 'Threshold',  step_thr , 'Twindow', [ -200 996], 'Windowsize',  200, 'Windowstep',  50 ); % GUI: 10-Jul-2023 17:13:29

%save Moving Window artifact rejection summary in textfile
EEG = pop_summary_AR_eeg_detection(EEG, 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\AMT018\02_ERP\01_Pretest\AMT018_PT_AR_Summary.txt'); % GUI: 10-Jul-2023 17:12:10

%save AR dataset
EEG.setname='AMT018_PT_filt_REREF_cluster_impel_be_ICApruned_mwsstep_ar';
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','11_AMT018_PT_filt_impel_be_REREF_ICAmwstepAR.set','filepath','C:\\Users\\JorgeD_HirakiLab\\Documents\\UTokyo_WS2020\\Hiraki Lab\\14_Experiments\\01_Association_Memory_Task\\04_Data collection experiment\\Analysis\\EEG\\AMT018\\02_ERP\\01_Pretest');

%Plot AR detected dataset (Optional)
pop_eegplot( EEG, 1, 1, 1);

eeglab redraw;


%% 7. Calculate averaged ERPs and   ERP dataset

ERP = pop_averager( EEG , 'Criterion', 'good', 'DQ_custom_wins', 0, 'DQ_flag', 1, 'DQ_preavg_txt', 0, 'ExcludeBoundary', 'on', 'SEM', 'on' );

ERP = pop_savemyerp(ERP, 'erpname', 'AMT018_PT_erp', 'filename', 'AMT018_PT_erp.erp', 'filepath',...
 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\AMT018\02_ERP\01_Pretest', 'Warning',...
 'on');

%% 8. Export output data in text files

pop_erp2asc( ERP,...
 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\OutputTXT\AMT018_PT_erp.txt');

pop_export2text( ERP, 'C:\Users\JorgeD_HirakiLab\Documents\UTokyo_WS2020\Hiraki Lab\14_Experiments\01_Association_Memory_Task\04_Data collection experiment\Analysis\EEG\OutputTXT\AMT018_PT.txt',...
  1:2, 'electrodes', 'on', 'precision',  2, 'time', 'on', 'timeunit',  0.001, 'transpose', 'on' );

fprintf("Done!!\n")

%% Generate Waveform and scalpmaps

ERP = pop_ploterps( ERP,  [1 2],  1:21 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 5 5], 'ChLabel', 'on',...
 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' , 'g-' , 'c-' },...
 'LineWidth',  1, 'Maximize', 'on', 'Position', [ 391.875 6.66667 106.875 31.9048], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0,...
 'xscale', [ -200.0 996.0   -200:200:800 ], 'YDir', 'normal' );

ERP = pop_scalplot( ERP, [1 2], [ 300 500; 500 800] , 'Blc', 'pre', 'Colorbar', 'on', 'Colormap', 'jet', 'Electrodes', 'on', 'FontName',...
 'Courier New', 'FontSize',  10, 'Legend', 'bn-bd-la', 'Maplimit', 'maxmin', 'Mapstyle', 'both', 'Maptype', '2D', 'Mapview', '+X', 'Plotrad',...
  0.55, 'Value', 'mean' );