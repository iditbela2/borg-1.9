function [] = idit_plotDispersionMap(field, lw, boundery)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
figure 
[~,c] = contour(field,'ShowText','on');
c.LineWidth = lw;
set(gca,'XTick',0:5:boundery/10,'XTickLabel',0:50:boundery)
set(gca,'YTick',0:5:boundery/10,'YTickLabel',0:50:boundery)
colorbar
hold on
plot(meshgrid(0:1:boundery/10,0:1:boundery/10),'k+','MarkerSize',0.5)
end

