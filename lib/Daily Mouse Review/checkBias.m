function checkBias(mouseNum)
%This function checks the bias for a given mouse, this is used in the
%reviewMice GUI
%Ted Lutkus 7/17/2017

%Call sortData() to clean data and calculate accuracies for each trial
%condition.
[accuracy,maxGreyFac] = sortData(mouseNum);
accuracyBR = cell2mat(accuracy.BR);
accuracyBL = cell2mat(accuracy.BL);
accuracyWR = cell2mat(accuracy.WR);
accuracyWL = cell2mat(accuracy.WL);
accuracyData = cat(2,accuracyBR,accuracyBL,accuracyWR,accuracyWL);

%Eliminating days where NaN numbers found
nan = isnan(accuracyData);
accIndex = sum(nan(:,1)) + 1;
lengthAccData = length(accuracyData(:,1));
accuracyData = accuracyData(accIndex:lengthAccData,:);
maxGreyFac = maxGreyFac(accIndex:length(maxGreyFac));

%Further cleaning data by removing first mazes where accuracy == 1.
for i=1:4
    for j=1:4
        if accuracyData(i,j) == 1
            accIndex = accIndex + 1;
        end
    end
end

lengthAccData = length(accuracyData(:,1));
accuracyData = accuracyData(accIndex:lengthAccData,:); 
accuracyData = accuracyData*100;
accuracyDataPreSmooth = accuracyData;
maxGreyFac = maxGreyFac(accIndex:length(maxGreyFac));

%Smoothing data, second parameter affects smoothing amount.
for i=1:4
accuracyData(:,i) = smoothdata(accuracyData(:,i),5);
end

%Prepare variables for boxplot of performance in last 5 sessions.
total = length(accuracyDataPreSmooth(:,1));
lastFive = total - 4;
accLastFive = accuracyDataPreSmooth(lastFive:total,:);
daysFive = (1:5);

days = (1:length(accuracyData))';
%Creating figure which includes accuracy data over all sessions, boxplot of
%last five sessions, and plot of last five sessions
figure('units','normalized','outerposition',[0 0.05 1 .95])
subplot(3,3,[1,2,3])
plot(days,accuracyData(:,1),'k')
hold on
plot(days,accuracyData(:,2),'c')
hold on
plot(days,accuracyData(:,3),'Color',[1,0.5,0])
hold on
plot(days,accuracyData(:,4),'m')
legend('location','southeast','Black Right','Black Left','White Right','White Left')
title('Accuracy for Trial Conditions vs Time (Smoothed)')
ylabel('Accuracy (%)')
xlabel('Time')
ylim([0 100])

%Boxplot
subplot(3,3,7)
boxplot(accLastFive,'Labels',{'Black Right','Black Left','White Right','White Left'})
ylim([50 100])
ylabel('Accuracy from 50% to 100%')
title('Accuracy for Last Five Sessions')

%Plot of maxGreyFac for each session
subplot(3,3,[4,5,6])
plot(days,maxGreyFac,'Color',[.5 .8 0])
hold on
scatter(days,maxGreyFac,'+','MarkerEdgeColor',[0 .5 .8],'LineWidth',1.5)
title('maxGreyFac vs Time')
xlabel('Time')
ylabel('maxGreyFac')

%Plot of last five days
subplot(3,3,9)
plot(daysFive,accLastFive(:,1),'k')
hold on
plot(daysFive,accLastFive(:,2),'c')
hold on
plot(daysFive,accLastFive(:,3),'Color',[1,0.5,0])
hold on
plot(daysFive,accLastFive(:,4),'m')
legend('location','southeast','Black Right','Black Left','White Right','White Left')
title('Accuracy for Trial Conditions vs Time (No Smoothing)')
ylabel('Accuracy (%)')
xlabel('Time')
ylim([0 100])


end