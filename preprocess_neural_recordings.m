%% Preprocess Neural Recordings 
function [combined_table,rawdata, spectraldata]=preprocess_neural_recordings(LFP_Folder, device_name, fs)%, savedir)
% Michaela Alarie
% Updated: May 12, 2022
%%% Usage
%{
Pulls session folder containing json logs from Summit RC+S device. Raw data
time domain plot is then made. The entire raw TD file is then converted
into trials of 10s, computing a PSD for each trial. PSDs are computed using
a hamming window of 500ms with 250ms overlap.
%}
%%% Inputs
% LFP_Folder: Directory where LFP session folder resides
% device_name: Name of the device. Example: NPC700399H
% fs: sampling rate
%%% Outputs
% combined_table: table with multiple data streams and harmonized DerivedTimes
% rawdata: time domain data converted to 10s trials for each channel 
% (0-3, 1 is turned off as the stimulating contact) of recordings. Trials
% with packet loss are thrown out. 
addpath(genpath('C:\Users\Michaela\Documents\MATLAB\Michaela_Stronghold_Environment\Analysis-rcs-data-master\code\'))
rawdata=struct;
spectraldata=struct;
if isfolder([LFP_Folder,'\', device_name])
    %% Load Patient/Date Information
    [unifiedDerivedTimes, timeDomainData, timeDomainData_onlyTimeVariables, timeDomain_timeVariableNames, AccelData, AccelData_onlyTimeVariables, Accel_timeVariableNames,...
        PowerData, PowerData_onlyTimeVariables, Power_timeVariableNames,FFTData, FFTData_onlyTimeVariables, FFT_timeVariableNames,AdaptiveData, AdaptiveData_onlyTimeVariables, Adaptive_timeVariableNames,...
        timeDomainSettings, powerSettings, fftSettings, eventLogTable, metaData, stimSettingsOut, stimMetaData, stimLogSettings,...
        DetectorSettings, AdaptiveStimSettings, AdaptiveEmbeddedRuns_StimSettings]= ProcessRCS([LFP_Folder,'\', device_name]);

    dataStreams={timeDomainData, AccelData, PowerData, FFTData, AdaptiveData};
    combined_table = createCombinedTable(dataStreams, unifiedDerivedTimes, metaData);
    
    figure(1)
    subplot(311)
    hold on
    plot(combined_table.DerivedTime, combined_table.TD_key0-mean(fillgaps(combined_table.TD_key0,25)));
    ylim([-1 1]); xlabel('Time (s)'); ylabel('mV'); title('Contact 0-2 (LFP)')
    subplot(312)
    plot(combined_table.DerivedTime, combined_table.TD_key2-mean(fillgaps(combined_table.TD_key2,25)));
    ylim([-0.5 0.5]); xlabel('Time (s)'); ylabel('mV'); title('Contact 8-9 (ECoG)')
    subplot(313)
    plot(combined_table.DerivedTime, combined_table.TD_key3-mean(fillgaps(combined_table.TD_key3,25)));
    ylim([-0.5 0.5]); xlabel('Time (s)'); ylabel('mV'); title('Contact 10-11 (ECoG)')
    sgtitle('Left Hem')
    
    %% Fill nan gaps (needed if implementing PARRM, optional for 
    temp_K0=fillgaps(combined_table.TD_key3, 25); 
    temp_K2=fillgaps(combined_table.TD_key2, 25); 
    temp_K0=fillgaps(combined_table.TD_key0, 25);
    k0=combined_table.TD_key0(combined_table.DerivedTime>0); 
    
%     prompt = ' Plot PSD (enter 1 for yes)? ';
%     plot_psd = input(prompt);
%     if plot_psd==1
        T=10;
        trimmed_length= floor(length(k0)/(fs*T))*(fs*T);

        %% Split Each Hemisphere Task Data into 10s Trials of Data
        nTrials=1;
        k0=reshape(k0(1:trimmed_length),T*fs,nTrials*trimmed_length/(T*fs));
        k2=combined_table.TD_key2(combined_table.DerivedTime>0); 
        k2=reshape(k2(1:trimmed_length),T*fs,nTrials*trimmed_length/(T*fs));
        k3=combined_table.TD_key3(combined_table.DerivedTime>0); 
        k3=reshape(k3(1:trimmed_length),T*fs,nTrials*trimmed_length/(T*fs));
        
        rawdata=struct;
        i2=1;
        for q=1:length(k3(1,:))
            if nnz(isnan(k3(:,q)))>0
            else
                rawdata.k0(:,i2)=k0(:,q);
                rawdata.k2(:,i2)=k2(:,q);
                rawdata.k3(:,i2)=k3(:,q);
                i2=i2+1;
            end
        end
        
        [spectraldata.psdk0, ~]=pwelch(rawdata.k0-mean(rawdata.k0), hamming(fs), floor(fs/2), [], fs);
        [spectraldata.psdk2, ~]=pwelch(rawdata.k2-mean(rawdata.k2), hamming(fs), floor(fs/2), [], fs);
        [spectraldata.psdk3, spectraldata.f]=pwelch(rawdata.k3-mean(rawdata.k3), hamming(fs), floor(fs/2), [], fs);
        
        
        figure(2)
        subplot(311)
        hold on
        plot(spectraldata.f, 10*log10(mean(spectraldata.psdk0,2)));
        xlabel('Frequency (Hz)'); ylabel('Power (dB)'); title('Contact Pair 0-2')
        subplot(312)
        plot(spectraldata.f, 10*log10(mean(spectraldata.psdk2,2))); 
        xlabel('Frequency (Hz)'); ylabel('Power (dB)'); title('Contact Pair 8-9')
        subplot(313)
        plot(spectraldata.f, 10*log10(mean(spectraldata.psdk3,2)));
        xlabel('Frequency (Hz)'); ylabel('Power (dB)'); title('Contact Pair 10-11')
        sgtitle('Left Hem')

%         prompt4 = 'Save images (1 for yes)?';
%         saveimages = input(prompt4);
%         if saveimages==1
%             % Save Raw Data Plots
%             saveas(figure(1), fullfile([savedir '\TD.png']))
%             % Save Spectral Power Plots
%             saveas(figure(2), fullfile([savedir '\psd.png']))
%         else
%         end
%     else
%     end
else
end
end