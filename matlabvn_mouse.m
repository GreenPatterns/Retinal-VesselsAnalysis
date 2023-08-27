function varargout = matlabvn_mouse(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matlabvn_mouse_OpeningFcn, ...
                   'gui_OutputFcn',  @matlabvn_mouse_OutputFcn, ...
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


% --- Executes just before matlabvn_mouse is made visible.
function matlabvn_mouse_OpeningFcn(hObject, eventdata, handles, varargin)

set(hObject,'WindowButtonDownFcn',{@my_MouseClickFcn,hObject});
set(hObject,'WindowButtonUpFcn',{@my_MouseReleaseFcn,hObject});
axes(handles.axes1);
set(handles.axes1,'xlim',[-10 10],'ylim',[-10 10]);
handles.redbox=patch([1, 2, 2, 1, 1],[2, 2, 3, 3, 2], 'r');
% Choose default command line output for matlabvn_mouse
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes matlabvn_mouse wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function my_MouseClickFcn(obj,event,hObject)
handles=guidata(hObject);
set(handles.figure1,'WindowButtonMotionFcn',{@my_MouseMoveFcn,hObject});
guidata(hObject,handles)

function my_MouseReleaseFcn(obj,event,hObject)
handles=guidata(hObject);
set(handles.figure1,'WindowButtonMotionFcn','');

function my_MouseMoveFcn(obj,event,hObject)
handles=guidata(hObject);
mousepos=get(handles.axes1,'CurrentPoint');
x=get(handles.redbox,'xdata');
y=get(handles.redbox,'ydata');
x_rel=x-x(1);
y_rel=y-y(1);
set(handles.redbox,'xdata',mousepos(1,1)+x_rel);
set(handles.redbox,'ydata',mousepos(1,2)+y_rel);


% --- Outputs from this function are returned to the command line.
function varargout = matlabvn_mouse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
