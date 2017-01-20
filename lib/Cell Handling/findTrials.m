function [ind] = findTrials(dataCell,cond)
%findTrials.m This function returns the indices of trials in data which
%meet cond
%
%ASM 9/12 modified from tfind.m ART

%check if pattern
if isnumeric(cond)
    ind = findPatternTrials(dataCell,cond);
    return;
end

%parse the condition
parsedCond = parseCondAM(cond);

if isempty(parsedCond)
    ind = ones(size(dataCell));
    return;
end

%loop through each parsed cond, and if function present, evaluate and
%convert
for i = 1:length(parsedCond) %for each parsed cond
    %search for !
    bangInd = regexp(parsedCond{i},'!','once');
    if isempty(bangInd) %skip if not present
        continue;
    end
    
    %extract section after bang
    bangPhrase = parsedCond{i}(bangInd+1:end-2);
    
    %evaluate bangPhrase
    bangVal = eval(bangPhrase);
    
    %replace parsedCond
    parsedCond{i} = [parsedCond{i}(1:bangInd-1),num2str(bangVal),' )'];
    
end

%combine parsed conditions 
%This section takes individual cell elements and converts them into
%testable conditions
if ischar(parsedCond)
    logicals = {parsedCond};
elseif iscell(parsedCond) %multiple conditions to test
    logicals = cell(1,size(parsedCond,2));
    for i=1:size(parsedCond,2) %for each @ condition
        logicals{i} = [];
        for j=1:size(parsedCond,1) %for each subcondition
            if j==size(parsedCond,1) %if last condition
                logicals{i} = [logicals{i},parsedCond{j,i}];
            else
                logicals{i} = [logicals{i},parsedCond{j,i},' && '];
            end
        end
    end
end

%extract indices which meet conditions 
ind = zeros(length(dataCell),length(logicals)); %initialize ind to have as many rows as cells in data and as many columns as @ conditions

%loop through each logical condition
for i=1:size(logicals,2)
    %create condFun
    eval(['condFun = @(x) ',logicals{i},';']);
    
    if ~isempty(dataCell)
        %run cellfun
        ind(:,i) = cellfun(condFun,dataCell);
    else
        ind(:,i) = [];
    end
end
ind = logical(ind); %convert to a logical
    
    
   
    
