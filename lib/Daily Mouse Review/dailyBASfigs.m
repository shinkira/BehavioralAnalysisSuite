function dailyBASfigs(varargin)

% default params
userFile = 'userData_SK_Rig_5_ViRMEn.txt';
mouse_list = 40:60;
% mydate = datestr(now,'yymmdd');
% mydate = num2str(str2double(mydate)-1);

for mi = mouse_list
    
    if mi<=18
        initials = 'LT';
    elseif mi <= 26
        initials = 'DA';
    elseif mi <= 46
        initials = 'VS';
    else
        initials = 'TL';
    end    
    if nargin==0
        mydate = datestr(now,'yymmdd');
    else
        mydate = varargin{1};
    end
    
    mouseID = sprintf('%s%03d',initials,mi);
    folder_name = sprintf('Z:\\HarveyLab\\Tier1\\Shin\\ShinDataAll\\Current Mice\\%s\\',mouseID);
    file_list = dir(fullfile(folder_name,sprintf('*%s_Cell*.mat',mydate)));
    CurrentMiceInd = strfind(folder_name,'\Current Mice');
    figpath = [folder_name(1:CurrentMiceInd),'BASfigs\',mouseID,'\'];
    for fi = 1:length(file_list)
        file_name = [folder_name,file_list(fi).name];
        if strfind(file_name,mydate)
            load(file_name) 
            if ~exist(figpath,'dir')
                mkdir(figpath);
            end
            startBAS(userFile,'batch_flag',1,'FileToLoad',file_name);
        end
        close all
    end
end

