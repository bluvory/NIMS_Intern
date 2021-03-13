
function [img_cropped]= ftn_img_crop(img_rgb)

imshow(img_rgb);
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

img_cropped (:, :, 1)= img_cropped_r;
img_cropped (:, :, 2)= img_cropped_g;
img_cropped (:, :, 3)= img_cropped_b;
