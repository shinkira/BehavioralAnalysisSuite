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

function latestfile = getxfromlatestfile(directory,x)
%This function returns the latest file from the directory passsed as input
%argument

%Get the directory contents
dirc = dir(directory);

%Filter out all the folders and find only files with .png
dirc = dirc(find(~cellfun(@isdir,{dirc(:).name})));
dir_p = dirc(find(~cellfun(@isempty,strfind({dirc(:).name},'.png'))));

%I contains the sorted list of files from latest to earliest
[A,I] =sort([dir_p(:).datenum],'descend');

if ~isempty(I)
    latestfile = dir_p(length(I)-x).name;
end

end

oldFolder = cd(mouse);

% arranging images
k = 1;
for i=1:7
    if k>4
        break
    end
    j = i-1;
    img = getxfromlatestfile(mouse,j);
    bas{k,1} = imread(img);
    basCrop{k,1} = imcrop(bas{i,1},[0.5 0.5 1328 579]);
    k = k+1;
end

%Returning to original directory location
cd(oldFolder)

end