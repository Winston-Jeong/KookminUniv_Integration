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
%유클리디안거리
disda = norm(vectors(1, :)-vectors(2, :));
distb = norm(vectors(2, :)-vectors(3, :));
distc = norm(vectors(3, :)-vectors(1, :));
%코사인유사도
cosa = cosineSimilarity(vectors(1, :), vectors(2, :));
cosb = cosineSimilarity(vectors(2, :), vectors(3, :));
cosc = cosineSimilarity(vectors(3, :), vectors(1, :));