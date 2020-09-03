function [trend, scale,gradmag,stdpole] = detrodgrad(A, coord)
%DETRODGRAD determines the maximum gradient or derivitave of the pole
%across its entire length. The gradient is found at the poles deepest
%positions first (top of image). It is important that the pole is placed at
%the max and min y position of the image.
%DESCRIPTION OF INPUTS
%A: must be UINT8 as given by A = imread('IMAGE5.jpg');A=rgb2gray(A);
%Coord: Are the x coordinates of the pole edges, may only be 2 values
%DESCRIPTION OF OUTPUTS
%Displays an image where each line on the pole represents where the average
%derivative was found for that section of 1 cm depth
%rodgrad: The intensity gradient of the pole with depth or the values to
%which the curve is fit. Explained in paper calibration procedure
%stdpole: The standard deviation of each intensity gradient
%scale: mm/pixel at zero depth

%written by Francois Noelle
[r c] = size(A); %Determine image dimensions
range = 20; %Range across which the intensity gradeint is found
actualpolewidth = 8; %Required for scale calculation [mm]
polepixelwidth = coord(2)-coord(1); %Pole width in terms of pixels
scale = actualpolewidth/polepixelwidth; %Determining scale, mm/pixel
tankDepth = 15; %The depth of the BCR, this needs to be adjusted depending
%on application (Key Parameter!!)

pixelforcmdepth =round(r/tankDepth); %number of pixels along
%y axis at which the pole is at a 1 cm depth
%This is also a Key Parameter!! Can improve the resolution of the
%calibration by adjusting this value. 

count = 1;
count2 = 1;
count3 = 15;
count4 = 1;
gradmag = [];
totgrad = 0;
stdpole = [];
imagesc(A)
hold on
%% Determining Intensity gradient as a function of depth
for i=1:r
    grad(i) = max(imgradient(A(i,(coord(1)-range):(coord(2)+range)), 'central')); %Determining Intensity gradeint across range
    count = count + 1;
    if count ==pixelforcmdepth % Only a single value is stored 
        stdpole(count3) = std(grad(count2:i));
        line([(coord(1)-range), (coord(2)+range)],[i, i]) %For display purposes only
        outlier = isoutlier(grad(count2:i), 'quartile');
        for k=1:(i-count2)
            if outlier(k) == 0
                totgrad = totgrad + grad(k+count2);%totgrad = sum(grad(count2:i));
                count4 = count4+1;
            end
        end
        gradmag(count3) = totgrad/count4;
        totgrad=0;
        count = 1;
        count4 = 1;
        count2 = count2+pixelforcmdepth;
        count3 = count3-1; %since it starts at the deepest position
    end
end
x = 1:1:tankDepth; %This depends on pixelforcmdepth / calibration resolution

% Gradient magnitude vector and normalisation as explained in paper
gradmagNorm = gradmag/max(gradmag);

%% Calibration co-efficients determination
p = fit(x',gradmagNorm','exp1');
p = coeffvalues(p);
trend = p;
hold off
end

