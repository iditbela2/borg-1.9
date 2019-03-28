%% Ploting
function Makeplots (VarsAndSourceAccuSort, dimsource,RealSource,NumActive,fig2string,fig3string,fig4string)
figure; hold on; degel=zeros(9,1);
for j=1:size(VarsAndSourceAccuSort,1)
    if VarsAndSourceAccuSort(j,dimsource)==NumActive
        c=[rand() rand() rand()];
        scatter(RealSource, VarsAndSourceAccuSort(j,dimsource+1:end),[],c); %drawnow
        ylabel({'Calculated source flow, Kg/second'},'FontSize',12);xlabel({'Actual source flow, Kg/second'},'FontSize',12);
        title([num2str(NumActive) 'Source']); hold on;
        savefig(fig2string)
        %     elseif VarsAndSourceAccuSort(j,dimsource)==required_plots(2)
        %         if degel(required_plots(2))==0
        %         figure; hold on;
        %         degel(required_plots(2))=2;
        %         end
        %          c=[rand() rand() rand()];
        %        scatter(RealSource, VarsAndSourceAccuSort(j,4:end),[],c);  %drawnow
        %         title([num2str(required_plots(2)) 'Source']); hold on;
        %          ylabel({'Calculated source flow, Kg/second'},'FontSize',12);xlabel({'Actual source flow, Kg/second'},'FontSize',12);
        %         savefig(fig3string)
        %     elseif VarsAndSourceAccuSort(j,dimsource)==required_plots(3)
        %          if degel(required_plots(3))==0
        %         figure; hold on;
        %         degel(required_plots(3))=3;
        %         end
        %         c=[rand() rand() rand()];
        %          scatter(RealSource, VarsAndSourceAccuSort(j,4:end),[],c);  %drawnow
        %         title([num2str(required_plots(3)) 'Source']); hold on;
        %          ylabel({'Calculated source flow, Kg/second'},'FontSize',12);xlabel({'Actual source flow, Kg/second'},'FontSize',12);
        %         savefig(fig4string)
    end
end


end




