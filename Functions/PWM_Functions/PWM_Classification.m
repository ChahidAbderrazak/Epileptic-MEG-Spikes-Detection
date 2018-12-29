clearvars Output_results  Accuracy_av perform_output
global Levels Level_intervals

%% List of parameteres
list_M=2*[6 8]; N_M=max(size(list_M));
% list_k=[0.2:0.2:1.6]; N_k=max(size(list_k));k=0;
list_k=[0.8:0.2:1.2]; N_k=max(size(list_k));k=0;

%% Get the statistical properties of the data
[Xsp,Xsp0]=Split_classes_samples(X,y);

Xsp_pd = fitdist(Xsp(:),'Normal');
Xsp0_pd = fitdist(Xsp0(:),'Normal');

%% GEt the noral distibution for each subject

Xsp_Sigma=Xsp_pd.sigma;     Xsp0_Sigma=Xsp0_pd.sigma;     
Xsp_mu=Xsp_pd.mu;           Xsp0_mu=Xsp0_pd.mu;           
        

%% Script Starts
cntm=1;Acc_op=0;
for M= list_M                % Number of levels

    cnt = 1;

    for k=list_k

   %% PWM Leave One Out CV
        % get the notmal Distribution N(mu0, sigma0)
        mu0=mean([Xsp_mu, Xsp0_mu]);  sigma0=mean([Xsp_Sigma, Xsp0_Sigma]);
        [Levels, Level_intervals]=Set_levels_Sigma(k,M,mu0,sigma0);

        % PWM LOO
        subject=1;
        tic
        [Accuracy,sz_fPWM]= Classify_LeaveOut_PWM(X,y,clf);
        exec_time=toc;
        
   %% get the LOO performance
        Accuracy_all(cntm,cnt,subject)=Accuracy;
        
        resolution=k*sigma0;
        Output_results(cnt,:)=[M,mu0,sigma0,k,resolution,sz_fPWM,Accuracy,exec_time];

        if Acc_op<Accuracy
            PWM_op_results=[M,mu0,sigma0,k,resolution,sz_fPWM,Accuracy,exec_time];

        end
        
        
        cnt=cnt+1;

    end
    
%     Accuracy_av(cntm,:)=mean(Accuracy_all(:,:,cntm));
    cntm=cntm+1;
    d=1;

%% Plot the Accuracy VS levels 
    figr=30;Plot_Levels_VS_Accuracy_avg(list_k,Accuracy_all,figr)
     

end

%% Add the  results to a table
colnames={'M','mu','sigma0','k','resolution','Vector_Size','Accuracy','Time'};
perform_output= array2table(Output_results, 'VariableNames',colnames);
perform_output.Classifier=clf;

       
%% Save the PWM classification results
pwm_param=strcat('_sigma1_k',num2str(N_k),'_M_',num2str(N_M));
save(strcat('./Classification_results/',feature_type,pwm_param,suff,'_norm',num2str(Normalization),'_Acc',num2str(Acc_op),'.mat'),'pwm_param','Accuracy_av', '*_all','list_*','Sub*','pd*','mu0','sigma0',...
                                                                      'PWM_op_results','X','y','L_max','EN_L','EN_b','bmin','bmax','suff','filename')                                                       
fprintf('The End \n\n')

