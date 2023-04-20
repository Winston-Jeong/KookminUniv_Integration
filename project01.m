%%1. 백터 입력
num_vectors = 3;
vectors = zeros(num_vectors, 3);

for i = 1:num_vectors
    x = input('x 좌표를 입력하세요: ');
    y = input('y 좌표를 입력하세요: ');
    z = input('z 좌표를 입력하세요: ');
    vectors(i, :) = [x, y, z];
end

%%3. 유클리디안 거리 출력, 코사인 유사도 출력
if samevec == cosb
    Max_v1 = vectors(2, :);
    Max_v2 = vectors(3, :);
elseif samevec == cosa
    Max_v1 = vectors(1, :);
    Max_v2 = vectors(2, :);
else
    Max_v1 = vectors(1, :);
    Max_v2 = vectors(3, :);
end
near_v1
near_v2
Max_v1
Max_v2
