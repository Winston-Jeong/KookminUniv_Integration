N = input('과목개수입력: ')
for i = 1: N
    score(i) = input('점수입력:')
end

max_num = max(score);

for i = 1: N
    score(i) = round(score(i)/max_num*100, 2)
end

ans = mean(score)