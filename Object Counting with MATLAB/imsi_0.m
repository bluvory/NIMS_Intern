
function [img_cropped]= ftn_img_crop(img_rgb)

imshow(img_rgb);
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

img_cropped (:, :, 1)= img_cropped_r;
img_cropped (:, :, 2)= img_cropped_g;
img_cropped (:, :, 3)= img_cropped_b;
