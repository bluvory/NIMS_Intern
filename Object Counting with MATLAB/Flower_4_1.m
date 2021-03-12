%% 민들레꽃 자동 카운팅 소프트웨어 개발
%% 국가수리과학연구소:박철민,서상협, 조준홍, 이상희
%%

clear all
close all
clc

%% 민들레꽃 갯수 카운터를 위한 조절변수
cluster_size_threth = 130;  % 이 값보다 작은 픽셀들을 모두 제거한다. 
overlab_th = 0.8;
r1 = 19; r2 = 50; %꽃에 대응하는 반지름이 r1에서 r2인 원을 찾기.
sens =0.976; %Sensitivity는 1에 가까울 수록 원에 비슷하지 않은 것도 찾음.
corr_factor =0.02; % percentage (%)

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
        
k=1; % 이미지 파일명

%% 이미지 읽어들이기
img_rgb=imread(['flower (' num2str(k),').jpg']);

%% 이미지상의 특정(관심) 영역에 해당하는 부분을 선택한다.  
[img_cropped, pos_rect]= ftn_img_crop(img_rgb);

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

%% [[해결해야 하는 문제]]
%% 여러가지 값들을 입력하는 윈도우 만들기 (디폴트값주기)/ GUI 구현하기
%% 엑셀파일로 출력하는 기능 만들기, 파일명으로 기록되는 기능추가.
%% 모든 사진의 명도, 채도 동일하게 만드는 함수
%% 매트랩 실행파일 만들기
%% 이미지내 특정 영역 마우스로 지정하면 그 내부의 꽃만 카운터 하는 기능.
%% 원하는 이미지 파일 읽어 들이는 기능./ 여러 파일 지정 가능하도록/





