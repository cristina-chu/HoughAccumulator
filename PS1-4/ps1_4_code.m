%Cristina chu

%Part 4

img = imread('ps1-input0-noise.png');

%% ----a.Smooth image------%
kernel = fspecial('gaussian', 25,6); %15,5
smooth = imfilter(img, kernel);

imwrite(smooth, 'ps1-4-a-output0-smoothed.png');

%% ----b.Edge image----%
edgeOriginal = edge(img,'canny',.59); 
edgeSmooth = edge(smooth,'canny',.5);

imwrite(edgeOriginal, 'ps1-4-b-output0-edgeOriginal.png');
imwrite(edgeSmooth, 'ps1-4-b-output1-edgeSmooth.png');

imshow(edgeSmooth);

%% -----c.Apply Hough method-----%
img = smooth;
BW = edgeSmooth;

%-Get points and angles
[x,y]=find(BW == 1);

t = 0.0:pi/1000:pi;


%-Create array 
%sizes for array
size1 = 700;    %max diagonal*2 for size of d
size2 = ceil(max(t(:))*200);  %maximun value of t

%array with all zeros
array = zeros(size1, size2+1);


%-Loop (voting)
for d = 1:length(x)
    for t1 = t
        dist = uint16((x(d)*cos(t1) - y(d)*sin(t1))+400);
        t0 = uint16(t1*200);
        array(dist, t0+1) = array(dist, t0+1) + 1;
    end
end

%-Find values of (d,t) that max array(d,t)
[dNew, tNew] = find(array>max(array(:))-120); 
t = (tNew-1)/200;
d = abs(dNew-400);

%making Hough transform visual
toShow = uint8(array*265/max(array(:)));
[tShow, dShow] = find(toShow>max(toShow(:))-120); 

figure(1);
imshow(toShow);

hold on;    %to keep image and draw on top
p = plot(dShow, tShow, 'o');
set(p, 'markersize', 20);
hold off;

%-Draw lines on image
figure(2);
imshow(img);
hold on; %to keep image

sizeImg = length(img(:));

for i = 1:length(t)
    if (t(i) == min(t(:))) %draw vertical lines
        x = d(i);
        y0 = 1;
        y1 = sizeImg;
        plot([x,x],[y0,y1],'LineWidth',2);
        
    elseif (t(i) == max(t(:))) %draw horizontal lines
        x0 = 1;
        x1 = sizeImg;
        y = d(i);
        plot([x0,x1],[y,y],'LineWidth',2);
        
    else %draw diagonal lines
        x0 = 1;
        x1 = sizeImg;
        y0 = -d(i)/sin(t(i));
        y1 = x1*cos(t(i)) - d(i)*sin(t(i));
        plot([x0,x1],[y0,y1],'LineWidth',2);
    end
end
