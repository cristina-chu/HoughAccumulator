%Cristina Chu
%Part 1

img = imread('ps1-input0.png');

%----Trying different edge detection-----%

% 1. Sobel
BW1 = edge(img,'sobel',.2);
figure(1)
imshow(BW1);

% 2. Prewitt
BW2 = edge(img,'prewitt',.2);
figure(2)
imshow(BW2);

% 3. Roberts
BW3 = edge(img,'roberts',.3);
figure(3)
imshow(BW3);

% 4. Log
BW4 = edge(img,'log',.02);
figure(4)
imshow(BW4);

% 5. Canny
BW5 = edge(img,'canny',.59);
figure(5)
imshow(BW5);

%Sobel, Prewitr work pretty well, some intersection points are missing
%Roberts and Canny are the best in getting good edges 
%Log is the least accurate
imwrite(BW5,'ps1-1-edge.png');