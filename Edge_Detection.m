function varargout = Edge_Detection(varargin)
% EDGE_DETECTION MATLAB code for Edge_Detection.fig
%      EDGE_DETECTION, by itself, creates a new EDGE_DETECTION or raises the existing
%      singleton*.
%
%      H = EDGE_DETECTION returns the handle to a new EDGE_DETECTION or the handle to
%      the existing singleton*.
%
%      EDGE_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDGE_DETECTION.M with the given input arguments.
%
%      EDGE_DETECTION('Property','Value',...) creates a new EDGE_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Edge_Detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Edge_Detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Edge_Detection

% Last Modified by GUIDE v2.5 15-Jun-2019 14:14:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Edge_Detection_OpeningFcn, ...
                   'gui_OutputFcn',  @Edge_Detection_OutputFcn, ...
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


% --- Executes just before Edge_Detection is made visible.
function Edge_Detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Edge_Detection (see VARARGIN)

% Choose default command line output for Edge_Detection
handles.output = hObject;

% Update handles structure
handles.im=[];
handles.imbw=[];
handles.imedge=[];
handles.method='roberts';
guidata(hObject, handles);

% UIWAIT makes Edge_Detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Edge_Detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName]=uigetfile('*.tif','Select an Image File');
if [FileName,PathName]==0
    return
end
handles.im=imread([PathName,FileName]);
if size(handles.im,3)==3
    handles.imbw=rgb2gray(handles.im);
else
    handles.imbw=handles.im;
end
guidata(hObject,handles);
axes(handles.original);
imagesc(handles.im),colormap gray;


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.im=[];
handles.imbw=[];
handles.imedge=[];
cla(handles.original);
cla(handles.edge);
guidata(hObject,handles)


% --- Executes on button press in detect_edge.
function detect_edge_Callback(hObject, eventdata, handles)
% hObject    handle to detect_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.imbw)
    msgbox('Load an image first!','No Image','Error');
    return
end
handles.imbw=double(handles.imbw);
if isequal(handles.method,'compass') || isequal(handles.method,'kirsch') || isequal(handles.method,'cendif') || isequal(handles.method,'isotropic')
    if isequal(handles.method,'cendif') || isequal(handles.method,'isotropic')
        switch handles.method
            case 'cendif'
                d1=[-1,0,1];
                d2=[-1;0;1];
            case 'isotropic'
                d1=[-1 0 1;-sqrt(2) 0 sqrt(2);-1 0 1];
                d2=[-1 -sqrt(2) -1;0 0 0;1 sqrt(2) 1];
        end
        I1=conv2(handles.imbw,d1,'same');
        I2=conv2(handles.imbw,d2,'same');
        handles.imedge=sqrt((I1.^2)+(I2.^2));
    else if isequal(handles.method,'compass')
            d1=[1,1,1;1,-2,1;-1,-1,-1];
            d2=[-1,-1,-1;1,-2,1;1,1,1];
            d3=[-1,1,1;-1,-2,1;-1,1,1];
            d4=[1,1,-1;1,-2,-1;1,1,-1];
            I1=conv2(handles.imbw,d1,'same');
            I2=conv2(handles.imbw,d2,'same');
            I3=conv2(handles.imbw,d3,'same');
            I4=conv2(handles.imbw,d4,'same');
            handles.imedge=sqrt((I1.^2)+(I2.^2)+(I3.^2)+(I4.^2));
        else if isequal(handles.method,'kirsch')
                d1=[-3,-3,5;-3,0,5;-3,-3,5];
                d2=[-3,5,5;-3,0,5;-3,-3,-3];
                d3=[5,5,5;-3,0,-3;-3,-3,-3];
                d4=[5,5,-3;5,0,-3;-3,-3,-3];
                d5=[5,-3,-3;5,0,-3;5,-3,-3];
                d6=[-3,-3,-3;5,0,-3;5,5,-3];
                d7=[-3,-3,-3;-3,0,-3;5,5,5];
                d8=[-3,-3,-3;-3,0,5;-3,5,5];
                I1=conv2(handles.imbw,d1,'same');
                I2=conv2(handles.imbw,d2,'same');
                I3=conv2(handles.imbw,d3,'same');
                I4=conv2(handles.imbw,d4,'same');
                I5=conv2(handles.imbw,d5,'same');
                I6=conv2(handles.imbw,d6,'same');
                I7=conv2(handles.imbw,d7,'same');
                I8=conv2(handles.imbw,d8,'same');
                handles.imedge=sqrt((I1.^2)+(I2.^2)+(I3.^2)+(I4.^2)+(I5.^2)+(I6.^2)+(I7.^2)+(I8.^2));
            end
        end
    end
else
    handles.imedge=edge(handles.imbw,handles.method);
end
guidata(hObject,handles);
axes(handles.edge);
imagesc(handles.imedge),colormap gray;


% --- Executes when selected object is changed in det_method.
function det_method_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in det_method 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.method = get(eventdata.NewValue,'Tag');
guidata(hObject,handles);
