function varargout = plotdata(varargin)
% PLOTDATA MATLAB code for plotdata.fig
% Team 31
% Grigor Ambartsumyan, Nick Jens, Mary Sedarous
%
%      PLOTDATA, by itself, creates a new PLOTDATA or raises the existing
%      singleton*.
%
%      H = PLOTDATA returns the handle to a new PLOTDATA or the handle to
%      the existing singleton*.
%
%      PLOTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTDATA.M with the given input arguments.
%
%      PLOTDATA('Property','Value',...) creates a new PLOTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotdata_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotdata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotdata

% Last Modified by GUIDE v2.5 11-Jun-2013 16:38:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotdata_OpeningFcn, ...
                   'gui_OutputFcn',  @plotdata_OutputFcn, ...
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


% --- Executes just before plotdata is made visible.
function plotdata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotdata (see VARARGIN)

% Choose default command line output for plotdata
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotdata wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotdata_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if and else statements set variables depending on choice
if(get(handles.average,'Value'))
   trial = 0;
elseif(get(handles.morning,'Value'))
   trial = 1;
elseif(get(handles.noon,'Value'))
   trial = 2;
elseif(get(handles.afternoon,'Value'))
   trial = 3;
end
if(get(handles.open_circ,'Value'))
    choice = 1;
elseif(get(handles.max_ppt,'Value'))
    choice = 2;
end

x = [];
y = [];
v = [];

% loads the map and the mat file(data)
load locations.mat locations;

a = imread('campusmap.jpg');
width = size(a,2);
height = size(a,1);
    
num = length(locations);
figure(1);
imshow(a);

hold on;
% x y coords, v voltage
if choice == 1
    if trial == 0 %average
        for i = 1:num
            if(~isempty(locations(i).trials))
            temp = locations(i).trials;
            x = [x locations(i).coordinates(1)];
            y = [y locations(i).coordinates(2)];
            v = [v mean([mean(temp(1).opensweep) mean(temp(2).opensweep) mean(temp(3).opensweep)])];
            end
        end
    else
        for i = 1:num
            if(~isempty(locations(i).trials) & ~isempty(locations(i).trials(trial).opensweep))
            temp = locations(i).trials;
            x = [x locations(i).coordinates(1)];
            y = [y locations(i).coordinates(2)];
            v = [v mean(temp(trial).opensweep)];
            end
        end
    end
else
    if trial == 0 
        for i = 1:num
            if(~isempty(locations(i).trials))
            temp = locations(i).trials;
            x = [x locations(i).coordinates(1)];
            y = [y locations(i).coordinates(2)];
            v = [v mean([mean(temp(1).loadsweep) mean(temp(2).loadsweep) mean(temp(3).loadsweep)])];
            end
        end
    else
        for i = 1:num
            if(~isempty(locations(i).trials) & ~isempty(locations(i).trials(trial).loadsweep))
            temp = locations(i).trials;
            x = [x locations(i).coordinates(1)];
            y = [y locations(i).coordinates(2)];
            v = [v mean(temp(trial).loadsweep)];
            end
        end
    end
end
    

p = 100;

rangex = linspace(1,width,p);
rangey = linspace(1,height,p);

rangex1 = [];
rangey1 = [];

for(i = 1:p)
    for(j = 1:p)
        rangex1 = [rangex1 rangex(i)];
        rangey1 = [rangey1 rangey(j)];
    end
end
%interpolate adds teh missing values betweeen recorded points
z2 = griddata(x,y,v,rangex1,rangey1);
z2 = reshape(z2,p,p);
z2 = z2;
z2 = z2./(max(max(z2))*1.4).*255;

% plots
contour(rangex,rangey,z2,20,'Linewidth',1.5);

%close gui close figure
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
try
    close 1;
end