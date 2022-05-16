%% Calculates Overflow in 1 LFP Session Folder
function [session_overflow]=calculate_overflow(LFP_session_folder, device_name)
% Michaela Alarie
% Updated: May 11, 2022
%%% Usage:
%{
Calculates percent overflow across packets in one LFP session folder
%}
%%% Inputs:
% LFP_session_folder: Folder produced after recording in format 'SessionXYZ' where XYZ is time of recording in unix time
% device_name: mat file of individual device names
%%% Outputs:
% session_overflow: Overflow by individual channel where [0; 0; 0; 0]
% format represents channels [3; 2; 1; 0] (example channel 3 is contact
% pair 10-11).

count=zeros([1 4]);
if exist(strcat(LFP_session_folder, '\', device_name, '\RawDataTD.json'),'file') 
    TD_fileToLoad = [LFP_session_folder,'\',device_name, '\RawDataTD.json']; 

    if isfile(TD_fileToLoad)
        jsonobj_TD = deserializeJSON(TD_fileToLoad); %loads raw TD json file

        if isfield(jsonobj_TD,'TimeDomainData') && ~isempty(jsonobj_TD.TimeDomainData)
            for k=1:length(jsonobj_TD.TimeDomainData)
                DebugInfo1(k)=jsonobj_TD.TimeDomainData(k).DebugInfo; % pulls debug information (reg slew overflow)
                PacketGenTime1(k)=jsonobj_TD.TimeDomainData(k).PacketGenTime;
            end
        else
        end

        PacketGenTime=PacketGenTime1;
        DebugInfo=DebugInfo1;
        for k=1:length(DebugInfo)
            DebugInfoBit=bitget(DebugInfo(k),4:-1:1,'int8'); % converts from binary
            count=count+DebugInfoBit;
        end

        DebugInfoCalc=count;
        debuglength=length(DebugInfo);
        if ~isempty(DebugInfo) % calculate percent overflow across packets
            bit0_percent= DebugInfoCalc(1,4)/debuglength;
            bit1_percent= DebugInfoCalc(1,3)/debuglength;
            bit2_percent= DebugInfoCalc(1,2)/debuglength;
            bit3_percent= DebugInfoCalc(1,1)/debuglength;
        else
        end

        session_overflow=[bit3_percent, bit2_percent, bit1_percent, bit0_percent];
    end
end
end