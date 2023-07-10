%%2. 유클리디안 거리, 코사인 유사도

%유클리디안 거리
dista = norm(vectors(1, :)-vectors(2, :));
distb = norm(vectors(2, :)-vectors(3, :));
distc = norm(vectors(3, :)-vectors(1, :));

%코사인유사도
cosa = cosineSimilarity(vectors(1, :), vectors(2, :));
cosb = cosineSimilarity(vectors(2, :), vectors(3, :));
cosc = cosineSimilarity(vectors(3, :), vectors(1, :));
