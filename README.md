# Artifact-characterization-and-mitigation-techniques
### Usage
Repository for figures created in _Artifact characterization and mitigation techniques during concurrent sensing and stimulation using
bidirectional deep brain stimulation platforms_. Creates plots for overflow testing and distortion across sense blank values. Also includes
plots for ratio testing. 

## Saved Figures
Folder contains example figures from paper

# Functions
## **calculate_overflow.m**
Calculates percent overflow across packets in one LFP session folder. Loops through all packets, looking for overflow across all the channels,
dividing by the number of packets to find the percentage of overflow in each channel.

**_Inputs:_**

_LFP_session_folder_: Folder produced after recording in format 'SessionXYZ' where XYZ is time of recording in unix time

_device_name_: mat file of individual device names

**_Outputs:_**

_session_overflow_: Overflow by individual channel where [0; 0; 0; 0] format represents channels [3; 2; 1; 0] (ex 3 is contact pair 10-11).

## **overflow_across_senseblank.m**
Code that pulls calculate_overflow.m function to find overflow across many lfp files with varied sense blank values. This could be adapted to have a
"devices" input, but is pre-defined for simplicity. 

**_Inputs:_**

_LFP_directory_: filepath where folder containing sense blank files is located

**_Outputs:_**

_session_overflow_total_: computes overflow for each session, for each device

_blanktime_: computes the blank time for each session, for each device

## **preprocess_neural_recordings.m**
Pulls session folder containing json logs from Summit RC+S device. Raw data time domain plot is then made. The entire raw TD file is then converted
into trials of 10s, computing a PSD for each trial. PSDs are computed using a hamming window of 500ms with 250ms overlap.

**_Inputs:_**

_LFP_Folder_: Directory where LFP session folder resides

_device_name_: Name of the device. Example: NPC700399H

_fs_: sampling rate

**_Outputs:_**

_combined_table_: table with multiple data streams and harmonized DerivedTimes

_rawdata_: time domain data converted to 10s trials for each channel (0-3, 1 is turned off as the stimulating contact) of recordings. Trials
with packet loss are thrown out. 

## **plot_overflow_across_senseblank.m**
Uses overflow_across_senseblank.m and calculate_overflow.m functions to plot overflow across different sense blank values tested 

**_Inputs:_**

_LFP_directory_: Location of LFP files 

_savedir_: directory for saved figures

**_Outputs:_**

_session_overflow_total_: computes overflow for each session, for each device

_blanktime_: computes the blank time for each session, for each device

## **plot_distortion_across_senseblank.m**
Uses overflow_across_senseblank.m and preprocess_neural_recordings.m functions to plot PSDs across different sense blank values tested 

**_Inputs:_**

_LFP_directory_: Location of LFP files 

_savedir_: directory for saved figures

**_Outputs:_**

_rawdata_: time domain data converted to 10s trials for each channel 

_spectraldata_: computed PSDs for each channel

## **plot_ratio.m**
Compute PSD for recordings with varying ratio values for left and right hemisphere

**_Inputs:_**

_LFP_directory_: Location of LFP files 

_savedir_: directory for saved figures

**_Outputs:_**

_Ratio_val_: ratio values for each LFP file
