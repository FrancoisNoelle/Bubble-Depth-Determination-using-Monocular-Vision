function polex = getpole(I)
% written by Francois Noelle for bubble depth analysis.
% Determines pole location from binary image.
% Description of inputs
% I must be a binary image
%Description of outputs
%Finds the x cordinates of the pole edges
[y x] = size(I);
count = 0;
polex = [];
for k = 1:x %Loop through x coordinate
    length = sum(I(:,k));  % Sum each x coordinate, therefore its is crucial
    %the calibration rod is as straight as possible
    if length > size(I,1)/4 %This is the tolerance
        count = count +1;
        pole(count) = k;
    end
end
polex(1) = min(pole); %rod coordinate furthest left
polex(2) = max(pole); %rod coordinate furthest right
if size(polex)~=2
    disp('pole not found correctly, adjust tolerance')
end


