function dailyBASfigs(d)

% dailyBASfigs(d) makes plots for the last d days.

% default params
userFile = 'userData_SK_Rig_5_ViRMEn.txt';

mouse_list = 101:104;
% mydate = datestr(now,'yymmdd');
% mydate = num2str(str2double(mydate)-1);

for mi = mouse_list
    
    initials = getInitials(mi);
    today = ceil(now);
    
    if nargin==0
        date_set = now; %datestr(now,'yymmdd');
    else
        if ischar(d)
            date_set = floor(datenum(d,'yymmdd'));
        else
            date_set = today-d:today;
        end
    end
    
    for di = 1:length(date_set)
        mydate = datestr(date_set(di),'yymmdd');
        mouseID = sprintf('%s%03d',initials,mi);
        folder_name = sprintf('Z:\\HarveyLab\\Tier1\\Shin\\ShinDataAll\\Current Mice\\%s\\',mouseID);
        file_list = dir(fullfile(folder_name,sprintf('*%s_Cell*.mat',mydate)));
        CurrentMiceInd = strfind(folder_name,'\Current Mice');
        figpath = ['E:\Dropbox (HMS)\BASfigs\',mouseID,'\'];

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
end

