%% �Լ�����: ����Ŭ������ ����
function [Ifinal] = ftn_remove_small_clusters(binary_im, cluster_size_threth)
Ibw =  binary_im;
se = strel('square',2);
Imorph = imerode(Ibw,se);
Iarea = bwareaopen(Imorph, cluster_size_threth);  % �־��� �ȼ� ��� ũ�⺸�� �������� �����Ѵ�. �� �׺��� ū �κи� �����. 
Ifinal = Iarea;
end %