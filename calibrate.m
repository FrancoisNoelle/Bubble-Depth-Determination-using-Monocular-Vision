function [poleCalibration, scale,rodgrads,rodstd,maxB] = calibrate(A,C,threshB,depth,bubsize_range)
%CALIBRATE determines the blur trend or blur coefficients as described in
%paper. This code also estimates the maximum bubble blur/intensity gradient
%based on the determined calibration trend.
%DESCRIPTION OF INPUTS
%A: Must be a greyscale image of the calibration rod as explained in paper.
%C: Must be a greyscale image of bubbles at a known depth.
%threshB: Threshold specific for the bubbles
%bubsize_range: Maximum and minimum bubble sizes, filter out too small or
%large bubbles
%DESCRIPTION OF OUTPUTS
%rodgrad: Contains the actual inensity gradient information of the
%calibration rod to which the curve is fit.
%scale: The mm/pixel scale at the closest position, or zero depth.
%rodstd: The standard deviation of the calibration rod or rodgrad
%measurements
%maxB: The maximum bubble gradient, which is used to normalise future
%measurements

%written by Francois Noelle

%% Parameters for image segmentation
medf_background=17;
inc_background=3;
thresh=1.3;

%% Image Segmentation for Calibration Rod
A=double(A); % matlab only does maths on doubles
Aref=A; % make a backup of A before we do stuff to it
A = medfilt2(A,[3,3]); % get rid of superficially salt and pepper noise
B = A; % another backup

% create an x y mesh
[bb,aa]=size(B); 
linxs=round(linspace(1,aa,round(aa/inc_background))); 
linys=round(linspace(1,bb,round(bb/inc_background)));
[xxs,yys]=meshgrid(linxs,linys); 
Bs=B(linys,linxs); % B subsampled

Bsmed=medfilt2(Bs,[medf_background,medf_background]);
linx=1:aa;
liny=1:bb;
[xx,yy]=meshgrid(linx,liny);
underlying_shape=interp2(xxs,yys,double(Bsmed),xx,yy,'linear'); 
B=underlying_shape-B; % Accentuate edges within image
B(B<0)=0; 
bvec=B(:);
bvec=bvec(~isnan(bvec));
B=(B-mean(bvec))/(std(bvec)); % normalise image
bw=B>thresh;  % Thresholding
polex = getpole(bw); % Determine x coordinates of calibration rod within image

%% Determining Blur Trend from rod
[poleCalibration, scale,rodgrads,rodstd] =detrodgrad(Aref, polex); 

%% Determining Max Bubble Intensity Gradient for Normalisation Purposes
% get blur as average 
[Bubble, NumB]=derivativeauto(C,threshB,bubsize_range);
Bubble = mean(Bubble);

% Solving for M in eqn 5. M is the maximum bubble gradient.
% Bubble - G in eqn 5
maxB = Bubble/(poleCalibration(1)*(exp(poleCalibration(2)*depth)));
end
