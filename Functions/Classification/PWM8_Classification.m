 
%% ###############   Epileptic Spikes Detection 2019  ############################
% This script applies classification using Position Weight Matrices (PWM)

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Jan,  2019
%
%% ###########################################################################
clearvars Output_results  Accuracy_av perform_output Accuracy_all Classifier
global Levels Level_intervals

%% Classifier 
feature_type='PWM8_';

%% List of parameteres
%     list_M=2*[2:4];
%     list_k=[0.1:0.2:1.2]; 
    N_M=max(size(list_M));N_k=max(size(list_k));k=0;

    
%% #########################   Display   ################################
fprintf('\n --> Run CV  classification using : ');
d_data0=string(strcat(feature_type(1:end-1),'-based Features'));
fprintf(' %s\n ',d_data0);


%% Get the statistical properties of the data
    [Xsp,Xsp0]=Split_classes_samples(X,y);

    Xsp_pd = fitdist(Xsp(:),'Normal');
    Xsp0_pd = fitdist(Xsp0(:),'Normal');

%% GEt the noral distibution for each subject
    Xsp_Sigma=Xsp_pd.sigma;     Xsp0_Sigma=Xsp0_pd.sigma;     
    Xsp_mu=Xsp_pd.mu;           Xsp0_mu=Xsp0_pd.mu;           
        

%% Script Starts
    cntm=1;Acc_op=0;cnt_inc=0;
    
for M= list_M                % Number of levels

    cnt = 1;
    list_k=1.5/M*[1 1.5];

    for k=list_k

%% get the notmal Distribution N(mu0, sigma0)
        mu0=mean([Xsp_mu, Xsp0_mu]);  sigma0=mean([Xsp_Sigma, Xsp0_Sigma]);
        [Levels, Level_intervals]=Set_levels_Sigma(k,M,mu0,sigma0);
        d=1;


%% Cross-Validation
        subject=1;
        tic
%         [Accuracy,sz_fPWM]=Classify_LeaveOut_PWM(X,y,type_clf);starplus='StarPlus';
        [sz_fPWM, Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC]=PWM8_Data_CrossValidation(X, y,CV_type, K,type_clf);
        exec_time=toc;
        
   %% get the LOO performance
        Accuracy_all(cntm,cnt,subject)=Accuracy
        resolution=k*sigma0;

        cnt_inc=cnt_inc+1;Output_results(cnt_inc,:)=[M,mu0,sigma0,k,resolution,sz_fPWM,Accuracy,exec_time];
        Classifier{cnt_inc}=type_clf;
        
        % Get the best accuracy 
        if Acc_op<Accuracy
            PWM_op_results=[M,mu0,sigma0,k,resolution,sz_fPWM,Accuracy,exec_time];
            Acc_op=Accuracy;
            
            % {'Vector_Size','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score'};
            CV_results_op=[sz_fPWM, Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC];

            %{'Dataset','Configuration','size','L','step','Method','parameters','CV','K','Classifier'}
            CV_config_op={noisy_file,num2str(Conf_Elctr), num2str(size(X,1)),num2str(L_max),num2str(Frame_Step),feature_type(1:end-1), strcat('M=',num2str(M),', k=',num2str(k)),CV_type,num2str(K),type_clf };
 
        end
        
        
        cnt=cnt+1;

    end
    
%     Accuracy_av(cntm,:)=mean(Accuracy_all(:,:,cntm));
    cntm=cntm+1;
    d=1;
end


%% Plot the Accuracy VS levels 
    figr=30;Plot_Levels_VS_Accuracy_avg(list_k,list_M,Accuracy_all,figr)
     
%% Add the  results to a table
    colnames={'M','mu','sigma0','k','resolution','Vector_Size','Accuracy','Time'};
    perform_output= array2table(Output_results, 'VariableNames',colnames);
    perform_output.Classifier=Classifier';

%     perform_output
%     Acc_op
%% Save the PWM classification results
    pwm_param=strcat('_sigma1_k',num2str(N_k),'_M_',num2str(N_M));
    feature_TAG=pwm_param;        % features TAG
    
    save(strcat('./Classification_results/',feature_type,pwm_param,noisy_file,suff,'_norm',num2str(Normalization),'_',CV_type,'_',type_clf,'_Acc',num2str(Acc_op),'.mat'),'pwm_param','feature_TAG','perform_output', 'noisy_file','*_all','list_*','*pd','mu0','sigma0',...
                                                                          'PWM_op_results','Xs*','X','y','L_max','noisy_file','suff','filename')                                                                                                                    


                                                                      
                                                                      
                                                                      
%% Get the best results of PWM8
   colnames_results={'Vector_Size','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score','AUC'};
   Comp_performance_Table= array2table(CV_results_op, 'VariableNames',colnames_results);
    
   colnames_results={'Dataset','Configuration','size','L','step','Method','parameters','CV','K','Classifier'};
   Comp_config_Table= array2table(CV_config_op, 'VariableNames',colnames_results);
    
   % Add the optimal parameters
   Comp_results_Table=[Comp_results_Table; [Comp_config_Table ,Comp_performance_Table]];
   
% % {'Vector_Size','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score'};
% CV_results_op=[sz_fPWM, Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score];
% 
% %{'Dataset','Configuration','size','L','step','Method','parameters','CV','K','Classifier'}
% CV_config_op={noisy_file,num2str(Conf_Elctr), num2str(size(X,1)),num2str(L_max),num2str(Frame_Step),feature_type(1:end-1), strcat('M=',num2str(M),', k=',num2str(k)),CV_type,num2str(K),type_clf };
 