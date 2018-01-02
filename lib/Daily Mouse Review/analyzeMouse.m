function analyzeMouse(mouseNum)
%This function analyzes the running behavior for a given mouse using
%animated histograms

%Ted Lutkus 8/23/2017

%Call posCompare() to obtain the running behavior of the mouse
[all,mouse] = posCompare(mouseNum);
disp('Running Behavior Data Compiled');

%Play position behavior movie in subplot
analysisFig = figure('units','normalized','outerposition',[0 0.05 1 .95]);
frames(length(mouse)) = struct('cdata',[],'colormap',[]);
positionSub = subplot(1,2,1);
h1 = histogram(positionSub,all,'Normalization','probability','FaceColor','b','EdgeColor','none');
axis tight manual
xlabel('Maze Position');
ylabel('Position Frequency');
hold on
for i=1:length(mouse)
    session = num2str(i);
    titlestring = strcat('Mouse Maze Position for Session #',session);
    h2 = histogram(positionSub,mouse{i,1},'FaceColor',[1 .5 0],'EdgeColor','none','Normalization','probability','BinWidth',h1.BinWidth);
    title(titlestring);
    drawnow
    frames(i) = getframe(analysisFig);
    delete(h2)
end
cla
movie(analysisFig,frames,20)

end