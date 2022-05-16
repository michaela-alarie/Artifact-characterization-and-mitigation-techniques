%% Plot Overflow Across Sense Blank Script
function [session_overflow_total, blanktime]=plot_overflow_across_senseblank(LFP_directory, savedir)
close all;
% Michaela Alarie
% Updated: May 16, 2022
%%% Usage
%{
Uses overflow_across_senseblank.m and calculate_overflow.m functions to
plot overflow across different sense blank values tested and recreate
Figure 2 C-D from "Artifact characterization and mitigation techniques 
during concurrent sensing and stimulation using bidirectional deep brain 
stimulation platforms."
%}
%%% Inputs
% LFP_directory: Location of LFP files 
    % Example of LFP_directory input:'C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Papers\Workshop_DoseDependentResponses\Code\Repository\LFP_Files';
% savedir: directory for saved figures
    % Example of savedir: savedir='C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Papers\Workshop_DoseDependentResponses\Code\Repository\SavedFigures\SenseBlankChanges\';
%%% Outputs
% session_overflow_total: computes overflow for each session, for each device
% blanktime: computes the blank time for each session, for each device

%% Set LFP_directory and Calculate Overflow
% remember also need to change devices in overflow_across_senseblank.m
[session_overflow_total, blanktime]=overflow_across_senseblank(LFP_directory);
devs={'DeviceNPC700500H', 'DeviceNPC700501H'};

%% Plot
cmap = [121,120,180;228,23,138;51,250,44;251,154,53;71,224,253;191,140,240;255,155,255]/255;
f = figure(1);
f.Units = 'inches';
f.Position = [1,1,8,4];
% Left Hemisphere
h(1) = subplot(1,2,1);
plot(blanktime.(devs{1}),session_overflow_total.(devs{1})(:,4)*100,'-o','Color',cmap(1,:),'MarkerFaceColor',cmap(1,:),'MarkerEdgeColor',cmap(1,:))
hold on
plot(blanktime.(devs{1}),session_overflow_total.(devs{1})(:,2)*100,'-o','Color',cmap(6,:),'MarkerFaceColor',cmap(6,:),'MarkerEdgeColor',cmap(6,:))
hold on
plot(blanktime.(devs{1}),session_overflow_total.(devs{1})(:,1),'-o','Color',cmap(4,:),'MarkerFaceColor',cmap(4,:),'MarkerEdgeColor',cmap(4,:))
ylim([0 100])
ylabel('Percent Overflow (%)')
title('Left Hemisphere')
legend({'sense 0 to sense 2';'sense 8 to sense 9';'sense 10 to sense 11'},'Location','southoutside');
xlabel('Sense Blank Time (ms)') 
% Right Hemisphere
h(2) = subplot(1,2,2);
plot(blanktime.(devs{2}),session_overflow_total.(devs{2})(:,4)*100,'-o','Color',cmap(1,:),'MarkerFaceColor',cmap(1,:),'MarkerEdgeColor',cmap(1,:))
hold on
plot(blanktime.(devs{2}),session_overflow_total.(devs{2})(:,2)*100,'-o','Color',cmap(6,:),'MarkerFaceColor',cmap(6,:),'MarkerEdgeColor',cmap(6,:))
hold on
plot(blanktime.(devs{2}),session_overflow_total.(devs{2})(:,1),'-o','Color',cmap(4,:),'MarkerFaceColor',cmap(4,:),'MarkerEdgeColor',cmap(4,:))
ylim([0 100])
title('Right Hemisphere')
ylabel('Percent Overflow (%)')
legend({'sense 0 to sense 2';'sense 8 to sense 9';'sense 10 to sense 11'},'Location','southoutside');
xlabel('Sense Blank Time (ms)')

saveas(figure(1), fullfile([savedir 'Overflow_Across_SenseBlank.png']))
saveas(figure(1), fullfile([savedir 'Overflow_Across_SenseBlank.svg']))
end