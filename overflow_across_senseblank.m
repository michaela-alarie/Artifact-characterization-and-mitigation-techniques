%% Calculates Percent Overflow Across Sense Blank
function [session_overflow_total, blanktime]=overflow_across_senseblank(LFP_directory)
% Michaela Alarie
% Updated: May 11, 2022
%%% Usage
%{
Code that pulls calculate_overflow.m function to find overflow across many
lfp files with varied sense blank values. This could be adapted to have a
"devices" input, but is pre-defined for simplicity. 
%}
%%% Inputs
% LFP_directory: filepath where folder containing sense blank files is located
%%% Outputs
% session_overflow_total: computes overflow for each session, for each device
% blanktime: computes the blank time for each session, for each device

d=dir(strcat(LFP_directory));
d=d(3); %looking for just 'sense blank folder' shared with this function
devices={'DeviceNPC700500H', 'DeviceNPC700501H'}; % should be changed for specific devices (left hem should be first input)
session_overflow_total=struct;
blanktime=struct;

for dev=1:length(devices)
    l2=1;
    session_overflow_total.(devices{dev})=[];
    blanktime.(devices{dev})=[];

    if isfolder([LFP_directory, '\SenseBlank_Changes']) % SenseBlank_Changes folder is from testing done for this experiment
        lfpFolders=dir([LFP_directory, '\SenseBlank_Changes']);
        lfpFolders=lfpFolders(3:end);
        lfpNames=string({lfpFolders.name});
        lfpFolders=lfpFolders(startsWith(lfpNames,'Session'));

        for l=1:length(lfpFolders)
            if exist(strcat([LFP_directory, '\SenseBlank_Changes', '\', lfpFolders(l).name, '\' devices{dev}, '\RawDataTD.json']),'file') 
                [session_overflow]=calculate_overflow([LFP_directory, '\SenseBlank_Changes\', lfpFolders(l).name], devices{dev});
                session_overflow_total.(devices{dev})=[session_overflow_total.(devices{dev}); session_overflow];
                devicesettings_fileToLoad =[LFP_directory, '\SenseBlank_Changes', '\', lfpFolders(l).name, '\' devices{dev}, '\DeviceSettings.json'];
                deviceset = deserializeJSON(devicesettings_fileToLoad); % loads device settings file which contains sense blank information by packet
                blank=deviceset{1,1}.SensingConfig.senseBlanking.blankingExtensionTime/100;
                blanktime.(devices{dev})=[blanktime.(devices{dev}); blank];
                l2=l2+1;
            else
            end
        end

    else
    end
    clear l2
end
end