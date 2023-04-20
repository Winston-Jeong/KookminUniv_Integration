%1차 매트랩 과제
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

%%2. 유클리디안 거리, 코사인 유사도
%유클리디안거리
dista = norm(vectors(1, :)-vectors(2, :));
distb = norm(vectors(2, :)-vectors(3, :));
distc = norm(vectors(3, :)-vectors(1, :));
%코사인유사도
cosa = cosineSimilarity(vectors(1, :), vectors(2, :));
cosb = cosineSimilarity(vectors(2, :), vectors(3, :));
cosc = cosineSimilarity(vectors(3, :), vectors(1, :));

%유클리디안거리
if(dista<=distb) 
    if(dista<=distc)
        nearvec=disda;
    end
    if(dista>distc)
        nearvec=distc;
    end
end

if(dista>distb) 
    if(distb<=distc)
        nearvec=distb;
    end
    if(distb>distc)
        nearvec=distc;
    end
end

if(nearvec==dista) 
    near_v1=vectors(1, :);
    near_v2=vectors(2, :);
end

if(nearvec==distb) 
    near_v1=vectors(2, :); 
    near_v2=vectors(3, :);
end

if(nearvec==distc) 
    near_v1=vectors(3, :);
    near_v2=vectors(1, :);
end
%코사인유사도
if(cosa>=cosb) 
    if(cosa>=cosc)
        samevec=cosa;
    end
    if(cosa<cosc)
        samevec=cosc;
    end
end

if(cosa<cosb) 
    if(cosb>=cosc)
        samevec=cosb;
    end
    if(cosb<cosc)
        samevec=cosc;
    end
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