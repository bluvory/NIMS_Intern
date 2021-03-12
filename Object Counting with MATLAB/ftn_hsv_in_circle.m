function [H_seq, S_seq, V_seq] = ftn_hsv_in_circle(center_x, center_y, banzirm, HSV)
% k=42;
% banzirm = radii(k);
% center_x = centers(k,1);
% center_y = centers(k,2);

[imageSizeX, imageSizeY, imageSizeZ]=size(HSV);

[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% L=length(centers(:,1));
% for kk =1: L
centerX = center_x;
centerY = center_y;
radius = banzirm;
circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;

% circlePixels 는 원내부를 1, 외부를 0으로 하는 마스크 만들기. 
image(circlePixels) ;
colormap([0 0 0; 1 1 1]);
mask = circlePixels';
MASK=double(mask);

% 마스크(원)내부의 hsv 정보를 추출한다.

H_Channel = double(HSV(:, :, 1)); 
S_Channel = double(HSV(:, :, 2));
V_Channel = double(HSV(:, :, 3));

% 각 채널별 이미지에 마스크를 씌운다.
H_in_circle = H_Channel.*MASK;
S_in_circle = S_Channel.*MASK;
V_in_circle = V_Channel.*MASK;

% 마스크 내부의 값들 좌표 추출
[p1, q1]=find(H_in_circle > 0.0);
[p2, q2]=find(S_in_circle > 0.0);
[p3, q3]=find(V_in_circle > 0.0);

% 추출된 좌표에 해당하는 h, s, v 정보 추출하기
for k = 1: length(p1)
H_seq(k) = H_Channel(p1(k), q1(k));
end 

for k = 1: length(p2)
S_seq(k) = S_Channel(p2(k), q2(k));
end 

for k = 1: length(p3)
V_seq(k) = V_Channel(p3(k), q3(k));
end 

% % 추출된 h , s, v 정보 담기.
% HSV_in_circle(kk).H = H_seq;
% HSV_in_circle(kk).S = S_seq;
% HSV_in_circle(kk).V = V_seq;

% end  %for kk =1: L
