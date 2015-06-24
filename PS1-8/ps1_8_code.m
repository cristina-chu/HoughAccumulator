%Cristina Chu

%Part 8
img = imread('ps1-input2.jpg');
temp = rgb2gray(img);

%-----a.Smooth-----%
kernel = fspecial('gaussian', 7, 5);
smooth = imfilter(temp, kernel,'replicate');

%imshow(smooth);

%-----b.Find Edges-----%
edgeSmooth = edge(smooth, 'canny', .5);


%-----c.Find Circles-----%
%Get parameters (edge points, radii, theta)
[x,y] = find(edgeSmooth == 1);
theta = 0.0:pi/100:2*pi;
r = 17:45;

%r = 22, 24, 21, 40, 26

s1 = max(x)+100;  %size for x
s2 = max(y)+100;  %size for y
s3 = 30;

array = zeros(s1, s2, s3);

%-Loop
for i = 1:length(x)
    for j = 17:45
        for t = theta
            x0 = ceil(x(i) + j*cos(t));
            y0 = ceil(y(i) + j*sin(t));
            array(x0+44,y0+44,j-16) = array(x0+44,y0+44,j-16) + 1;
        end
    end
end


%-Find values of (d,t) that max array(d,t)
index1 = find(array>max(array(:))-35);
[xNew, yNew, rNew] = ind2sub(size(array),index1);
x = xNew-44;
y = yNew-44;
r = rNew+16;


%making Hough transform visual
toShow = uint8(array*265/max(array(:)));
index2 = find(toShow>max(toShow(:))-60);

[xShow, yShow, rShow] = ind2sub(size(array),index2);

imshow(img);
hold on;    %to keep image and draw on top
for circle = 1:length(x)
    xunit = x(circle);
    yunit = y(circle);
    h = plot(yunit, xunit, 'o');
    set(h, 'markersize', 2*r(circle));
end
hold off;




        

