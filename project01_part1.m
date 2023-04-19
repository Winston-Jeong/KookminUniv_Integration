%%1. 백터 입력
num_vectors = 3;
vectors = zeros(num_vectors, 3);

for i = 1:num_vectors
    x = input('x 좌표를 입력하세요: ');
    y = input('y 좌표를 입력하세요: ');
    z = input('z 좌표를 입력하세요: ');
    vectors(i, :) = [x, y, z];
end
%fprintf('%d ', vectors(3, :))