%Cristina Chu
%Part 3

%----Hough method for finding lines----%

%-Initialize accumulator array
%-Getting edge image from input
img = imread('ps1-input0a.png');
BW = edge(img,'canny');

%-Get points and angles
[x,y]=find(BW == 1);

t = 0.0:pi/1000:pi;

%-Create array 
%sizes for array
size1 = ceil(length(img)*sqrt(2)*2);    %max diagonal*2 for size of d
val = 320;          %extra value to deal with out of index problems
size2 = ceil(max(t(:))*val);    %maximun value of t

%array with all zeros
array = zeros(size1, size2+1);


%% Loop (voting)
for d = 1:length(x)
    for t1 = t
        dist = uint16((x(d)*cos(t1) - y(d)*sin(t1))+400);
        t0 = uint16(t1*val);
        array(dist, t0+1) = array(dist, t0+1) + 1;
    end
end


%% Find values of (d,t) that max array(d,t)
[dNew, tNew] = find(array>max(array(:))-100);
t = (tNew-1)/val;
d = abs(dNew-400);

% Making Hough transform visual
toShow = uint8(array*265/max(array(:)));
[tShow, dShow] = find(toShow>max(toShow(:))-100);

figure(1);
imshow(toShow);

%drawing circles on peaks
hold on;    %to keep image and draw on top
p = plot(dShow, tShow, 'o');
set(p, 'markersize', 20);
hold off;

%% Draw lines on image
figure(2);
imshow(img);
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
        
    else %draw diagonal lines
        x0 = 1;
        x1 = sizeImg;
        
        %y0 = - d(i)/sin(t(i));
        %y1 = (x1*cos(t(i)) - d(i))/sin(t(i));
        
        y0 = (x0*cos(t(i)) + d(i))/sin(t(i));
        y1 = (x1*cos(t(i)) + d(i))/sin(t(i));
        plot([y0, y1],[x0,x1]);

    end
end




