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

% circlePixels �� �����θ� 1, �ܺθ� 0���� �ϴ� ����ũ �����. 
image(circlePixels) ;
colormap([0 0 0; 1 1 1]);
mask = circlePixels';
MASK=double(mask);

% ����ũ(��)������ hsv ������ �����Ѵ�.

H_Channel = double(HSV(:, :, 1)); 
S_Channel = double(HSV(:, :, 2));
V_Channel = double(HSV(:, :, 3));

% �� ä�κ� �̹����� ����ũ�� �����.
H_in_circle = H_Channel.*MASK;
S_in_circle = S_Channel.*MASK;
V_in_circle = V_Channel.*MASK;

% ����ũ ������ ���� ��ǥ ����
[p1, q1]=find(H_in_circle > 0.0);
[p2, q2]=find(S_in_circle > 0.0);
[p3, q3]=find(V_in_circle > 0.0);

% ����� ��ǥ�� �ش��ϴ� h, s, v ���� �����ϱ�
for k = 1: length(p1)
H_seq(k) = H_Channel(p1(k), q1(k));
end 

for k = 1: length(p2)
S_seq(k) = S_Channel(p2(k), q2(k));
end 

for k = 1: length(p3)
V_seq(k) = V_Channel(p3(k), q3(k));
end 

% % ����� h , s, v ���� ���.
% HSV_in_circle(kk).H = H_seq;
% HSV_in_circle(kk).S = S_seq;
% HSV_in_circle(kk).V = V_seq;

% end  %for kk =1: L
