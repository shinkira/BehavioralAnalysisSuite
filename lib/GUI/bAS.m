function [guiObjects] = bAS(guiObjects,silent,userFile,varargin)
%bAS.m function to create the GUI for new cell processing

%get userData
origDir = cd([guiObjects.rootPath,'User Processing']);
if silent
    guiObjects.userData = readUserData(userFile);
else
    fileList = dir('*.txt');
    [filenames] = uigetfile({'*.txt','Text Files'},'Please select user configuration file',fileList(1).name);
    if filenames == 0
        cd(origDir);
        return;
    end
    guiObjects.userData = readUserData(filenames);
end
cd(origDir);

screens = get(0,'MonitorPositions');
if size(screens,1) > 1
    scrn = screens(1,:);
    % scrn = screens(2,:);
else
    scrn = screens(1,:);
end

button_height = 0.58; % 0.605

guiObjects.figHandle = figure('Name','Behavioral Analysis Suite v1.0','NumberTitle','Off','MenuBar','none');
switch getComputerName
    case {'shin-cp','shin-pc'}
        set(guiObjects.figHandle,'OuterPosition',[scrn(1), scrn(2), 0.7*scrn(3), 0.75*scrn(4)]);
        % set(guiObjects.figHandle,'OuterPosition',[scrn(1)+0.3*scrn(3) scrn(2) 0.7*scrn(3) 0.75*scrn(4)]);
        tableFontSize = 12;
    otherwise
        set(guiObjects.figHandle,'OuterPosition',[scrn(1) scrn(2) scrn(3) 0.75*scrn(4)]);
        tableFontSize = 11;
end
guiObjects.table = uitable('FontName','Arial','FontSize',tableFontSize,'RowStriping','on','BackgroundColor',...
    [1 1 1; 0.8 0.8 0.8],'Units','normalized','Position',[0 .32 1 .28]); % [0 .32 1 .28]

%create start live acquisition button
guiObjects.startStop = uicontrol('FontName','Arial','FontSize',13,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.55 0.97 0.05 0.02],...
    'String','Start','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);

%create open files button
guiObjects.openRecent = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.025 .11 .2 .03],...
    'String','Open Most Recent','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
guiObjects.openSelected = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.025 .07 .2 .03],...
    'String','Open Specific Files','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969]);
guiObjects.add = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.025 .11 .2 .03],...
    'String','Add Files','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'visible','off','enable','off');
guiObjects.replace = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.025 .07 .2 .03],...
    'String','Open New','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'visible','off','enable','off');

%create export data button
guiObjects.export = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.025 .03 .2 .03],...
    'String','Export Data','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'visible','on','enable','off');

%create listbox for modules
guiObjects.modData = uicontrol('FontName','Arial','FontSize',11,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.25 .07 .16 .11],...
    'Style','listbox','BackgroundColor',[1 1 1],'String',{'All Data'},...
    'HorizontalAlignment','Center','enable','off');

[guiObjects.modCallbacks,guiObjects.modNames] =...
    getModules([guiObjects.rootPath,'Modules']);
guiObjects.moduleList = uicontrol('FontName','Arial','FontSize',11,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.42 .07 .16 .11],...
    'Style','listbox','BackgroundColor',[1 1 1],'String',guiObjects.modNames,...
    'HorizontalAlignment','Center','enable','off');

%create run module button
guiObjects.runModule = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.25 .03 .33 .03],...
    'String','Run Module','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'enable','off');

%create sliding window display listbox and legend check
guiObjects.winDisp = uicontrol('FontName','Arial','FontSize',11,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.83 .05 .16 .13],...
    'Style','listbox','BackgroundColor',[1 1 1],'String',{'Correct','Trials'},...
    'HorizontalAlignment','Center','enable','off','Max',5,'Min',1,'Value',[1 2]);
guiObjects.legendCheck = uicontrol('FontName','Arial','FontSize',12,'BackgroundColor',...
    [0.7969 0.7969 0.7969],'Units','Normalized','Style','checkbox','String','Legend',...
    'enable','off','Position',[.87 .025 .16 .015],'Value',1);

%set text entry for lastX, winSize, updateInt and total sessionTime
uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold','ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.6 0.025 0.12 0.04],'String','Update Interval (s): ',...
    'Style','text','BackgroundColor',[0.7969 0.7969 0.7969],'HorizontalAlignment','Center');
guiObjects.updateInt = uicontrol('FontName','Arial','FontSize',13,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.72 0.03 0.09 0.03],...
    'String','5','Style','edit','enable','off');

uicontrol('FontName','Arial','FontSize',13,'FontWeight','bold','ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.6 0.075 0.12 0.02],'String','LastX: ',...
    'Style','text','BackgroundColor',[0.7969 0.7969 0.7969],'HorizontalAlignment','Center');
guiObjects.lastX = uicontrol('FontName','Arial','FontSize',13,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.72 0.07 0.09 0.03],...
    'String','40','Style','edit','enable','off');

guiObjects.sessionText = uicontrol('FontName','Arial','FontSize',13,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.6 0.115 0.12 0.02],...
    'String','Session Time: ','Style','text','BackgroundColor',[0.7969 0.7969 0.7969],...
    'HorizontalAlignment','Center');
guiObjects.sessionTime = uicontrol('FontName','Arial','FontSize',13,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.72 0.11 0.09 0.03],...
    'String','00:45:00','Style','edit','enable','off');

uicontrol('FontName','Arial','FontSize',13,'FontWeight','bold','ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.6 0.155 0.12 0.02],'String','Window Size: ',...
    'Style','text','BackgroundColor',[0.7969 0.7969 0.7969],'HorizontalAlignment','Center');
guiObjects.winSize = uicontrol('FontName','Arial','FontSize',13,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.72 0.15 0.09 0.03],...
    'String','5','Style','edit','BackgroundColor',[1 1 1]);

guiObjects.winText = uicontrol('FontName','Arial','FontSize',20,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.1 0.775 0.8 0.05],...
    'String','Window Has Not Yet Elapsed','Style','text','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Visible','off');
guiObjects.calcText = uicontrol('FontName','Arial','FontSize',20,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.1 0.775 0.8 0.05],...
    'String','Calculating...','Style','text','visible','off');

%Create condition display
guiObjects.condDisp(1) = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.65 button_height 0.2 0.02],...
    'String','Condition: ','Style','text','BackgroundColor',[0.7969 0.7969 0.7969],...
    'HorizontalAlignment','Left','visible','off');
guiObjects.condDisp(2) = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[0.77 button_height 0.3 0.02],...
    'String','','Style','text','BackgroundColor',[0.7969 0.7969 0.7969],...
    'HorizontalAlignment','Left');

%create table listbox
tableStrings = {'Special','General','Conditions','Timing'};
guiObjects.tableList = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','Position',[.025 .19 .125 .1],...
    'Style','listbox','BackgroundColor',[1 1 1],...
    'String',tableStrings,'Max',length(tableStrings),'Min',1,'Value',[1 2]);

%create condition option checks
guiObjects.condCheck(1) = uicontrol('Units','Normalized',...
    'Position',[0.16 0.275 0.02 0.01],'style','checkbox',...
    'BackgroundColor',[0.7969 0.7969 0.7969],'Value',0,'enable','off');
guiObjects.condCheck(2) = uicontrol('Units','Normalized',...
    'Position',[0.16 0.2483 0.02 0.01],'style','checkbox',...
    'BackgroundColor',[0.7969 0.7969 0.7969],'Value',0,'enable','off');
guiObjects.condCheck(3) = uicontrol('Units','Normalized',...
    'Position',[0.16 0.2217 0.02 0.01],'style','checkbox',...
    'BackgroundColor',[0.7969 0.7969 0.7969],'Value',0,'enable','off');
guiObjects.condCheck(4) = uicontrol('Units','Normalized',...
    'Position',[0.16 0.195 0.02 0.01],'style','checkbox',...
    'BackgroundColor',[0.7969 0.7969 0.7969],'Value',0,'enable','off');

%create condRange
guiObjects.condRange(1) = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[1 1 1],...
    'Position',[0.19 0.27 0.1 0.02],'String',':','Style','edit',...
    'enable','off');
guiObjects.condText(1) = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[1 1 1],...
    'Position',[0.3 0.27 0.65 0.02],'String','Enter Condition Text Here','Style','edit',...
    'enable','off');

guiObjects.condRange(2) = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[1 1 1],...
    'Position',[0.19 0.2433 0.1 0.02],'String',':','Style','edit',...
    'enable','off');
guiObjects.condText(2) = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[1 1 1],...
    'Position',[0.3 0.2433 0.65 0.02],'String','Enter Condition Text Here','Style','edit',...
    'enable','off');

guiObjects.condRange(3) = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[1 1 1],...
    'Position',[0.19 0.2167 0.1 0.02],'String',':','Style','edit',...
    'enable','off');
guiObjects.condText(3) = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[1 1 1],...
    'Position',[0.3 0.2167 0.65 0.02],'String','Enter Condition Text Here','Style','edit',...
    'enable','off');

guiObjects.condRange(4) = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[1 1 1],...
    'Position',[0.19 0.19 0.1 0.02],'String',':','Style','edit',...
    'enable','off');
guiObjects.condText(4) = uicontrol('FontName','Arial','FontSize',12,'FontWeight','bold',...
    'ForegroundColor',[0 0 0],'Units','Normalized','BackgroundColor',[1 1 1],...
    'Position',[0.3 0.19 0.65 0.02],'String','Enter Condition Text Here','Style','edit',...
    'enable','off');

%set up date browser
guiObjects.datePopup = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.74 0.97 0.2 0.02],'String','Date',...
    'Style','popupmenu','enable','off');
guiObjects.dateButtonRight = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.95 0.967 0.02 0.023],'String','>','Style','pushbutton',...
    'BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@changeDate,guiObjects,1,1},'enable','off');
guiObjects.dateButtonLeft = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.71 0.967 0.02 0.023],'String','<','Style','pushbutton',...
    'BackgroundColor',[0.7969 0.7969 0.7969],'Callback',{@changeDate,guiObjects,0,1},'enable','off');

%set up animal browser
guiObjects.animalPopup = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.22 0.97 0.09 0.02],'String','Animal',...
    'Style','popupmenu','enable','off');
guiObjects.animalButtonRight = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.32 0.967 0.02 0.023],'String','>',...
    'Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@changeAnimal,guiObjects,1,1},'enable','off');
guiObjects.animalButtonLeft = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.19 0.967 0.02 0.023],'String','<','Style','pushbutton',...
    'BackgroundColor',[0.7969 0.7969 0.7969],...
    'Callback',{@changeAnimal,guiObjects,0,1},'enable','off');
guiObjects.mouseToggle = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.03 0.967 0.14 0.023],'String',guiObjects.userData.folders{1},...
    'Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],'enable','off');

%set up structure display 
[A,~,~]=imread('Structure.png');
A(A==255) = 203.2095; %set background to grey
guiObjects.structureDisplay = uicontrol('ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[0.955 0.2516 0.04 0.03],'Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'cdata',A,'enable','off');

%set up maze key
[A,~,~]=imread('Maze Key.png');
A(A==255) = 203.2095; %set background to grey
guiObjects.mazeKey = uicontrol('ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[0.955 0.1983 0.04 0.03],'Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'cdata',A);

%create zoom buttons
[Zoom_In,~,~]=imread('Zoom_In_Small.png');
[HandPan,~,~]=imread('HandPan.png');
Zoom_In(Zoom_In==255) = 203.2095;
HandPan(HandPan==255) = 203.2095;
guiObjects.zoomButton = uicontrol('ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[0.56 button_height 0.03 0.0225],'Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'cdata',Zoom_In,'enable','off');
guiObjects.panButton = uicontrol('ForegroundColor',[0 0 0],'Units','Normalized',...
    'Position',[0.6 button_height 0.03 0.0225],'Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
    'cdata',HandPan,'enable','off');

%create clear button and supress warnings check
guiObjects.clear = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.19 0.2967 0.1 0.02],'String','Clear',...
    'Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],'enable','off');

guiObjects.suppressWarn = uicontrol('FontName','Arial','FontSize',12,'BackgroundColor',...
    [0.7969 0.7969 0.7969],'Units','Normalized','Style','checkbox','String','Suppress Warnings',...
    'enable','off','Position',[.3 .2985 .25 .015],'Value',0);

%create print button to save the figure
guiObjects.print = uicontrol('FontName','Arial','FontSize',13,'ForegroundColor',[0 0 0],...
    'Units','Normalized','Position',[0.65 0.97 0.05 0.02],'String','Print',...
    'Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],'enable','on');

%set callbacks
set(guiObjects.openRecent,'Callback',{@openRecent_CALLBACK,guiObjects}); %set callback with silent flag as 0
set(guiObjects.openSelected,'Callback',{@openCellFiles_CALLBACK,guiObjects,false}); %set callback with silent flag as 0
set(guiObjects.replace,'Callback',{@openCellFiles_CALLBACK,guiObjects,false});
set(guiObjects.mazeKey,'Callback',{@mazeKey_CALLBACK,guiObjects});
set(guiObjects.startStop,'Callback',{@startStopOnline_CALLBACK,guiObjects});
set(guiObjects.updateInt,'Callback',{@updateInt_CALLBACK,guiObjects});
set(guiObjects.figHandle,'CloseRequestFcn',{@closeGUI_CALLBACK,guiObjects});
set(guiObjects.clear,'Callback',{@resetCondFields_CALLBACK,guiObjects});
set(guiObjects.print,'Callback',{@print_CALLBACK,guiObjects});

%process varargin
varargin = varargin{1};
if isodd(length(varargin)) %check for odd varargin
    error('Must have even number of variable input arguments. Please list value following modifier');
end

batch_flag = false;
fileToLoad = [];
for i=1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Arugment specifier must be a string. Please check vararg: ',num2str(i)]);
    end
    
    switch upper(varargin{i})
        case 'SUPPRESSWARNINGS'
            set(guiObjects.suppressWarn,'Value',varargin{i+1});
        case 'WINDOWSIZE'
            set(guiObjects.winSize,'String',num2str(varargin{i+1}));
        case 'SESSIONTIME'
            set(guiObjects.sessionTime,'String',varargin{i+1});
        case 'LASTX'
            set(guiObjects.lastX,'String',num2str(varargin{i+1}));
        case 'UPDATEINTERVAL'
            set(guiObjects.updateInt,'String',num2str(varargin{i+1}));
        case 'BATCH_FLAG'
            guiObjects.batch_flag = varargin{i+1};
            batch_flag = true;
        case 'FILETOLOAD'
            fileToLoad = varargin{i+1};
    end
end

% update the initials based on the mouse ID 17/01/10
initials_ind = strfind(fileToLoad,'Current Mice')+length('Current Mice\');
guiObjects.userData.initials = fileToLoad(initials_ind:initials_ind+1);

% save guiObjects
set(guiObjects.figHandle,'UserData',guiObjects);

% batch mode
if batch_flag
    callbackCell = get(guiObjects.openSelected,'Callback');
    callbackCell{1}(guiObjects.openSelected,[],callbackCell{2},true,fileToLoad)
end

end