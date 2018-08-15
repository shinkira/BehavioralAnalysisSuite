function varargout = reviewMiceBe(varargin)
%reviewMiceBe is a GUI that allows efficient review of each mouse being
%trained
%Ted Lutkus 7/17/2017
% REVIEWMICEBE MATLAB code for reviewMiceBe.fig
%      REVIEWMICEBE, by itself, creates a new REVIEWMICEBE or raises the existing
%      singleton*.
%
%      H = REVIEWMICEBE returns the handle to a new REVIEWMICEBE or the handle to
%      the existing singleton*.
%
%      REVIEWMICEBE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REVIEWMICEBE.M with the given input arguments.
%
%      REVIEWMICEBE('Property','Value',...) creates a new REVIEWMICEBE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reviewMiceBe_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reviewMiceBe_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reviewMiceBe

% Last Modified by GUIDE v2.5 24-Aug-2017 09:33:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reviewMiceBe_OpeningFcn, ...
                   'gui_OutputFcn',  @reviewMiceBe_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before reviewMiceBe is made visible.
function reviewMiceBe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reviewMiceBe (see VARARGIN)

% Choose default command line output for reviewMiceBe
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(gcf,'units','normalized','outerposition',[0 0.02 0.97 .97])

% UIWAIT makes reviewMiceBe wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);


% --- Outputs from this function are returned to the command line.
function varargout = reviewMiceBe_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set('units','normalized','outerposition',[-1 0.05 2 .95])


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in mouseNumPopup.
function mouseNumPopup_Callback(hObject, eventdata, handles)
% hObject    handle to mouseNumPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mouseNumPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mouseNumPopup
mice = get(hObject,'String');
mouseIndex = get(hObject,'Value');
mouseNum = mice{mouseIndex};
basCrop = pastDaysBe(mouseNum);
subplot('position',[0 .5 .5 .5])
imshow(basCrop{1,1});
subplot('position',[0 0 .5 .5])
imshow(basCrop{2,1});
subplot('position',[.5 .5 .5 .5])
imshow(basCrop{3,1});
subplot('position',[.5 0 .5 .5])
imshow(basCrop{4,1});
set(gcf,'units','normalized','outerposition',[0 0.02 0.97 .97])
% set(gcf,'units','normalized','outerposition',[-1 0.03 2 .97])


% --- Executes during object creation, after setting all properties.
function mouseNumPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouseNumPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'47';'51';'55';'58';'59';'60';'61';'62';'63';'64';'65';'66';'67';'68';'69';'70'});


% --- Executes when mainFigure is resized.
function mainFigure_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in runningAnalysis.
function runningAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to runningAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mice = get(handles.mouseNumPopup,'String');
mouseIndex = get(handles.mouseNumPopup,'Value');
mouseNum = mice{mouseIndex};
setappdata(0,'mouseNum',mouseNum);
positionAnalysisGUI


% --- Executes on button press in biasAnalysis.
function biasAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to biasAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mice = get(handles.mouseNumPopup,'String');
mouseIndex = get(handles.mouseNumPopup,'Value');
mouseNum = mice{mouseIndex};
checkBias(mouseNum);
