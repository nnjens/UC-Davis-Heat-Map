function varargout = survey(varargin)
% SURVEY MATLAB code for survey.fig
% Team 31
% Grigor Ambartsumyan, Nick Jens, Mary Sedarous
%
%      SURVEY, by itself, creates a new SURVEY or raises the existing
%      singleton*.
%
%      H = SURVEY returns the handle to a new SURVEY or the handle to
%      the existing singleton*.
%
%      SURVEY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SURVEY.M with the given input arguments.
%
%      SURVEY('Property','Value',...) creates a new SURVEY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before survey_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to survey_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help survey

% Last Modified by GUIDE v2.5 12-Jun-2013 01:57:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @survey_OpeningFcn, ...
                   'gui_OutputFcn',  @survey_OutputFcn, ...
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


% --- Executes just before survey is made visible.
function survey_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to survey (see VARARGIN)

% Choose default command line output for survey
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes survey wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = survey_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
locations = openfile();  % Loads the existing locations
len = length(locations);
if(len ~= 0)
for i = 1:len  
  list{i} = locations(i).name; % Gets each of the names of the locations
end
list{len+1} = 'New';
set(hObject,'String',list); % Sets the string on the listbox to the names   
end
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in menu.
function menu_Callback(hObject, eventdata, handles)
l = size(get(handles.menu,'String'),1);
if(get(handles.menu,'Value') == l) % If "New" is selected
    set(handles.newtext,'Style','Edit');  % Hide parts of GUI when New is selected
    set(handles.newtext,'BackgroundColor','White');
    set(handles.newtext,'String','Enter name for new location');
    set(handles.t1, 'BackgroundColor', [.9412 .9412 .9412]);
    set(handles.t2, 'BackgroundColor', [.9412 .9412 .9412]);
    set(handles.t3, 'BackgroundColor', [.9412 .9412 .9412]);
    set(handles.newbutton, 'Visible', 'on')
    set(handles.del, 'Visible', 'off');
    set(handles.uipanel3, 'Visible', 'off');
    set(handles.uipanel4, 'Visible', 'off');
    set(handles.timeanddate, 'Visible', 'off');
else % If an existing location is selected
    set(handles.del,'Visible','on');    % Unhide the rest of the GUI when a location is selected
    set(handles.uipanel3, 'Visible', 'on');
    set(handles.uipanel4, 'Visible', 'on');
    set(handles.newtext,'Style','Text');
    set(handles.newtext,'BackgroundColor',  [.9412 .9412 .9412]);
    set(handles.newtext,'String', 'Select "New" above to add a new Location');
    set(handles.newbutton, 'Visible', 'off')
    set(handles.timeanddate, 'Visible', 'on');
    checkstatus(handles);
end
% hObject    handle to menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu


% --- Executes on button press in del.
function del_Callback(hObject, eventdata, handles)
list = get(handles.menu,'String');
num = get(handles.menu,'Value');
l = length(list);
if(num ~= l) % If New is not selected
locations = openfile();
locations(num) = [];   % Deletes the selected location
save locations.mat locations;
len = length(locations);
list = [];
for i = 1:len
  list{i} = locations(i).name;  % updates the listbox
end
list{len+1} = 'New';
set(handles.menu,'Value',1);
set(handles.menu,'String',list);
menu_Callback(hObject, eventdata, handles)
end

% hObject    handle to del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in newbutton.
function newbutton_Callback(hObject, eventdata, handles)
try
    locations = openfile();
    picture = imread('campusmap.jpg');  
    figure(1);
    imshow(picture);   % Show the map
    hold on;
    num = size(locations,2);
    for i = 1:num       % Show each existing location with a green circle
        p = locations(i).coordinates;
        plot(p(1),p(2),'ro','MarkerFaceColor','g','Markersize',15);
        text(p(1)+35,p(2),locations(i).name,'BackgroundColor','white');
    end
    legend('Existing Locations');
    locations(num+1).coordinates = ginput(1);   % Get coordinates
    close 1;

    name = get(handles.newtext, 'String');    % Get the name from the text box
    locations(num+1).name = name;           % Add it to the locations file
    save locations.mat locations;           % save locations file
    
    set(handles.del,'Visible','on');   
    set(handles.newbutton,'Visible','off');
    len = length(locations);
    list = [];
    for i = 1:len
      list{i} = locations(i).name;
    end
    list{len+1} = 'New';
    set(handles.menu,'String',list);
    set(handles.menu,'Value',len);
    set(handles.newtext,'String','Select "New" above to add a new Location');
    set(handles.newtext,'Style','Text');
    set(handles.newtext,'BackgroundColor',  [.9412 .9412 .9412]);
    set(handles.uipanel3, 'Visible', 'on');
    set(handles.uipanel4, 'Visible', 'on');
    menu_Callback(hObject, eventdata, handles);
end
% hObject    handle to newbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function checkstatus(handles)
    locations = openfile();
    trials = locations(get(handles.menu,'Value')).trials;
    num = length(trials);
    
    if(num >= 1 & ~isempty(trials(1).opensweep) & ~isempty(trials(1).loadsweep)) % If trial 1 is completed
        set(handles.t1, 'BackgroundColor', 'Green');
    else
        set(handles.t1, 'BackgroundColor', [.9412 .9412 .9412]);
    end
    if(num >= 2 & ~isempty(trials(2).opensweep) & ~isempty(trials(2).loadsweep)) % If trial 2 is completed
        set(handles.t2, 'BackgroundColor', 'Green');
    else
        set(handles.t2, 'BackgroundColor', [.9412 .9412 .9412]);
    end
    if(num >= 3 & ~isempty(trials(3).opensweep) & ~isempty(trials(3).loadsweep)) % If trial 3 is completed
        set(handles.t3, 'BackgroundColor', 'Green');
    else
        set(handles.t3, 'BackgroundColor', [.9412 .9412 .9412]);
    end
    tr = get(handles.t1,'Value') + get(handles.t2,'Value')*2 + get(handles.t3,'Value')*3; % selected trial
    if(num >= tr & ~isempty(locations(get(handles.menu,'Value')).trials(tr).opensweep))
        set(handles.statusopen,'String','Completed!');
        set(handles.statusopen,'BackgroundColor','Green');
    else
        set(handles.statusopen,'BackgroundColor',  [.9412 .9412 .9412]);
        set(handles.statusopen,'String', 'Status: Not Started');
    end
    if(num >= tr & ~isempty(locations(get(handles.menu,'Value')).trials(tr).loadsweep))
        set(handles.statusload,'String','Completed!');
        set(handles.statusload,'BackgroundColor','Green');
    else
        set(handles.statusload,'BackgroundColor',  [.9412 .9412 .9412]);
        set(handles.statusload,'String', 'Status: Not Started');
    end


% --- Executes on button press in startload.
function startload_Callback(hObject, eventdata, handles)
set(handles.statusload,'String','Connecting');
port = get(handles.comport,'String');
try
    ard_obj = arduino(port);
    set(handles.statusload,'BackgroundColor', [.9412 .9412 .9412]);
    loadsweep = zeros(256,1);
    ard_obj.pWrite(1,128);
    pause(0.1);
    for(i = 0:255)
        ard_obj.pWrite(0,i);
        value = ard_obj.analogRead(0);
        voltage = value * 5/1024;
        loadsweep(i+1) = voltage;
        pause(0.1);
        percent = floor(i/255*100);
        percent = [num2str(percent) '%'];
        set(handles.statusload,'String',percent);
    end
    delete(ard_obj);
    loc = get(handles.menu,'Value');

    if(get(handles.t1,'Value'))
        tr = 1;
    elseif(get(handles.t2,'Value'))
        tr = 2;
    elseif(get(handles.t3,'Value'))
        tr = 3;
    end
    locations = openfile();
    locations(loc).trials(tr).loadsweep = loadsweep;
    locations(loc).trials(tr).time = get(handles.td,'String');
    save locations.mat locations;
    set(handles.statusload,'String','Status: Success!');
    set(handles.statusload,'BackgroundColor','Green');
catch
    set(handles.statusload,'String',['Could not open port: ' port]);
    set(handles.statusload,'BackgroundColor', 'red');
end
checkstatus(handles);

% hObject    handle to startload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in startopen.
function startopen_Callback(hObject, eventdata, handles)
set(handles.statusopen,'String','Connecting');
port = get(handles.comport,'String');
try
    ard_obj = arduino(port);
    set(handles.statusopen,'BackgroundColor', [.9412 .9412 .9412]);
    opensweep = zeros(256,1);
    ard_obj.pWrite(-1,255);
    for(i = 0:255)
        value = ard_obj.analogRead(0);
        voltage = value * 5/1024;
        opensweep(i+1) = voltage;
        pause(0.1);
        percent = floor(i/255*100);
        percent = [num2str(percent) '%'];
        set(handles.statusopen,'String',percent);
    end

    delete(ard_obj);

    loc = get(handles.menu,'Value');

    if(get(handles.t1,'Value'))
        tr = 1;
    elseif(get(handles.t2,'Value'))
        tr = 2;
    elseif(get(handles.t3,'Value'))
        tr = 3;
    end
    locations = openfile();
    locations(loc).trials(tr).opensweep = opensweep;
    locations(loc).trials(tr).time = get(handles.td,'String');
    save locations.mat locations;
    set(handles.statusopen,'String','Status: Success!');
    set(handles.statusopen,'BackgroundColor','Green');
catch
    set(handles.statusopen,'String',['Could not open port: ' port]);
    set(handles.statusopen,'BackgroundColor', 'red');
end
checkstatus(handles);

% hObject    handle to startopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function newbutton_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len == 0) % If there are existing locations, disable the new button
    set(hObject,'Visible','on');
else  
    set(hObject,'Visible','off');
end
% hObject    handle to newbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uipanel3.
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
locations = openfile();
num = length(locations(get(handles.menu,'Value')).trials);
tr = get(handles.t1,'Value') + get(handles.t2,'Value')*2 + get(handles.t3,'Value')*3; % selected trial
if(num~=0)
    if(num>=tr & ~isempty(locations(get(handles.menu,'Value')).trials(tr).opensweep))
        set(handles.statusopen,'String','Completed!');
        set(handles.statusopen,'BackgroundColor','Green');
    else
        set(handles.statusopen,'BackgroundColor',  [.9412 .9412 .9412]);
        set(handles.statusopen,'String', 'Status: Not Started');
    end
    if(num>=tr & ~isempty(locations(get(handles.menu,'Value')).trials(tr).loadsweep))
        set(handles.statusload,'String','Completed!');
        set(handles.statusload,'BackgroundColor','Green');
    else
        set(handles.statusload,'BackgroundColor',  [.9412 .9412 .9412]);
        set(handles.statusload,'String', 'Status: Not Started');
    end
end
checkstatus(handles);
% hObject    handle to the selected object in uipanel3 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function t1_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len ~= 0)
    trials = locations(1).trials;
    num = length(trials);
    if(num >= 1 & ~isempty(trials(1).opensweep) & ~isempty(trials(1).loadsweep)) % If trial 1 is completed
        set(hObject, 'BackgroundColor', 'Green');
    else
        set(hObject, 'BackgroundColor', [.9412 .9412 .9412]);
    end
end
% hObject    handle to t1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function t2_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len ~= 0)
    trials = locations(1).trials;
    num = length(trials);
    if(num >= 2 & ~isempty(trials(2).opensweep) & ~isempty(trials(2).loadsweep)) % If trial 2 is completed
        set(hObject, 'BackgroundColor', 'Green');
    else
        set(hObject, 'BackgroundColor', [.9412 .9412 .9412]);
    end
end
% hObject    handle to t2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function t3_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len ~= 0)
    trials = locations(1).trials;
    num = length(trials);
    if(num >= 3 & ~isempty(trials(3).opensweep) & ~isempty(trials(3).loadsweep)) % If trial 3 is completed
        set(hObject, 'BackgroundColor', 'Green');
    else
        set(hObject, 'BackgroundColor', [.9412 .9412 .9412]);
    end
end
% hObject    handle to t3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function statusload_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len ~= 0)
    if(~isempty(locations(1).trials) & ~isempty(locations(1).trials(1).loadsweep))
        set(hObject,'String','Completed!');
        set(hObject,'BackgroundColor','Green');
    else
        set(hObject,'BackgroundColor',  [.9412 .9412 .9412]);
        set(hObject,'String', 'Status: Not Started');
    end
end
% hObject    handle to statusload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function statusopen_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len ~= 0)
    if(~isempty(locations(1).trials) & ~isempty(locations(1).trials(1).opensweep))
        set(hObject,'String','Completed!');
        set(hObject,'BackgroundColor','Green');
    else
        set(hObject,'BackgroundColor',  [.9412 .9412 .9412]);
        set(hObject,'String', 'Status: Not Started');
    end
end
% hObject    handle to statusopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len == 0)
    set(hObject,'Visible','off');
end
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel4_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len == 0)
    set(hObject,'Visible','off');
end
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function del_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len == 0)
    set(hObject,'Visible','off');
end
% hObject    handle to del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function newtext_CreateFcn(hObject, eventdata, handles)
locations = openfile();
len = length(locations);
if(len == 0)
    set(hObject,'Style','Edit');
    set(hObject,'BackgroundColor','White');
    set(hObject,'String','Enter name for new location');
end
% hObject    handle to newtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function output = openfile()
try
    load locations.mat locations;
    output = locations;
catch
    output = [];
    output.name = [];
    output.coordinates = [];
    output.trials = [];
    output(1) = [];
end


% --- Executes during object creation, after setting all properties.
function timeanddate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeanddate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function td_Callback(hObject, eventdata, handles)
% hObject    handle to td (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of td as text
%        str2double(get(hObject,'String')) returns contents of td as a double


% --- Executes during object creation, after setting all properties.
function td_CreateFcn(hObject, eventdata, handles)
% hObject    handle to td (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function comport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newtext_Callback(hObject, eventdata, handles)
% hObject    handle to newtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newtext as text
%        str2double(get(hObject,'String')) returns contents of newtext as a double
