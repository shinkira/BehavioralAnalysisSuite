function [accuracy,maxGreyFac] = sortData(mouseNum)
%This function extracts data from mice files and returns the accuracy and
%greyFac history for the particular mouse
%Ted Lutkus 7/17/2017

%Getting initials for mouse
mouseN = str2num(mouseNum);
if mouseN <= 18
    initials = 'LT';
elseif mouseN <= 26
    initials = 'DA';
elseif mouseN <= 46
    initials = 'VS';
elseif mouseN<=58
    initials = 'TL';
else
    initials = 'JD';
end

%Accessing mouse folder
mouseFolder = strcat('Z:/HarveyLab/Tier1/Shin/ShinDataAll/Current Mice/',initials,'0',mouseNum);
oldFolder = cd(mouseFolder);
fileList = what(mouseFolder);

%Loop through all .mat files to obtain those with 'Cell' in the name
m = 1;
cellFileList = cell(length(fileList.mat),1);
CellStr(1:5) = {'Cell', 'Cell_1', 'Cell_2', 'Cell_3', 'Cell_4'};
%Separating .mat files to yield only those WITHOUT '_Cell' in matFileList
%and WITH '_Cell' in cellFileList. The if statements and loops ensure
%that only one session is taken from each day
for i = 1:length(fileList.mat)
    %If 'Cell' is not in the filename
    if ~isempty(regexp(fileList.mat{i,1},'_Cell','once'));
        %Loop through with the same purpose as previously explained
        for k = 1:5
            if ~isempty(regexp(fileList.mat{i,1},CellStr{1,k},'once'));
                cellFileList{m,1} = fileList.mat{i,1};
            end
        end
    m = m + 1;
    end
end

cellFileList = cellFileList(~cellfun(@isempty,cellFileList));

%Looping through each trial of each session, storing accuracy of the mouse
%with each trial condition
maxGreyFac = zeros(length(cellFileList),1);
for i=1:length(cellFileList)
    procCellMat = open(cellFileList{i,1});
    blackRightTot = 0;
    blackLeftTot = 0;
    whiteRightTot = 0;
    whiteLeftTot = 0;
    blackRightCorrect = 0;
    blackLeftCorrect = 0;
    whiteRightCorrect = 0;
    whiteLeftCorrect = 0;
    greyFac = 0;
    for j=1:length(procCellMat.dataCell)
        if isfield(procCellMat.dataCell{1,j}.maze,'greyFac') == 1
            if procCellMat.dataCell{1,j}.maze.greyFac > greyFac
                greyFac = procCellMat.dataCell{1,j}.maze.greyFac;
                maxGreyFac(i) = greyFac;
            end
        else
            maxGreyFac(i) = 0;
        end
        if procCellMat.dataCell{1,j}.maze.leftTrial == 1 && procCellMat.dataCell{1,j}.maze.whiteTrial == 0
            blackRightTot = blackRightTot + 1;
            if procCellMat.dataCell{1,j}.result.correct == 1
                blackRightCorrect = blackRightCorrect + 1;
            end
        end
        if procCellMat.dataCell{1,j}.maze.leftTrial == 0 && procCellMat.dataCell{1,j}.maze.whiteTrial == 0
            blackLeftTot = blackLeftTot + 1;
            if procCellMat.dataCell{1,j}.result.correct == 1
                blackLeftCorrect = blackLeftCorrect + 1;
            end
        end
        if procCellMat.dataCell{1,j}.maze.leftTrial == 1 && procCellMat.dataCell{1,j}.maze.whiteTrial == 1
            whiteRightTot = whiteRightTot + 1;
            if procCellMat.dataCell{1,j}.result.correct == 1
                whiteRightCorrect = whiteRightCorrect + 1;
            end
        end
        if procCellMat.dataCell{1,j}.maze.leftTrial == 0 && procCellMat.dataCell{1,j}.maze.whiteTrial == 1
            whiteLeftTot = whiteLeftTot + 1;
            if procCellMat.dataCell{1,j}.result.correct == 1
                whiteLeftCorrect = whiteLeftCorrect + 1;
            end
        end
    end
    accuracy.BR{i,1} = blackRightCorrect/blackRightTot;
    accuracy.BL{i,1} = blackLeftCorrect/blackLeftTot;
    accuracy.WR{i,1} = whiteRightCorrect/whiteRightTot;
    accuracy.WL{i,1} = whiteLeftCorrect/whiteLeftTot;
end

%Returning to original directory location
cd(oldFolder);
end