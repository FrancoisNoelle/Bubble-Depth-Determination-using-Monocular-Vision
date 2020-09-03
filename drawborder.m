function border = drawborder(A,B,L)
figure
imagesc(A)
hold on
for k=1:max(L(:))
    border=B{k};
    plot(border(:,2), border(:,1),'r')
end