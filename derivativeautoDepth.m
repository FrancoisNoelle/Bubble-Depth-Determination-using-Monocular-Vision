function [bubgrad,NrBubs,Depth]=derivativeautoDepth(A,thresh,bubsize_range,calib,maxB)
%% Uses Matlabs image toolbox
%% Default inputs
medf_background=17;%5
inc_background=3;%5
joinpixels=2; %5
medf=3;%17 works for close bubbles
%maby add a chek to see if calibration is proper             
%% Section 1: highlight bubbles (subtract background)
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
underlying_shape=interp2(xxs,yys,double(Bsmed),xx,yy,'linear'); %maby rather use ref image
B=underlying_shape-B;
B(B<0)=0;
bvec=B(:);
bvec=bvec(~isnan(bvec));
B=(B-mean(bvec))/(std(bvec)); % normalise


%% make bw image and detection
bw=B>thresh;
%bw=medfilt2(bw,[medf,medf]);
bw=imdilate(bw,strel('disk',joinpixels)); 
bw=imerode(bw,strel('disk',3)); 
bwh= imfill(bw,'holes');
bwh = medfilt2(bwh, [21, 21]);
bwh = bwareaopen(bwh, bubsize_range(1));
[GLb,Lb] = bwboundaries(bwh,'noholes');
%drawborder(A, GLb, Lb)

%% Bubble depth determination 
[bubgrad, NrBubs,Depth]=bubDepthdet(GLb, Lb, Aref,calib,maxB);