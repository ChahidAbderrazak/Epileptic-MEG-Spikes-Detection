 
%% #######   Extract patterns from input discrete sequence  ###################
% This script transfor the input sequences into sifferent ptterns depending 
% on the pattern of each level in each sequence amoung the positive samples <Seq_pos> 
% and the negative samples <Seq_neg>

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Jan ,  2019
%
%% ###########################################################################

function  [Seq_letters, Seq_Pattern_pos,Seq_Pattern_neg]=Extract_patterns_from_Sequences(Seq_pos, Seq_neg)
fprintf('______________________________________________________________________________\n');
fprintf('            Pattern-Extraction from Input Sequences  (KAUST 2019)    \n');
fprintf('______________________________________________________________________________\n\n');


%% Extract the patterns as diracs  {0,1}
figr=1; 
[levels_p,Seq_Pattern_pos]=Get_letters_patern(Seq_pos);
[levels_n,Seq_Pattern_neg]=Get_letters_patern(Seq_neg);

if sum(abs(levels_p-levels_n))==0

    % Assign to each level a letter
    Seq_letters=char([65:90 97:122  char(194:194+levels_p-52) ]); N_letters=size(Seq_letters,2); %   or Seq_letters='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'    
    
    for k=1:max(size(levels_p))

        pos_Dirac_Seq_k=Seq_Pattern_pos(:,:,k);
        neg_Dirac_Seq_k=Seq_Pattern_neg(:,:,k);

        %% Check the weigths of each dirac
        [N,M]=size(pos_Dirac_Seq_k);W_pos=100*sum(pos_Dirac_Seq_k,1)/N ;
        [N,M]=size(neg_Dirac_Seq_k);W_neg=100*sum(neg_Dirac_Seq_k,1)/N ;


            %% TOP 0
        eval([strcat('idx0',Seq_letters(k),'=find(W_neg==0 | W_pos==0 );')])
        eval([strcat('idx=idx0',Seq_letters(k),';')])
        pos_0=pos_Dirac_Seq_k(:,idx);
        neg_0=neg_Dirac_Seq_k(:,idx);
        eval([strcat('P_TOP0_features',Seq_letters(k),'=[pos_0 ; neg_0];')]);

        %% TOP 100
        eval([strcat('idx0',Seq_letters(k),'=find(W_neg==100 | W_pos==100 );')])
        eval([strcat('idx=idx0',Seq_letters(k),';')]);

        pos_100=pos_Dirac_Seq_k(:,idx);
        neg_100=neg_Dirac_Seq_k(:,idx);
        eval([strcat('P_TOP100_features',Seq_letters(k),'=[pos_100 ; neg_100];')]);

        %% THE ERROR 
        W_err= abs(W_neg-W_pos);
        W_err_sm = smooth(1:M,W_err,0.1,'rloess');


        figr=figr+1;
        lgnd{1}=strcat('S^+_',Seq_letters(k));lgnd{2}=strcat('S^-_',Seq_letters(k));

        plot_pattern_error_PN(figr, W_pos, W_neg, W_err, W_err_sm, lgnd)

        %% Apply the thresolds

        eval([strcat('P_Dirac_features',Seq_letters(k),'=[pos_Dirac_Seq_k ; neg_Dirac_Seq_k];')]);

    end

end
[Np,Mp]=size(pos_Dirac_Seq_k);
Target_p=ones(Np,1);
[Nn,Mn]=size(neg_Dirac_Seq_k);
Target_n=zeros(Nn,1);
Target_bit=[Target_p ;Target_n];



% %% #################   Build the features    ########################
% %% Top positions
% P_features_TOP100=[P_TOP100_featuresA P_TOP100_featuresT P_TOP100_featuresC P_TOP100_featuresG  Target_bit];
% P_features_TOP0=[P_TOP0_featuresA P_TOP0_featuresT P_TOP0_featuresC P_TOP0_featuresG  Target_bit];
% P_features_TOP0_100=[P_features_TOP100(:,1:end-1)  P_features_TOP0];
% %% Pattern diracs features
% P_featuresA= [P_Dirac_featuresA Target_bit];
% P_featuresT= [P_Dirac_featuresT Target_bit];
% P_featuresC= [P_Dirac_featuresC Target_bit];
% P_featuresG= [P_Dirac_featuresG Target_bit];
% 
% %%  P with top
% 
% P_featuresA_TOP0=[P_featuresA(:,1:end-1)  P_features_TOP0];
% 
% 
% 
% %%
% P_features_AT=[P_Dirac_featuresA P_Dirac_featuresT   Target_bit];
% % P_features_AC=[P_Dirac_featuresA  P_Dirac_featuresC  Target_bit];
% % P_features_AG=[P_Dirac_featuresA   P_Dirac_featuresG Target_bit];
% % P_features_TC=[P_Dirac_featuresT P_Dirac_featuresC  Target_bit];
% % P_features_TG=[P_Dirac_featuresT  P_Dirac_featuresG Target_bit];
% % P_features_CG=[P_Dirac_featuresC P_Dirac_featuresG Target_bit];
% % P_features_ATC=[P_Dirac_featuresA P_Dirac_featuresT P_Dirac_featuresC  Target_bit];
% % P_features_ATG=[P_Dirac_featuresA P_Dirac_featuresT  P_Dirac_featuresG Target_bit];
% % P_features_ACG=[P_Dirac_featuresA  P_Dirac_featuresC P_Dirac_featuresG Target_bit];
% % P_features_TCG=[P_Dirac_featuresT P_Dirac_featuresC P_Dirac_featuresG Target_bit];
% % P_features_ATCG=[P_Dirac_featuresA P_Dirac_featuresT P_Dirac_featuresC P_Dirac_featuresG Target_bit];
% % P_features_ATCG_TOP0_100=[P_features_ATCG(:,1:end-1)  P_features_TOP0_100];
% % P_features_A_TOP0_100=[P_featuresA(:,1:end-1)  P_features_TOP0_100];
% P_features_AT_TOP0_100=[P_features_AT(:,1:end-1)  P_features_TOP0_100];
% 
% 
% 
% 



function [levels, Seq_data_out]=Get_letters_patern(Seq_data)

levels=double(unique(Seq_data))';

N_letters=size(levels,2);
for k=1:N_letters
    
    Seq_data_out(:,:,k)=extruct_letters_pattern(Seq_data, levels(k));
    
    d=1;
end


function Seq_data_out=extruct_letters_pattern(Seq_data, nucleotide)

    idxp=find(Seq_data~=nucleotide ); 
    Seq_data(idxp)=0; 
    Seq_data=1.*(Seq_data./max(max((Seq_data))));
   
    for k=1:size(Seq_data,1)
        Seq_data_out(k,:,1)=double(Seq_data(k,:));
    end
    
    
    

function  plot_pattern_error_PN(figr, W_pos, W_neg, W_err, W_err_sm, lgnd)
figure(figr);
    subplot(211);
    plot(W_pos,'LineWidth',2);hold on
    plot(W_neg, 'LineWidth',2);hold off
    A=legend(lgnd);
    A.FontSize=14;
    title(strcat('Extracted  sequence pattern '));
    xlabel('position')
    ylabel(strcat('Necleolide Repeatability '));

    set(gca,'fontsize',16)

    subplot(212);
    plot(W_err, 'LineWidth',2);hold on
    plot(W_err_sm, 'LineWidth',2);hold on
    A=legend('|error|','Smoothed error');
    A.FontSize=14;
    title(strcat('Necleolide Repeatability [difference %] '));
    xlabel('position')
    ylabel('Error Difference %')

    set(gca,'fontsize',16)

    
    
