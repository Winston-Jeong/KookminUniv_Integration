count = 0;  % 전진 여부 확인 변수

center_point = [480,240];   % 사각형 중심점이 center_point와 일치해야 통과
centroid = zeros(size(center_point));   % 사각형 중심점

drone = ryze();
cam = camera(drone);
takeoff(drone);

moveback(drone,'Distance',1.0,'Speed',1);   % 크로마키 전체 한 번에 인식하기 위해 뒤로 이동
  
% 1st stage
while 1
    frame = snapshot(cam);

    % 사각형 중심 찾기
    r = frame(:,:,1);   detect_r = (r < 50);   
    g = frame(:,:,2);   detect_g = (g > 10) & (g < 120);
    b = frame(:,:,3);   detect_b = (b > 50) & (b < 190);
    blueNemo = detect_r & detect_g & detect_b;
    
    areaNemo = regionprops(blueNemo,'BoundingBox','Centroid','Area');   % 영상 영역의 속성 측정; BoundingBox, Area, Centroid 값 추출
    areaCh = 0;
    for j = 1:length(areaNemo)
        boxCh = areaNemo(j).BoundingBox; 
        if(boxCh(3) == 960 || boxCh(4) == 720)  % 화면 전체를 사각형으로 인식하는 경우 예외 처리
            continue

        else
            if areaCh <= areaNemo(j).Area   % 가장 큰 영역일 때 속성 추출
                areaCh = areaNemo(j).Area;
                centroid = areaNemo(j).Centroid;
            end
        end
    end

    dis = centroid - center_point;  % 사각형 중점과 center_point 차이

    % case 1
    if(abs(dis(1))<=35 && abs(dis(2))<=35)    % x 좌표 차이, y 좌표 차이가 35보다 작을 경우 center point 인식
        disp("Find Center Point!"); 
        count = 1;
   
    % case 2
    elseif(dis(2)<=0 && abs(dis(2))<=35 && abs(dis(1))>35)
        if(dis(1)<=0)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)>0)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        end    

     % case 3
     elseif(dis(2)<=0 && abs(dis(2))>35)
        if(dis(1)<=0 && abs(dis(1))>35)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)>0 && abs(dis(1))>35)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
       
        elseif(dis(1)<=0 && abs(dis(1))<=35)
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(0.5);

        elseif(dis(1)>0 && abs(dis(1))<=35)
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        end

    % case 4
    elseif(dis(2)>0 && abs(dis(2))<=35 && abs(dis(1))>35)
        if(dis(1)<=0)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)>0)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        end    

     % case 5
     elseif(dis(2)>0 && abs(dis(2))>35)
        if(dis(1)<=0 && abs(dis(1))>35)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)>0 && abs(dis(1))>35)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)<=0 && abs(dis(1))<=35)
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(0.5);

        elseif(dis(1)>0 && abs(dis(1))<=35)
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        end
    end
    
    disp('Moving...');

    % 중심 찾음; 이동 거리 계산
    if count == 1
        hsv = rgb2hsv(frame);
        h = hsv(:,:,1);
        s = hsv(:,:,2);
        v = hsv(:,:,3);
        blue = (0.535<h)&(h<0.69)&(0.4<s)&(v>0.1)&(v<0.97);
        
        blue(1,:) = 1;
        blue(720,:) = 1;
        bw2 = imfill(blue,'holes');
        
        % 구멍을 채우기 전과 후를 비교하여 값이 일정하면 0, 변했으면 1로 변환
        for x=1:720
            for y=1:size(blue,2)
                if blue(x,y)==bw2(x,y)
                    bw2(x,y)=0;
                end
            end
        end
        
        % 이미지에서 인식된 곳들의 장축의 크기를 구함
        stats = regionprops('table',bw2,'MajorAxisLength');
        long_rad = max(stats.MajorAxisLength);
      
        % long_rad의 값에 따라서 거리 추정
        if sum(bw2,'all') <= 10000
            moveforward(drone, 'distance', 2, 'speed', 1);
            long_rad
            
        elseif long_rad > 860
            moveforward(drone, 'distance', 2, 'speed', 1);
            long_rad
            
        else
            Distance = (3E-06)*(long_rad)^2 - 0.0065*long_rad + 4.3399; %크로마키까지의 거리
            moveforward(drone, 'distance', Distance + 1, 'Speed', 1); %크로마키와 폼보드 사이 거리의 절반 추가
            long_rad
            Distance
        end
        break;
    end
end
disp('1st Stage Finish');
turn(drone, deg2rad(90));
moveback(drone,'Distance',0.8,'Speed',1);  %크로마키 80cm인 경우 문제 발생 0.5->0.8 수정
count=0;

%2nd stage
while 1
    frame = snapshot(cam);
   
    % 사각형 중심 찾기
    r = frame(:,:,1);   detect_r = (r < 50);   
    g = frame(:,:,2);   detect_g = (g > 10) & (g < 120);
    b = frame(:,:,3);   detect_b = (b > 50) & (b < 190);
    blueNemo = detect_r & detect_g & detect_b;
    
    areaNemo = regionprops(blueNemo,'BoundingBox','Centroid','Area');   % 영상 영역의 속성 측정; BoundingBox, Area, Centroid 값 추출
    areaCh = 0;
    for j = 1:length(areaNemo)
        boxCh = areaNemo(j).BoundingBox; 
        if(boxCh(3) == 960 || boxCh(4) == 720)  % 화면 전체를 사각형으로 인식하는 경우 예외 처리
            continue

        else
            if areaCh <= areaNemo(j).Area   % 가장 큰 영역일 때 속성 추출
                areaCh = areaNemo(j).Area;
                centroid = areaNemo(j).Centroid;
            end
        end
    end

    dis = centroid - center_point;  % 사각형 중점과 center_point 차이

    % case 1
    if(abs(dis(1))<=35 && abs(dis(2))<=35)    % x 좌표 차이, y 좌표 차이가 35보다 작을 경우 center point 인식
        disp("Find Center Point!"); 
        count = 1;
   
    % case 2
    elseif(dis(2)<=0 && abs(dis(2))<=35 && abs(dis(1))>35)
        if(dis(1)<=0)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)>0)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        end    

     % case 3
     elseif(dis(2)<=0 && abs(dis(2))>35)
        if(dis(1)<=0 && abs(dis(1))>35)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)>0 && abs(dis(1))>35)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
       
        elseif(dis(1)<=0 && abs(dis(1))<=35)
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(0.5);

        elseif(dis(1)>0 && abs(dis(1))<=35)
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        end

    % case 4
    elseif(dis(2)>0 && abs(dis(2))<=35 && abs(dis(1))>35)
        if(dis(1)<=0)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)>0)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        end    

     % case 5
     elseif(dis(2)>0 && abs(dis(2))>35)
        if(dis(1)<=0 && abs(dis(1))>35)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)>0 && abs(dis(1))>35)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        
        elseif(dis(1)<=0 && abs(dis(1))<=35)
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(0.5);

        elseif(dis(1)>0 && abs(dis(1))<=35)
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(0.5);
        end
    end
    
    disp('Moving...');

    % 중심 찾음; 이동 거리 계산
    if count == 1
        hsv = rgb2hsv(frame);
        h = hsv(:,:,1);
        s = hsv(:,:,2);
        v = hsv(:,:,3);
        blue = (0.535<h)&(h<0.69)&(0.4<s)&(v>0.1)&(v<0.97);
        
        blue(1,:) = 1;
        blue(720,:) = 1;
        bw2 = imfill(blue,'holes');
        
        % 구멍을 채우기 전과 후를 비교하여 값이 일정하면 0, 변했으면 1로 변환
        for x=1:720
            for y=1:size(blue,2)
                if blue(x,y)==bw2(x,y)
                    bw2(x,y)=0;
                end
            end
        end
        
        % 이미지에서 인식된 곳들의 장축의 크기를 구함
        stats = regionprops('table',bw2,'MajorAxisLength');
        long_rad = max(stats.MajorAxisLength);
      
        % long_rad의 값에 따라서 거리 추정
        if sum(bw2,'all') <= 10000
            moveforward(drone, 'distance', 2.2, 'speed', 1);
            long_rad
            
        elseif long_rad > 860
            moveforward(drone, 'distance', 2.2, 'speed', 1); %1.2m+1m
            long_rad
            
        else
            Distance = (3E-06)*(long_rad)^2 - 0.0065*long_rad + 4.3399; %크로마키까지의 거리
            moveforward(drone, 'distance', Distance + 1, 'Speed', 1); %크로마키와 폼보드 사이 거리의 절반 추가
            pause(1);
            long_rad
            Distance
        end
        break;
    end
end
disp('2nd Stage Finish');
turn(drone, deg2rad(90));
moveback(drone,'Distance',0.8,'Speed',1);  %0.5->0.8 로 수정 
count=0;

%3rd stage
while 1
    frame = snapshot(cam);
    
    % 사각형 중심 구하기
    r = frame(:,:,1);   detect_r = (r < 50);   
    g = frame(:,:,2);   detect_g = (g > 10) & (g < 120);
    b = frame(:,:,3);   detect_b = (b > 50) & (b < 190);
    blueNemo = detect_r & detect_g & detect_b;
    
    areaNemo = regionprops(blueNemo,'BoundingBox','Centroid','Area');   % 영상 영역의 속성 측정; BoundingBox, Area, Centroid 값 추출
    areaCh = 0;
    for j = 1:length(areaNemo)
        boxCh = areaNemo(j).BoundingBox; 
        if(boxCh(3) == 960 || boxCh(4) == 720)  % 화면 전체를 사각형으로 인식하는 경우 예외 처리
            continue

        else
            if areaCh <= areaNemo(j).Area   % 가장 큰 영역일 때 속성 추출
                areaCh = areaNemo(j).Area;
                centroid = areaNemo(j).Centroid;
            end
        end
    end
    
    dis = centroid - center_point;  % 사각형 중점과 center_point 차이

    % case 1
    if(abs(dis(1))<=35 && abs(dis(2))<=35)    % x 좌표 차이, y 좌표 차이가 35보다 작을 경우 center point 인식
        disp("Find Center Point!"); 
        count = 1;
   
    % case 2
    elseif(dis(2)<=0 && abs(dis(2))<=35 && abs(dis(1))>35)
        if(dis(1)<=0)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)>0)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            pause(1);
        end    

     % case 3
     elseif(dis(2)<=0 && abs(dis(2))>35)
        if(dis(1)<=0 && abs(dis(1))>35)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)>0 && abs(dis(1))>35)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(1);
       
        elseif(dis(1)<=0 && abs(dis(1))<=35)
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(1);

        elseif(dis(1)>0 && abs(dis(1))<=35)
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(1);
        end

    % case 4
    elseif(dis(2)>0 && abs(dis(2))<=35 && abs(dis(1))>35)
        if(dis(1)<=0)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)>0)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            pause(1);
        end    

     % case 5
     elseif(dis(2)>0 && abs(dis(2))>35)
        if(dis(1)<=0 && abs(dis(1))>35)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)>0 && abs(dis(1))>35)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)<=0 && abs(dis(1))<=35)
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(1);

        elseif(dis(1)>0 && abs(dis(1))<=35)
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(1);
        end
    end
    
    disp('Moving...');

    % 중심 찾음; 이동 거리 계산
    if count == 1
        hsv = rgb2hsv(frame);
        h = hsv(:,:,1);
        s = hsv(:,:,2);
        v = hsv(:,:,3);
        blue = (0.535<h)&(h<0.69)&(0.4<s)&(v>0.1)&(v<0.97);
        
        blue(1,:) = 1;
        blue(720,:) = 1;
        bw2 = imfill(blue,'holes');
        
        %구멍을 채우기 전과 후를 비교하여 값이 일정하면 0, 변했으면 1로 변환
        for x=1:720
            for y=1:size(blue,2)
                if blue(x,y)==bw2(x,y)
                    bw2(x,y)=0;
                end
            end
        end
        
        %이미지에서 인식된 곳들의 장축의 크기를 구함
        stats = regionprops('table',bw2,'MajorAxisLength');
        long_rad = max(stats.MajorAxisLength);
        
        %long_rad의 값에 따라서 거리 추정
        if sum(bw2,'all') <= 10000
            moveforward(drone, 'distance', 1.7, 'speed', 1);
            long_rad
            
        elseif long_rad > 860
            moveforward(drone, 'distance', 1.7, 'speed', 1); %1.2m+0.5m
            long_rad
            
        else
            Distance = (7E-06)*(long_rad)^2 - 0.0102*long_rad + 4.5856; %크로마키까지의 거리
            moveforward(drone, 'distance', Distance + 1, 'Speed', 1); %크로마키와 폼보드 사이 임의의 거리 추가, 0.5->1
            pause(1);
            long_rad
            Distance
        end
        break;
    end
end

disp('3rd Stage Finish');
turn(drone, deg2rad(30));
count=0;

% 4th stage

% 10도씩 회전하며 탐색->5도로 수정
max_sum = 0;

for index = 1:7
    if index > 1
        turn(drone, deg2rad(5));
        pause(0.5); %안정성을 위해 pause 추가
    end

    frame = snapshot(cam);
    r = frame(:,:,1);   detect_r = (r < 50);   
    g = frame(:,:,2);   detect_g = (g > 10) & (g < 120);
    b = frame(:,:,3);   detect_b = (b > 50) & (b < 190);
    blueNemo = detect_r & detect_g & detect_b;
    sum_blue = sum(sum(blueNemo));

    if sum_blue > max_sum
        max_sum = sum_blue;
        max_index = index;
    end
end

% 최적 각도
angle = (-1) * 5 * (7 - max_index);
turn(drone, deg2rad(angle));

while 1
    frame = snapshot(cam);
    
    % 사각형 중심 구하기
    r = frame(:,:,1);   detect_r = (r < 50);   
    g = frame(:,:,2);   detect_g = (g > 10) & (g < 120);
    b = frame(:,:,3);   detect_b = (b > 50) & (b < 190);
    blueNemo = detect_r & detect_g & detect_b;
    
    areaNemo = regionprops(blueNemo,'BoundingBox','Centroid','Area');   % 영상 영역의 속성 측정; BoundingBox, Area, Centroid 값 추출
    areaCh = 0;
    for j = 1:length(areaNemo)
        boxCh = areaNemo(j).BoundingBox; 
        if(boxCh(3) == 960 || boxCh(4) == 720)  % 화면 전체를 사각형으로 인식하는 경우 예외 처리
            continue

        else
            if areaCh <= areaNemo(j).Area   % 가장 큰 영역일 때 속성 추출
                areaCh = areaNemo(j).Area;
                centroid = areaNemo(j).Centroid;
            end
        end
    end
    
    dis = centroid - center_point;  % 사각형 중점과 center_point 차이

    % case 1
    if(abs(dis(1))<=35 && abs(dis(2))<=35)    % x 좌표 차이, y 좌표 차이가 35보다 작을 경우 center point 인식
        disp("Find Center Point!"); 
        count = 1;
   
    % case 2
    elseif(dis(2)<=0 && abs(dis(2))<=35 && abs(dis(1))>35)
        if(dis(1)<=0)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)>0)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            pause(1);
        end    

     % case 3
     elseif(dis(2)<=0 && abs(dis(2))>35)
        if(dis(1)<=0 && abs(dis(1))>35)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)>0 && abs(dis(1))>35)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(1);
       
        elseif(dis(1)<=0 && abs(dis(1))<=35)
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(1);

        elseif(dis(1)>0 && abs(dis(1))<=35)
            disp("Move up");
            moveup(drone,'Distance',0.2,'Speed',1);
            pause(1);
        end

    % case 4
    elseif(dis(2)>0 && abs(dis(2))<=35 && abs(dis(1))>35)
        if(dis(1)<=0)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)>0)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            pause(1);
        end    

     % case 5
     elseif(dis(2)>0 && abs(dis(2))>35)
        if(dis(1)<=0 && abs(dis(1))>35)
            disp("Move left");
            moveleft(drone,'Distance',0.2,'Speed',1);
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)>0 && abs(dis(1))>35)
            disp("Move right");
            moveright(drone,'Distance',0.2,'Speed',1);
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(1);
        
        elseif(dis(1)<=0 && abs(dis(1))<=35)
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(1);

        elseif(dis(1)>0 && abs(dis(1))<=35)
            disp("Move down");
            movedown(drone,'Distance',0.2,'Speed',1);
            pause(1);
        end
    end
    

    disp('Moving...');

    % 중심 찾음; 이동 거리 계산
    if count == 1
        hsv = rgb2hsv(frame);
        h = hsv(:,:,1);
        s = hsv(:,:,2);
        v = hsv(:,:,3);
        blue = (0.535<h)&(h<0.69)&(0.4<s)&(v>0.1)&(v<0.97);
        
        blue(1,:) = 1;
        blue(720,:) = 1;
        bw2 = imfill(blue,'holes');
        
        %구멍을 채우기 전과 후를 비교하여 값이 일정하면 0, 변했으면 1로 변환
        for x=1:720
            for y=1:size(blue,2)
                if blue(x,y)==bw2(x,y)
                    bw2(x,y)=0;
                end
            end
        end
        
        %이미지에서 인식된 곳들의 장축의 크기를 구함
        stats = regionprops('table',bw2,'MajorAxisLength');
        long_rad = max(stats.MajorAxisLength);
        
        %long_rad의 값에 따라서 거리 추정
        if sum(bw2,'all') <= 10000
            moveforward(drone, 'distance', 0.2, 'speed', 1);
            long_rad
            
        elseif long_rad > 460
            moveforward(drone, 'distance', 0.2, 'speed', 1);
            long_rad
            
        else
            Distance = (1E-05)*(long_rad)^2 - 0.0124*long_rad + 4.5996; %크로마키까지의 거리
            moveforward(drone, 'distance', Distance - 0.8, 'Speed', 1); %크로마키와 폼보드 사이 거리-1(착륙지점)// 1->0.8로 수정
            long_rad
            Distance
            
        end
        break;
    end
end

disp('4th Stage Finish');
disp('Mission Complete!');
land(drone);
