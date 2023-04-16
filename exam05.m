num = input('입력 :')
for i = 1: num
    for j = 1: num - i
        fprintf(' ')
    end
    for k = 1: i
        fprintf('*')
    end
    fprintf('\n')
end