%%1. 백터 입력
num_vectors = 3;
vectors = zeros(num_vectors, 3);

for i = 1:num_vectors
    x = input('x 좌표를 입력하세요: ');
    y = input('y 좌표를 입력하세요: ');
    z = input('z 좌표를 입력하세요: ');
    vectors(i, :) = [x, y, z];
end

%%2. ~~유클리디안, 코사인유사도 계산 후
%유클리디안거리 작은 값 찾기
if(dista<=distb) 
    if(dista<=distc)
        nearvec=dista;
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
%코사인유사도 큰 값 찾기
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
