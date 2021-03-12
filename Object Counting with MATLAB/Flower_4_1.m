%% �ε鷹�� �ڵ� ī���� ����Ʈ���� ����
%% �����������п�����:��ö��,������, ����ȫ, �̻���
%%

clear all
close all
clc

%% �ε鷹�� ���� ī���͸� ���� ��������
cluster_size_threth = 130;  % �� ������ ���� �ȼ����� ��� �����Ѵ�. 
overlab_th = 0.8;
r1 = 19; r2 = 50; %�ɿ� �����ϴ� �������� r1���� r2�� ���� ã��.
sens =0.976; %Sensitivity�� 1�� ����� ���� ���� ������� ���� �͵� ã��.
corr_factor =0.02; % percentage (%)

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
        
k=1; % �̹��� ���ϸ�

%% �̹��� �о���̱�
img_rgb=imread(['flower (' num2str(k),').jpg']);

%% �̹������� Ư��(����) ������ �ش��ϴ� �κ��� �����Ѵ�.  
[img_cropped, pos_rect]= ftn_img_crop(img_rgb);

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

%% [[�ذ��ؾ� �ϴ� ����]]
%% �������� ������ �Է��ϴ� ������ ����� (����Ʈ���ֱ�)/ GUI �����ϱ�
%% �������Ϸ� ����ϴ� ��� �����, ���ϸ����� ��ϵǴ� ����߰�.
%% ��� ������ ��, ä�� �����ϰ� ����� �Լ�
%% ��Ʈ�� �������� �����
%% �̹����� Ư�� ���� ���콺�� �����ϸ� �� ������ �ɸ� ī���� �ϴ� ���.
%% ���ϴ� �̹��� ���� �о� ���̴� ���./ ���� ���� ���� �����ϵ���/





