%Cristina Chu

%Part 5

img = imread('ps1-input1.jpg');
img = rgb2gray(img);

%% ----a.Smooth image-----%
kernel = fspecial('gaussian', 8,4); 
smooth = imfilter(img, kernel);

imwrite(smooth, 'ps1_5_a_smooth.jpg');

%% ----b.Edge image----%
edgeSmooth = edge(img, 'canny', .2);

imwrite(edgeSmooth, 'ps1-5-b-edge.png');


%% ----c.Hough Transform----%
BW = edgeSmooth;

%-Get points and angles
[x,y]=find(BW == 1);

t = 0:pi/1000:pi;

%% -Create array 
%sizes for array
sizeD = 1500; 
sizeT = ceil(max(t(:))*200)+1;  %maximun value of t

%array with all zeros
array = zeros(sizeD, sizeT);


%% -Loop (voting)
for d = 1:length(x)
    for t1 = t
        dist = uint16((x(d)*cos(t1) - y(d)*sin(t1))+800);
        t0 = uint16(t1*200);
        array(dist+1, t0+1) = array(dist+1, t0+1) + 1;
    end
end


%% Find values of (d,t) that max array(d,t)
%making Hough transform visual
toShow = uint8(array*256/max(array(:)));
[dShow, tShow] = find(toShow>max(toShow(:))-110);

t = (tShow-2)/200;
d = (dShow-801);

figure(2);
imshow(toShow);

hold on;    %to keep image and draw on top
p = plot(tShow, dShow, 'o');
set(p, 'markersize', 20);


% Draw lines on image
figure(3);
imshow(smooth);
hold on; %to keep image

sizeImg = length(img(:));

for i = 1:length(t)
    if (t(i) == min(t(:))) %draw vertical lines
        x = d(i);
        y0 = 1;
        y1 = sizeImg;
        plot([x,x],[y0,y1]);
        
    elseif (t(i) == max(t(:))) %draw horizontal lines
        x0 = 1;
        x1 = sizeImg;
        y = d(i);
        plot([x0,x1],[y,y]);
    
    else        %draw diagonals
        x0 = 1;
        x1 = sizeImg;
        y0 = (x0*cos(t(i)) - d(i))/sin(t(i));
        y1 = (x1*cos(t(i)) - d(i))/sin(t(i));
        
        plot([y0,y1],[x0,x1]);
    end
end





