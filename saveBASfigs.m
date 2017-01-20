function saveBASfigs(mouseNum,varargin)
    
    % default params
    initials = 'LT';
    userFile = 'userData_SK_Rig_4_ViRMEn.txt';
    
    varargin2V(varargin);
    mouseID = sprintf('%s%03d',initials,mouseNum);
    
    folder_name = sprintf('Z:\\HarveyLab\\Shin\\ShinDataAll\\Current Mice\\%s\\',mouseID);
    file_list = uigetfile([folder_name,'*_Cell.mat'],'MultiSelect','on');
    
    CurrentMiceInd = strfind(folder_name,'\Current Mice');
    figpath = [folder_name(1:CurrentMiceInd),'BASfigs\',mouseID,'\'];
    
    if ~exist(figpath,'dir')
        mkdir(figpath);
    end
    
    for fi = 1:length(file_list)
        file_name = [folder_name,file_list{fi}];
        startBAS(userFile,'batch_flag',1,'FileToLoad',file_name);
    end
end