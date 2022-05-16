%% Script to Plot Spectrums for Each Sense Blank and Demonstrate Artifact Distortion
function [rawdata,spectraldata]=plot_distortion_across_senseblank(LFP_directory, savedir)
close all;
% Michaela Alarie
% Updated: May 16, 2022
%%% Usage
%{
This script uses functions overflow_across_senseblank.m and
preprocess_neural_recordings.m to recreate figure 2E-F from "Artifact
characterization and mitigation techniques during concurrent sensing and 
stimulation using bidirectional deep brain stimulation platforms."
%}
%%% Inputs
% LFP_directory: Location of LFP files 
    % Example of LFP_directory input:'C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Papers\Workshop_DoseDependentResponses\Code\Repository\LFP_Files';
% savedir: directory for saved figures
    % Example of savedir: savedir='C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Papers\Workshop_DoseDependentResponses\Code\Repository\SavedFigures\SenseBlankChanges\';
%%% Outputs
% rawdata: time domain data converted to 10s trials for each channel 
% spectraldata: computed PSDs for each channel

[~, blanktime]=overflow_across_senseblank(LFP_directory);
devs={'DeviceNPC700500H', 'DeviceNPC700501H'};
LFP_folder=[LFP_directory,'\SenseBlank_Changes'];
d=dir(LFP_folder);
d=d(3:end);
cmap=[223, 101, 176; 231, 41, 138; 206, 18, 86; 152, 0 67; 103, 0, 31]/255;
for i=1:length(devs)
    j2=1;
    for j=1:length(d)
         if exist(strcat([d(j).folder, '\', d(j).name, '\' devs{i}, '\RawDataTD.json']),'file') 
             [~, rawdata, spectraldata]=preprocess_neural_recordings([d(j).folder, '\', d(j).name], devs{i}, 500);
             close Figure 1
             close Figure 2
             % plots
             figure(3)
             subplot(length(devs),1,i)
             plot(spectraldata.f, 10*log10(mean(spectraldata.psdk0,2)), 'Color',cmap(j2,:),'MarkerFaceColor',cmap(j2,:),'MarkerEdgeColor',cmap(j2,:))
             hold on
             
             figure(4)
             subplot(length(devs),1,i)
             plot(spectraldata.f, 10*log10(mean(spectraldata.psdk0,2)), 'Color',cmap(j2,:),'MarkerFaceColor',cmap(j2,:),'MarkerEdgeColor',cmap(j2,:))
             hold on
             j2=j2+1;
         else
         end
    end
end
%%
for i=1:length(devs)
    figure(3)
    subplot(length(devs), 1, i)
    legend(num2str((blanktime.(devs{i}))))
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    figure(4)
    subplot(length(devs), 1, i)
    xlim([128 210])
    legend(num2str((blanktime.(devs{i}))))
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
end

figure(3)
subplot(length(devs), 1, 1)
title('L Stimulation Artifact Distortion Across Sense Blank Values')
subplot(length(devs), 1, 2)
title('R Stimulation Artifact Distortion Across Sense Blank Values')

figure(4)
subplot(length(devs), 1, 1)
title('L Stimulation Artifact Distortion Across Sense Blank Values (128-210Hz)')
subplot(length(devs), 1, 2)
title('R Stimulation Artifact Distortion Across Sense Blank Values (128-210Hz)')

%% Save
saveas(figure(3), fullfile([savedir 'Distortion_Across_SenseBlank.png']))
saveas(figure(3), fullfile([savedir 'Distortion_Across_SenseBlank.svg']))
saveas(figure(4), fullfile([savedir 'Distortion_Across_SenseBlank (ZOOM).png']))
saveas(figure(4), fullfile([savedir 'Distortion_Across_SenseBlank (ZOOM).svg']))
end