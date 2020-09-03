function [roundness] = iscircle(B, L)
%ISCIRCLE Determines the circularity of detected shapes
% DESCRIPTION OF INPUTS:
%B:X and Y coordinates of of bubble boundaries
%L:Matrix that contains the location of bubble pixels in terms of
%non-negative integers.
% DESCRIPTION OF OUTPUTS:
% Roundness: A metric that defines the circularity of a bubble.
% Adjusted from MATLAB procedure by Francois Noelle
stats = regionprops(L,'Area','Centroid');
for k =1:max(L(:))

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % compute a simple estimate of the object's perimeter
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;
  
  % compute the roundness metric
  metric = 4*pi*area/perimeter^2;
  roundness(k) = metric;
end