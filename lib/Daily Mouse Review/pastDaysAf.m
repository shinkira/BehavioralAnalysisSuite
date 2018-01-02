function basCrop = pastDaysAf(mouseNum)
%This function obtains the BAS images for the past three days and today
%for a particular mouse and returns the cropped images to be subplotted in
%reviewMice.m

%Getting the initials for the mouse
mouseN = str2num(mouseNum);
if mouseN <= 18
        initials = 'LT';
    elseif mouseN <= 26
        initials = 'DA';
    elseif mouseN <= 46
        initials = 'VS';
    else
        initials = 'TL';
end

%Finding the mouse folder
mouse = strcat('Z:/HarveyLab/Tier1/Shin/ShinDataAll/BASfigs/',initials,'0',mouseNum);

oldFolder = cd(mouse);

%Getting the past three days and today in a variable
day = datetime('today');
%pastDayTimes = dateshift(day,'start','day',-4:-1); in pastDaysBe
pastDayTimes = dateshift(day,'start','day',-3:0);


%Obtaining past four training days. If a weekend date is encountered, the
%subsequent dates will be pushed back by two days so that only weekdays are
%included.
check = 0;
while check == 0
    for i=4:-1:1
         if isweekend(pastDayTimes(i)) == 1
             pastDayTimes(i:-1:1) = dateshift(pastDayTimes(i:-1:1),'start','day',-2);
             i=1;
         end
    end

    %Cleaning up the pastDays variable to access the .png images
    pastDays = pastDayTimes(1:4)';
    pastDays = datestr(pastDays,'yymmdd');
    pastDays = strcat(initials,'0',mouseNum,'_',pastDays,'.png');
    pastDays = cellstr(pastDays);
    check = 1;
    
    for j=4:-1:1
         if exist(pastDays{j}) == 0
         pastDayTimes(j:-1:1) = dateshift(pastDayTimes(j:-1:1),'start','day',-1);
         check = 0;
         end
    end
end

pastDays = flip(pastDays);

%Looping over each image and cropping for figure
for i=1:4
    bas{i,1} = imread(pastDays{i,1});
    basCrop{i,1} = imcrop(bas{i,1},[0.5 0.5 1328 579]);
end

%Returning to original directory location
cd(oldFolder)

end