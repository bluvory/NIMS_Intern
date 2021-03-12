function M = ftn_area_intersect_circles(centers, radii)
%입력값으로 아무 숫자도 넣지말것.
% 실행 : M = ftn_area_intersect_circle()
x =centers(:,1)';
y =centers(:,2)';
r =radii';

if nargin==0  % 이부분을 선택한다. 
 
% Inputs are reshaped in 
size_x = numel(x);
size_y = numel(y);
size_r = numel(r);

x = reshape(x,size_x,1);
y = reshape(y,size_y,1);
r = reshape(r,size_r,1);

% Checking if the three input vectors have the same length
if (size_x~=size_y)||(size_x~=size_r)
    error('Input of function must be the same length')
end

% Checking if there is any negative or null radius
if any(r<=0)
    disp('Circles with null or negative radius won''t be taken into account in the computation.')
    temp = (r>0);
    x = x(temp);
    y = y(temp);
    r = r(temp);
end

% Checking the size of the input argument
if size_x==1
    M = pi*r.^2;
    return
end

% Computation of distance between all circles, which will allow to
% determine which cases to use.
[X,Y] = meshgrid(x,y);
D     = sqrt((X-X').^2+(Y-Y').^2);
% Since the resulting matrix M is symmetric M(i,j)=M(j,i), computations are
% performed only on the upper part of the matrix
D = triu(D,1);

[R1,R2] = meshgrid(r);
sumR    = triu(R1+R2,1);
difR    = triu(abs(R1-R2),1);


% Creating the resulting vector
M = zeros(size_x*size_x,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Case 2: Circles i & j fully overlap
% One of the circles is inside the other one.
C1    = triu(D<=difR);
M(C1) = pi*min(R1(C1),R2(C1)).^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Case 3: Circles i & j partially overlap
% Partial intersection between circles i & j
C2 = (D>difR)&(D<sumR);
% Computation of the coordinates of one of the intersection points of the
% circles i & j
Xi(C2,1) = (R1(C2).^2-R2(C2).^2+D(C2).^2)./(2*D(C2));
Yi(C2,1) = sqrt(R1(C2).^2-Xi(C2).^2);
% Computation of the partial intersection area between circles i & j
M(C2,1) = R1(C2).^2.*atan2(Yi(C2,1),Xi(C2,1))+...
          R2(C2).^2.*atan2(Yi(C2,1),(D(C2)-Xi(C2,1)))-...
          D(C2).*Yi(C2,1);
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
% Compute the area of each circle. Assign the results to the diagonal of M      
M(1:size_x+1:size_x*size_x) = pi.*r.^2; 

% Conversion of vector M to matrix M      
M = reshape(M,size_x,size_x);

% Creating the lower part of the matrix
M = M + tril(M',-1);

end