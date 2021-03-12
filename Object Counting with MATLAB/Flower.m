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
cluster_size_threth = str2double(get(handles.edit2,'String'));  % 이 값보다 작은 픽셀들을 모두 제거한다. 
overlab_th = 0.8;
r1 = str2double(get(handles.edit3,'String'));
r2 = str2double(get(handles.edit4,'String')); %꽃에 대응하는 반지름이 r1에서 r2인 원을 찾기.
sens = str2double(get(handles.edit6,'String')); %Sensitivity는 1에 가까울 수록 원에 비슷하지 않은 것도 찾음.
corr_factor = str2double(get(handles.edit5,'String')); % percentage (%)

%% HSV 이미지 경계치값들 보정하기
hsv_h_min =0.11; hsv_h_max =0.174;  % 이미지 h 모드에서의 경계치 설정
hsv_s_min =0.68; hsv_s_max =1.0;
hsv_v_min =0.68; hsv_v_max =1.0;

LH = (hsv_h_max-hsv_h_min)*corr_factor/2;
LS = (hsv_s_max-hsv_s_min)*corr_factor/2;
LV = (hsv_v_max-hsv_v_min)*corr_factor/2;

hsv_h_min =0.11-LH; hsv_h_max =0.174+LH;  % 이미지 h 모드에서의 경계치 보정 
hsv_s_min =0.68-LS; hsv_s_max =1.0+LS;
hsv_v_min =0.68-LV; hsv_v_max =1.0+LH;
        
%% 이미지 읽어들이기
img_rgb=imread([get(handles.edit1,'String')]);

%% 이미지상의 특정(관심) 영역에 해당하는 부분을 선택한다.  
axes(handles.axes1)
h_rect = imrect();
%% 사각형 위치선택 [xmin, ymin, width, height]
pos_rect = h_rect.getPosition();

%% 소수점이하는 반올림 처리한다.
pos_rect = round(pos_rect);

%% 이미지상에서 선택한 사각형 영역에 해당하는 부분을 추출한다. 
img_r =  img_rgb(:,:,1);
img_g =  img_rgb(:,:,2);
img_b =  img_rgb(:,:,3);

img_cropped_r = img_r(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));
img_cropped_g = img_g(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));
img_cropped_b = img_b(pos_rect(2) + (0:pos_rect(4)), pos_rect(1) + (0:pos_rect(3)));

img_cropped(:, :, 1)= img_cropped_r;
img_cropped(:, :, 2)= img_cropped_g;
img_cropped(:, :, 3)= img_cropped_b;


%% RGB이미지를 HSV 이미지로 바꾸기 
img_hsv = rgb2hsv(img_cropped); 

%% HSV 이미지 프로세싱 
img_hsv_h = img_hsv(:,:,1);  % 색상
img_hsv_s = img_hsv(:,:,2);  % 채도
img_hsv_v = img_hsv(:,:,3);  % 명도
img_hsv_red = double(zeros(size(img_hsv_h))); 


for i = 1: size(img_hsv_red, 1)

    for j = 1:size(img_hsv_red, 2)
        
        if (img_hsv_h(i, j) > hsv_h_min && img_hsv_h(i, j) < hsv_h_max) && (img_hsv_s(i, j) > hsv_s_min && img_hsv_s(i, j) < hsv_s_max) && (img_hsv_v(i,j) > hsv_v_min && img_hsv_v(i, j) < hsv_v_max)  

            img_hsv_red(i, j) = 1;

        end

    end

end

%% 깨어진 꽃경계선 기준으로 내부채우기 
se = strel('disk',5);
im4 = imclose(img_hsv_red,se);

im5 = imfill(im4, 'holes');
[centers, radii] = imfindcircles(im5, [r1, r2], 'Sensitivity', sens);

%% 민들레꽃들간의 오버랩 정도에 따라 갯수 수정하기
save infor_flower.mat centers radii
M = ftn_area_intersect_circle(); % 원(꽃대응)들간의 오버랩 면적 계산한다.
[z, num_flowers] = ftn_overlab(M, overlab_th); % 경계치(e.g. 90%)이상 이웃한 원과 겹치는 원을 제거한다.


%% 처리결과 시각화 하기
figure;
str = sprintf('number of detected flowers = %d', num_flowers);
imshow(img_cropped); title(str);
[b_idx]=find(z==0);
centers(b_idx, :) = [];
radii(b_idx, :) = [];
viscircles(centers, radii,'EdgeColor','r');  % 이미지위에 빨간색 원을 표시한다.
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
