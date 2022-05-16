%% Plot Ratio Changes
function [Ratio_val]=plot_ratio(LFP_Folder, savedir)
close all;
addpath(genpath('C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Analysis-rcs-data-master'))
addpath(genpath('C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Papers\Workshop_DoseDependentResponses\Code\Repository'))
% Michaela Alarie
% Updated: May 16, 2022
%%% Usage
%{
Compute PSD for recordings with varying ratio values for left and right
hemisphere.
%}
%%% Inputs
% LFP_Folder: Location of LFP files for ratio changes
    % Example of LFP_Folder input: LFP_Folder='C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Papers\Workshop_DoseDependentResponses\Code\Repository\LFP_Files\Ratio_Changes\';
% savedir: directory for saved figures
    % Example of savedir: savedir='C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Papers\Workshop_DoseDependentResponses\Code\Repository\SavedFigures\RatioChanges\';
%%% Outputs
% Ratio_val: ratio values for each LFP file

session_list=dir(LFP_Folder);
session_list=session_list(3:end);
n_sessions = size(session_list,1);
fs=500;
cmap=([237,248,233; 199,233,192; 161,217,155; 116,196,118; 65,171,93; 35,139,69; 0,90,50])/255;
devs={'DeviceNPC700500H', 'DeviceNPC700501H'};
p1=1;
Ratio_val=[];
for j=1:length(devs)
    for i=1:n_sessions
        if exist(strcat([session_list(i).folder, '\', session_list(i).name, '\' devs{j}, '\RawDataTD.json']),'file') 
            [~, ~, spectraldata]=preprocess_neural_recordings([session_list(i).folder, '\', session_list(i).name], devs{j}, fs);
            DeviceSettings_fileToLoad = deserializeJSON([session_list(i).folder, '\', session_list(i).name, '\' devs{j}, '\DeviceSettings.json']);
            Ratio_val=[Ratio_val;DeviceSettings_fileToLoad{end-1}.TelemetryModuleInfo.TelmRatio];
            close Figure 1
            close Figure 2
            figure(3)
            plot(spectraldata.f, 10*log10(mean(spectraldata.psdk0,2)),'Color',cmap(p1,:),'MarkerFaceColor',cmap(p1,:),'MarkerEdgeColor',cmap(p1,:), 'LineWidth', 1.2); ylim([-100 -19]);
            hold on
            p1=p1+1;
        else
        end
    end
    p1=1;
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    legend([num2str(Ratio_val)])
    if devs{j}==devs{1}
        title('Left Hemisphere Ratio Changes')
        saveas(figure(3), fullfile([savedir 'LeftHem_RatioChanges.png']))
        saveas(figure(3), fullfile([savedir 'LeftHem_RatioChanges.eps']))
    else
        title('Right Hemisphere Ratio Changes')
        saveas(figure(3), fullfile([savedir 'RightHem_RatioChanges.png']))
        saveas(figure(3), fullfile([savedir 'RightHem_RatioChanges.eps']))
    end
    close Figure 3
    Ratio_val=[];
end