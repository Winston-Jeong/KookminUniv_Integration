H = input('상덕버거의 가격: ');
M = input('중덕버거의 가격: ');
L = input('하덕버거의 가격: ');
P = input('콜라의 가격: ');
C = input('사이다의 가격: ');

arr1 = [ H M L ];
arr2 = [ P C ];

 
min1 = min(arr1);
min2 = min(arr2);
ans = min1 + min2 -50