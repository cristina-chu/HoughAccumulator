%Cristina Chu

%Part 7

img = imread('ps1-input2.jpg');
img = rgb2gray(img);

% ------a.Finding pens (no worries about other)-------%
%smooth image
kernelPen = fspecial('gaussian', 8,3); %15,5
smoothPen = imfilter(img,kernelPen, 'replicate');

%edge image
edgePen = edge(smoothPen,'canny',.5);

%get points
[x,y] = find(edgePen == 1);
t = 0.0:pi/1000:pi;

%create array 
%sizes for array
size1 = 2000;    
size2 = ceil(max(t(:))*200);  %maximun value of t

%array with all zeros
array = zeros(size1, size2+1);

%-Loop (voting)
for d = 1:length(x)
    for t1 = t
        dist = uint16((x(d)*cos(t1) - y(d)*sin(t1))+800);
        t0 = uint16(t1*200);
        array(dist+1, t0+1) = array(dist+1, t0+1) + 1;
    end
end


%-Find values of (d,t) that max array(d,t)
%making Hough transform visual
toShow = uint8(array*256/max(array(:)));
[dShow, tShow] = find(toShow>max(toShow(:))-125);

t = (tShow-2)/200;
d = (dShow-801);

%----checking hough array-----------------
% figure(2);
% imshow(toShow);
% hold on;    %to keep image and draw on top
% p = plot(tShow, dShow, 'o');
% set(p, 'markersize', 20);
%------------------------------------------

%% -Draw lines on image
imshow(smoothPen);
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


%% ------c.Finding ONLY pens-------%
%Look for nearby parallel lines
sizeImg = length(img(:));
figure(2);
imshow(smoothPen);
hold on; %to keep image

% draw only the ones that have nearby parallel lines
list = [];
for a1 = 1:length(t)
    for a2 = 1:length(t)
        if a1==a2
            continue
        end
        if t(a1) == t(a2)
            list = [list; t(a1), d(a1),; t(a2), d(a2)]; 
        end
    end
end

%list

for l = 1:length(list)
    x0 = 1;
    x1 = sizeImg;

    y0 = (x0*cos(list(l)) + list(1,2))/sin(list(l));
    y1 = (x1*cos(list(l)) + list(1,2))/sin(list(l));

    plot([x0,x1],[y0,y1]);
end





