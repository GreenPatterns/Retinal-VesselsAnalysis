function varargout = Make_GT(varargin)

%Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Make_GT_OpeningFcn, ...
                   'gui_OutputFcn',  @Make_GT_OutputFcn, ...
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

% ON OPENING FUNCTION
function Make_GT_OpeningFcn(hObject, ~, handles, varargin)

set(hObject,'WindowButtonDownFcn',{@my_MouseClickFcn,hObject});
set(hObject,'WindowButtonUpFcn',{@my_MouseReleaseFcn,hObject});
axes(handles.axesImage);
set(handles.axesImage,'HitTest','off')

global ground_truth;
global region_props;
global bw_image;
global vesselSegLabel;
global vesselSegLabelsList;

region_props = [];
bw_image = [];
vesselSegLabel=[];
ground_truth = [];
vesselSegLabelsList = [];

handles.output = hObject;
guidata(hObject, handles);

%% Mouse Clicked Fucntion
function my_MouseClickFcn(~,~,hObject)
global region_props;
global vesselSegLabel;
global vesselSegLabelsList;
global bw_image;

e = region_props.Centroid;

handles=guidata(hObject);
mousepos=get(handles.axesImage,'CurrentPoint');
curpnt = unique(round(mousepos), 'rows', 'stable');
x = curpnt(1,1);
y = curpnt(1,2);

for i=1:height(region_props)
    obj = region_props.PixelList{i};
    [rows,~] = size(obj);
    for row=1:rows
        if((obj(row,1)==x)&&(obj(row,2)==y))
            vesselSegLabel = i;
            vesselSegLabelsList = [vesselSegLabelsList;vesselSegLabel];
            
            %coloring and labeling selected obj(s)
            axes(handles.axesImage);
            imshow(bw_image);
            hold on
            for j=1:length(vesselSegLabelsList)
                objIndex = region_props.PixelList{vesselSegLabelsList(j)};
                plot(objIndex(:,1),objIndex(:,2),'y.');
            end
            for elem = 1:length(e)
                text(e(elem,1), e(elem,2), sprintf('%d', elem),'Color', 'g');
            end
            hold off
            % End of coloring and labeling
            
            break;
        end
    end
end

function my_MouseReleaseFcn(~,~,hObject)
handles=guidata(hObject);
set(handles.figure1,'WindowButtonMotionFcn','');

function varargout = Make_GT_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function loadimg_Callback(~, ~, handles)

global ground_truth;
global region_props;
global bw_image;
global vesselSegLabel;
global vesselSegLabelsList;

region_props = [];
bw_image = [];
vesselSegLabel=[];
ground_truth = [];
vesselSegLabelsList = [];

[filename, pathname, ~] = uigetfile( ...
{ '*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';...
  '*.*','All Files' },'LoadFile',...
   'D:\projects\A-V classification\Datasets\CHASEDB1_Groundtruth\Second Observer');

file = fullfile(pathname,filename);
disp(file);
bw_image = imread(file);
axes(handles.axesImage);
imshow(bw_image);

function AssignLabels_Callback(~, ~, handles)

global bw_image;
global region_props;

[lbl,~] = bwlabel(bw_image);
region_props = regionprops('Table',lbl,'PixelList','Centroid');
e = region_props.Centroid;

axes(handles.axesImage);
imshow(bw_image);
hold on
for elem = 1:length(e)
   text(e(elem,1), e(elem,2), sprintf('%d', elem), 'Color', 'g')
end
hold off

function GT_ADD_Callback(~, ~, handles)
AVflag = str2double(get(handles.label,'String'));

global ground_truth;
global region_props;
global vesselSegLabelsList;
global bw_image;

if((AVflag==1)&&(~isempty(vesselSegLabelsList)))
    one = ones(length(vesselSegLabelsList),1);
    vesselSegLabelsList = cat(2,vesselSegLabelsList,one);
    ground_truth = cat(1,ground_truth,vesselSegLabelsList);
    vesselSegLabelsList = [];
elseif((AVflag==0)&&(~isempty(vesselSegLabelsList)))
    zero = zeros(length(vesselSegLabelsList),1);
    vesselSegLabelsList = cat(2,vesselSegLabelsList,zero);
    ground_truth = cat(1,ground_truth,vesselSegLabelsList);
    vesselSegLabelsList = [];
end

objects = ground_truth(:,1);
labels = ground_truth(:,2);
axes(handles.axesImage);
imshow(bw_image);
hold on
for i=1:length(objects)
    obj = region_props.PixelList{objects(i)};
    if(labels(i)==0)
    plot(obj(:,1),obj(:,2),'red.');
    elseif(labels(i)==1)
    plot(obj(:,1),obj(:,2),'blue.')
    end
end
hold off
clc;
disp(ground_truth);

function GT_SAVE_Callback(~, ~, ~)

global bw_image;
global region_props;
global ground_truth;
uisave({'bw_image','region_props','ground_truth'},...
    'D:\projects\A-V classification\Datasets\CHASEDB1_Groundtruth\Labels assigned\Image_');

function GT_LOAD_Callback(~, ~, handles)

global ground_truth;
global region_props;
global bw_image;

uiopen('D:\projects\A-V classification\Datasets\CHASEDB1_Groundtruth\Labels assigned\load');
objects = ground_truth(:,1);
labels = ground_truth(:,2);
disp('ground_truth Loaded');

axes(handles.axesImage);
imshow(bw_image);
hold on
for i=1:length(objects)
    obj = region_props.PixelList{objects(i)};
    if(labels(i)==0)
    plot(obj(:,1),obj(:,2),'red.');
    elseif(labels(i)==1)
    plot(obj(:,1),obj(:,2),'blue.')
    end
end
hold off

function label_Callback(hObject, ~, ~)
AVflag = str2double(get(hObject,'String'));

function label_CreateFcn(hObject, eventdata, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
