function basCrop = pastDaysBe(mouseNum)
%This function obtains the BAS images for the past four days not including
%today
%for a particular mouse and returns the cropped images to be subplotted in
%reviewMice.m

%Getting the initials for the mouse
mouseN = str2double(mouseNum);
initials = getInitials(mouseN);

%Finding the mouse folder
mouse = strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Shin\ShinDataAll\BASfigs\',initials,'0',mouseNum);
picList = dir(mouse);

function latestfile = getlatestfile(directory)
%This function returns the latest file from the directory passsed as input
%argument

%Get the directory contents
dirc = dir(directory);

%Filter out all the folders.
dirc = dirc(find(~cellfun(@isdir,{dirc(:).name})));
dirc_p = dirc(find(any(regexp(dirc(:).name,'.png$'))));

%I contains the index to the biggest number which is the latest file
[A,I] = max([dirc_p(:).datenum]);

if ~isempty(I)
    latestfile = dirc_p(I).name;
end

end

oldFolder = cd(mouse);

k = 1;
for i=1:7
    if k>4
        break
    end
    img = getlatestfile(mouse);
    bas{k,1} = imread(img);
    basCrop{k,1} = imcrop(bas{i,1},[0.5 0.5 1328 579]);
    k = k+1;
end


%{
%Getting the past four days in a variable
day = datetime('today');
pastDayTimes = dateshift(day,'start','day',-6:0);
%pastDayTimes = dateshift(day,'start','day',-3:0); in pastDaysAf


%Obtaining past four training days. If a weekend date is encountered, the
%subsequent dates will be pushed back by two days so that only weekdays are
%included.
check = 0;
existCount = 0;
while check == 0
 
    %Cleaning up the pastDays variable to access the .png images
    pastDays = pastDayTimes(1:7)';
    pastDays = datestr(pastDays,'yymmdd');
    pastDays = strcat(initials,'0',mouseNum,'_',pastDays,'.png');
    pastDays = cellstr(pastDays);
    check = 1;
    
    for j=7:-1:1
        if existCount>5
            break
        end
        if exist(pastDays{j}) == 0
            existCount = existCount+1;
            pastDayTimes(j:-1:1) = dateshift(pastDayTimes(j:-1:1),'start','day',-1);
            check = 0;
        end
    end
end

%{
  for i=7:-1:2
        if isweekend(pastDayTimes(i)) == 1
            pastDayTimes(i:i-1:i+1) = dateshift(pastDayTimes(i:i-1:i+1),'dayofweek','Friday','previous');
            i=1;
        elseif pastDayTimes(i) == pastDayTimes(i-1)
            pastDayTimes(i-1:-1:2) = dateshift(pastDayTimes(i-1:-1:2),'start','day',-1);
            i=1;
            if pastDayTimes(1) >= pastDayTimes(2)
                pastDayTimes(1) = dateshift(pastDayTimes(1),'start','day',-1);
                if isweekend(pastDayTimes(1))
                    pastDayTimes(1) = dateshift(pastDayTimes(1),'dayofweek','Friday','previous');
                end
            end
        end
    end
%}
pastDays = flip(pastDays);

%Looping over each image and cropping for figure
k = 1; % counter
for i=1:7
    if k>4
        break
    end
    if exist(pastDays{i,1})
        bas{k,1} = imread(pastDays{i,1});
        basCrop{k,1} = imcrop(bas{i,1},[0.5 0.5 1328 579]);
        k = k+1;        
    end
end
%}

%Returning to original directory location
cd(oldFolder)

end