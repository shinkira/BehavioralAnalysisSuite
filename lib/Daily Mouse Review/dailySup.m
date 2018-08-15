function dailySup(mice_vec)

if strcmp(mice_vec,'norm')
   mice_vec = [47,48,51,52,55:70];
end

for mi = mice_vec
    initials = getInitials(mi);
    folder_name = sprintf('Z:\\HarveyLab\\Tier1\\Shin\\ShinDataAll\\Current Mice\\%s%03d\\',initials,mi);
    file_list = dir(fullfile(folder_name,'*Cell*.mat'));
    correctAll = [];
    for i = 1:length(file_list)
        mystring = file_list(i).name;
        mydate = datestr(now,'yymmdd');
        % mydate = strcat(mystring(7:8),',',mystring(9:10),',',mystring(11:12));
        if strfind(mystring,mydate) % mydate == day
           load([folder_name,file_list(i).name])
           for ci = 1:length(dataCell)
               correct(ci) = dataCell{ci}.result.correct;
           end
           correctAll = [correctAll,correct];
           clear correct
        end
    end
    fprintf('mouse #%d',mi)
    if isempty(correctAll)
        fprintf(2,'\tGive 850 uL\n');
    else
        total_trials = length(correctAll);
        total_feedings = sum(correctAll);
        if total_feedings < 170
               need_feed = (170 - total_feedings) * 5;
               fprintf('\t%d uL (%d/%d)\n',need_feed,total_feedings,total_trials);
        else
               fprintf('\tNo Need (%d/%d)\n',total_feedings,total_trials);
        end
    end
    clear dataCell
end
% dailyBASfigs

