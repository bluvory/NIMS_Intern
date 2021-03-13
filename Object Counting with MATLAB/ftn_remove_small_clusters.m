%% 함수모음: 작은클러스터 제거
function [Ifinal] = ftn_remove_small_clusters(binary_im, cluster_size_threth)
Ibw =  binary_im;
se = strel('square',2);
Imorph = imerode(Ibw,se);
Iarea = bwareaopen(Imorph, cluster_size_threth);  % 주어진 픽셀 덩어리 크기보다 작은것은 제거한다. 즉 그보다 큰 부분만 남긴다. 
Ifinal = Iarea;
end %