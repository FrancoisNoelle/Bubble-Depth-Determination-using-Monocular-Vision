function [Bubble,NumofAnalysedB,Depth] = bubDepthdet(B, L, A,calib,maxB)
%bubEdgeAnalysis uses information from bubble boundaries to preform 
%a blur quantification. The method used preforms a edge derivitive in two
%diagonal directions, by "cutting" it along its boundary.

% DESCRIPTION OF INPUTS:
%B:X and Y coordinates of of bubble boundaries
%L:Matrix that contains the location of bubble pixels in terms of
%non-negatice integers.
%A:Grey-scale image of bubbles.
% DESCRIPTION OF OUTPUTS:
%bubgrad: contains the average maximum gradient of the bubble edge. A
%linear derivative is preformed for each pixel of the edge.
%stdbub: The standard deviation of each bubble edge 
%
% Written by Francois Noelle 

NumofAnalysedB=0;
circularity = iscircle(B, L);
for k = 1:max(L(:))
    xoutBounds = 0;
    youtBounds = 0;
    lcount = 0;
    rcount = 0;
    count = 0;
    total = 0;
border = B{k};
[r c] = size(border);
range = 6;
bubbot = max(border(1,:));
Bubtop = min(border(:,1));

if bubbot < 1400 && Bubtop>50 && circularity(k)>0.4
for i=1:r
    %Diagonal Going to Right side of Bubble
  rDtopLiney = border(i, 1)-range;
  rDtopLinex = border(i, 2)+range;
  rDbotLiney = border(i, 1)+range;
  rDbotlinex = border(i, 2)-range;
  Lx=linspace(rDtopLinex,rDbotlinex,range*2+1);
  Ly=linspace(rDtopLiney,rDbotLiney,range*2+1); 
  if max(Lx)>1200 || min(Lx)<0 || min(Lx)==0
      xoutBounds = 1;
  end
  if max(Ly)>1600 || min(Ly)<0 || min(Ly)==0
      youtBounds = 1;
  end
  if xoutBounds==0 &&  youtBounds==0
            for j=1:(range*2+1)
            Imline(j)=A(Ly(j),Lx(j));
            end
            rcount = rcount+1;
       rBubDeriv(i) = max(imgradient(Imline, 'central'));
  else
       rBubDeriv(i) = 0;
  end
  %Diagonal Going to Left side of Bubble
        lDtopLiney = border(i, 1)-range;
        lDtopLinex = border(i, 2)-range;
        lDbotLiney = border(i, 1)+range;
        lDbotlinex = border(i, 2)+range;
        Lx=linspace(lDtopLinex,lDbotlinex,range*2+1);
        Ly=linspace(lDtopLiney,lDbotLiney,range*2+1); 
  if max(Lx)>1200 || min(Lx)<0
      xoutBounds = 1;
  end
  if max(Ly)>1600 || min(Ly)<0
      youtBounds = 1;
  end
  if xoutBounds==0 &&  youtBounds==0
        for j=1:(range*2+1)
            Imline(j)=A(Ly(j),Lx(j));
            
        end
        lcount = lcount+1;
 lBubDeriv(i) = max(imgradient(Imline, 'central'));  
  else
      lBubDeriv(i) = 0;
  end   
  deriv(i) = max(lBubDeriv(i),rBubDeriv(i));
  xoutBounds = 0;
  youtBounds = 0;
end
NumofAnalysedB = NumofAnalysedB+1;

    for t=1:i
        if deriv(t) ~= 0
            total = total + deriv(t);
            count = count +1;
            final(count) = deriv(t);
        end
    end

Bubble(NumofAnalysedB) = total/count;


%stdbub(NumofAnalysedB)=std(final);  
txt = num2str(NumofAnalysedB);
Bubleft = min(border(:,2));
Depth(NumofAnalysedB) = (log((Bubble(NumofAnalysedB)/maxB))-log(calib(1)))/calib(2);
end
end