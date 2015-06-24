%Cristina Chu

%Part 8

img = imread('ps1-input3.jpg');
img = rgb2gray(img);

%------------------------------------------------------------
%--------------------Find lines------------------------------
%------------------------------------------------------------
kernel = fspecial('gaussian', 4,3); 
smooth = imfilter(img, kernel, 'replicate');
edgeSmooth = edge(smooth, 'canny', .3);

%transform
BW = edgeSmooth;
[x,y]=find(BW == 1);
t = 0:pi/1000:pi;

%-Create array 
sizeD = 1500; 
sizeT = ceil(max(t(:))*200)+1;  %maximun value of t

array = zeros(sizeD, sizeT);


%-Loop (voting)
for d = 1:length(x)
    for t1 = t
        dist = uint16((x(d)*cos(t1) - y(d)*sin(t1))+800);
        t0 = uint16(t1*200);
        array(dist+1, t0+1) = array(dist+1, t0+1) + 1;
    end
end


%making Hough transform visual
toShow = uint8(array*256/max(array(:)));
[dShow, tShow] = find(toShow>max(toShow(:))-100);

t = (tShow-2)/200;
d = (dShow-801);

figure(1);
imshow(toShow);

hold on;    %to keep image and draw on top
p = plot(tShow, dShow, 'o');
set(p, 'markersize', 20);


%draw lines on image
figure(2);
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


%------------------------------------------------------------
%--------------------Find Circles----------------------------
%------------------------------------------------------------
kernel = fspecial('gaussian', 3,2); 
smooth = imfilter(img, kernel, 'replicate');
edgeSmooth = edge(smooth, 'canny', .3);

%Get parameters (edge points, radii, theta)
[x,y] = find(edgeSmooth == 1);
theta = 0.0:pi/100:2*pi;
r = 45:110;

s1 = max(x)+500;  %size for x
s2 = max(y)+500;  %size for y
s3 = 60;

array = zeros(s1, s2, s3);


%-Loop
for i = 1:length(x)
    for j = 45:100
        for t = theta
            x0 = ceil(x(i) + j*cos(t));
            y0 = ceil(y(i) + j*sin(t));
            array(x0+100,y0+200,j-44) = array(x0+100,y0+200,j-44) + 1;
        end
    end
end


%making Hough transform visual
toShow = uint8(array*265/max(array(:)));
index2 = find(toShow>max(toShow(:))-30);
[xShow, yShow, rShow] = ind2sub(size(array),index2);
x = xShow-100;
y = yShow-200;
r = rShow+44;

for circle = 1:length(x)
    xunit = x(circle);
    yunit = y(circle);
    h = plot(yunit, xunit, 'o');
    set(h, 'markersize', 2*r(circle));
end
