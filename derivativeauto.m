function [bubgrad, NrBubs]=derivativeauto(A,thresh,bubsize_range)
%DERIVATIVEAUTO segments bubbles such that their boundaries can be
%analysed, then analyses the bubble boudaries and determines their
%intensity gradient.
%DESCRIPTION OF INPUTS
%A: Must be a greyscale image of bubbles
%Thresh: Threshold for bubbles, depends on image properties
%bubsize_range: Maximum and minimum bubble sizes, filter out too small or
%large bubbles
%DESCRIPTION OF OUTPUTS
%Bubgrad: Intensity gradient of the various bubbles within image
%NrBubs: The number of bubbles that have been analysed within image

%written by Francois Noelle
%% Uses Matlabs image toolbox
%% Image Segmentation parameters
medf_background=17;
inc_background=3;
joinpixels=2;

%% Converting Image for Processing And Remove Salt/Pepper Noise
A=double(A);
Aref=A;
A = medfilt2(A,[3,3]);


%% get background
B=A;
[bb,aa]=size(B);
linxs=round(linspace(1,aa,round(aa/inc_background)));
linys=round(linspace(1,bb,round(bb/inc_background)));
[xxs,yys]=meshgrid(linxs,linys);
Bs=B(linys,linxs);
Bsmed=medfilt2(Bs,[medf_background,medf_background]);

linx=1:aa;
liny=1:bb;
[xx,yy]=meshgrid(linx,liny);
underlying_shape=interp2(xxs,yys,double(Bsmed),xx,yy,'linear');
%% Accentuating Edges
B=underlying_shape-B;
B(B<0)=0;
bvec=B(:);
bvec=bvec(~isnan(bvec));
B=(B-mean(bvec))/(std(bvec)); % normalise image


%% Convert to a binary image and determine bubble boundaries
bw=B>thresh;
bw=imdilate(bw,strel('disk',joinpixels));
bw=imerode(bw,strel('disk',3));
bwh= imfill(bw,'holes');
bwh = medfilt2(bwh, [21, 21]);
bwh = bwareaopen(bwh, bubsize_range(1)); % Removing objects that are too small
[GLb,Lb] = bwboundaries(bwh,'noholes'); % Allows for each detected bubble to be analysed separately


%% Bubble depth determination
[bubgrad,NrBubs]=bubEdgeAnalysis(GLb, Lb, Aref);
x = 1;