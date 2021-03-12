function varargout = Flower(varargin)
% FLOWER MATLAB code for Flower.fig
%      FLOWER, by itself, creates a new FLOWER or raises the existing
%      singleton*.
%
%      H = FLOWER returns the handle to a new FLOWER or the handle to
%      the existing singleton*.
%
%      FLOWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLOWER.M with the given input arguments.
%
%      FLOWER('Property','Value',...) creates a new FLOWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Flower_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Flower_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Flower

% Last Modified by GUIDE v2.5 16-Jun-2020 16:57:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Flower_OpeningFcn, ...
                   'gui_OutputFcn',  @Flower_OutputFcn, ...
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


% --- Executes just before Flower is made visible.
function Flower_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Flower (see VARARGIN)
% global gfile

% Choose default command line output for Flower
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Flower wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% gfile = get(handles.edit1, 'String')


% --- Outputs from this function are returned to the command line.
function varargout = Flower_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cluster_size_threth = str2double(get(handles.edit2,'String'));  % �� ������ ���� �ȼ����� ��� �����Ѵ�. 
overlab_th = 0.8;
r1 = str2double(get(handles.edit3,'String'));
r2 = str2double(get(handles.edit4,'String')); %�ɿ� �����ϴ� �������� r1���� r2�� ���� ã��.
sens = str2double(get(handles.edit6,'String')); %Sensitivity�� 1�� ����� ���� ���� ������� ���� �͵� ã��.
corr_factor = str2double(get(handles.edit5,'String')); % percentage (%)

%% HSV �̹��� ���ġ���� �����ϱ�
hsv_h_min =0.11; hsv_h_max =0.174;  % �̹��� h ��忡���� ���ġ ����
hsv_s_min =0.68; hsv_s_max =1.0;
hsv_v_min =0.68; hsv_v_max =1.0;

LH = (hsv_h_max-hsv_h_min)*corr_factor/2;
LS = (hsv_s_max-hsv_s_min)*corr_factor/2;
LV = (hsv_v_max-hsv_v_min)*corr_factor/2;

hsv_h_min =0.11-LH; hsv_h_max =0.174+LH;  % �̹��� h ��忡���� ���ġ ���� 
hsv_s_min =0.68-LS; hsv_s_max =1.0+LS;
hsv_v_min =0.68-LV; hsv_v_max =1.0+LH;
        
%% �̹��� �о���̱�
img_rgb=imread([get(handles.edit1,'String')]);

%% �̹������� Ư��(����) ������ �ش��ϴ� �κ��� �����Ѵ�.  
axes(handles.axes1)
h_rect = imrect();
%% �簢�� ��ġ���� [xmin, ymin, width, height]
pos_rect = h_rect.getPosition();

%% �Ҽ������ϴ� �ݿø� ó���Ѵ�.
pos_rect = round(pos_rect);

%% �̹����󿡼� ������ �簢�� ������ �ش��ϴ� �κ��� �����Ѵ�. 
img_r =  img_rgb(:,:,1);
img_g =  img_rgb(:,:,2);
img_b =  img_rgb(:,:,3);

img_cropped_r = img_r(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));
img_cropped_g = img_g(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));
img_cropped_b = img_b(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));

img_cropped(:, :, 1)= img_cropped_r;
img_cropped(:, :, 2)= img_cropped_g;
img_cropped(:, :, 3)= img_cropped_b;


%% RGB�̹����� HSV �̹����� �ٲٱ� 
img_hsv = rgb2hsv(img_cropped); 

%% HSV �̹��� ���μ��� 
img_hsv_h = img_hsv(:,:,1);  % ����
img_hsv_s = img_hsv(:,:,2);  % ä��
img_hsv_v = img_hsv(:,:,3);  % ��
img_hsv_red = double(zeros(size(img_hsv_h))); 


for i = 1: size(img_hsv_red, 1)

    for j = 1:size(img_hsv_red, 2)
        
        if (img_hsv_h(i, j) > hsv_h_min && img_hsv_h(i, j) < hsv_h_max) && (img_hsv_s(i, j) > hsv_s_min && img_hsv_s(i, j) < hsv_s_max) && (img_hsv_v(i,j) > hsv_v_min && img_hsv_v(i, j) < hsv_v_max)  

            img_hsv_red(i, j) = 1;

        end

    end

end

%% ������ �ɰ�輱 �������� ����ä��� 
se = strel('disk',5);
im4 = imclose(img_hsv_red,se);

im5 = imfill(im4, 'holes');
[centers, radii] = imfindcircles(im5, [r1, r2], 'Sensitivity', sens);

%% �ε鷹�ɵ鰣�� ������ ������ ���� ���� �����ϱ�
save infor_flower.mat centers radii
M = ftn_area_intersect_circle(); % ��(�ɴ���)�鰣�� ������ ���� ����Ѵ�.
[z, num_flowers] = ftn_overlab(M, overlab_th); % ���ġ(e.g. 90%)�̻� �̿��� ���� ��ġ�� ���� �����Ѵ�.


%% ó����� �ð�ȭ �ϱ�
figure;
str = sprintf('number of detected flowers = %d', num_flowers);
imshow(img_cropped); title(str);
[b_idx]=find(z==0);
centers(b_idx, :) = [];
radii(b_idx, :) = [];
viscircles(centers, radii,'EdgeColor','r');  % �̹������� ������ ���� ǥ���Ѵ�.
set(gcf,'color','w');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gfile
[file,path] = uigetfile('*');
set(handles.edit1,'String',file);
gca = set(handles.axes1);
imshow(strcat(path,file))



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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
