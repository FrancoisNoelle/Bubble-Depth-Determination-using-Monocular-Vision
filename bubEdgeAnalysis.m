function [Bubble,NumofAnalysedB] = bubEdgeAnalysis(B, L, A)
%bubEdgeAnalysis uses information from bubble boundaries to preform
%a blur quantification. The method used preforms a edge derivitive in two
%diagonal directions, by "cutting" it along its boundary.

% DESCRIPTION OF INPUTS:
%B:X and Y coordinates of of bubble boundaries
%L:Matrix that contains the location of bubble pixels in terms of
%non-negative integers.
%A:Grey-scale image of bubbles.
% DESCRIPTION OF OUTPUTS:
% Bubble: Specific bubble intensity gradient
% NumofAnalysedB: The number of bubbles analysed within image
% Written by Francois Noelle

NumofAnalysedB=0;
circularity = iscircle(B, L); %Determine bubble circularities
for k = 1:max(L(:)) %Step through various bubbles
    xoutBounds = 0;
    youtBounds = 0;
    lcount = 0;
    rcount = 0;
    count = 0;
    total = 0;
    border = B{k};
    [r c] = size(border); %Number of boundary pixels
    range = 6; %Gradient found over this range (Key Parameter!!)
    bubbot = max(border(1,:));
    Bubtop = min(border(:,1));
    
    if bubbot < 1400 && Bubtop>50 && circularity(k)>0.4 %Discard bubbles
        %That arent circular or bubbles that are too close to image
        %boundaries
        
        for i=1:r %Step through boundary pixels
            %% Making one Diagonal
            %Basically finding the two ends of the line
            rDtopLiney = border(i, 1)-range; %Top Coordinate of y
            rDtopLinex = border(i, 2)+range; %Top Coordinate of x
            rDbotLiney = border(i, 1)+range; %Bottom coordinate of y
            rDbotlinex = border(i, 2)-range; %Bottom coordinate of x
            Lx=linspace(rDtopLinex,rDbotlinex,range*2+1);
            Ly=linspace(rDtopLiney,rDbotLiney,range*2+1);
            if max(Lx)>1200 || min(Lx)<0 || min(Lx)==0 %Check if any of the
                %points within diagonal range exceed image x boundaries
                xoutBounds = 1;
            end
            if max(Ly)>1600 || min(Ly)<0 || min(Ly)==0 %Check if any of the
                %points within diagonal range exceed image x boundaries
                youtBounds = 1;
            end
            if xoutBounds==0 &&  youtBounds==0 %If the range does not 
                %exceed image boundaries 
                for j=1:(range*2+1)
                    Imline(j)=A(Ly(j),Lx(j)); %Determine intensity values 
                    %across diagonal range
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
            if (border(i, 1)-range)>0 && (border(i, 1)+range)<1600 % was >1600
            xBubderiv(i)  =  max(imgradient(A(border(i, 1)-range:border(i, 1)+range), 'central'));
            end
             if (border(i, 2)-range)>0 && (border(i, 2)+range)<1200
            yBubderiv(i) =   max(imgradient(A(border(i, 2)-range:border(i, 2)+range), 'central'));
             end
            deriv(i) = max([lBubDeriv(i),rBubDeriv(i),xBubderiv(i),yBubderiv(i)]);
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
        
    end
end

