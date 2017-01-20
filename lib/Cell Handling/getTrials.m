function [trials] = getTrials(data,cond)
%getTrials.m This function extracts trials according to conditions
%specified in cond from data
%
%Makes use of parseCondAM and findTrials. Based on ART package
%
%ASM 9/12

ind = findTrials(data,cond); %run findTrials to get trial indices

if size(ind,2) > 1 
    trials = cell(1,size(ind,2));
    for i=1:size(ind,2)
        trials{i} = data(ind(:,i));
    end
else
    trials = data(ind);
end