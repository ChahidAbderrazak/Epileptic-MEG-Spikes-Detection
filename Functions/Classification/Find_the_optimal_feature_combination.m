%% Find the optimal combination of the features in the data_file 
% feature_TAG='h1'        % features TAG to be combined
% K=5; 
% folds 
%%   Excel file
% feature_type='Optimal_combinaison_SCSA_features';
% root_folder='./Feature_Selection/';

function [SCSA_X_op,op_comb,op_comb_name, perform_output,SCSA_parameters_op]=Find_the_optimal_feature_combination(data_file,feature_TAG,K,CV_type,type_clf)
global  h filename root_folder Normalization

load(data_file)
% feature_TAG='h1'        % features TAG to be combined
% K=5; 
% folds 
%%   Excel file
% feature_type='Optimal_combinaison_SCSA_features';
% root_folder='./Feature_Selection/';

%% Collect the existing features
Name_vars=who;
cnt=1;

%% Get the name of variables related to the specific variable
for k=1:size(feature_TAG,2)
    
    Feature_var=strfind(Name_vars,feature_TAG{k} );    
    
    if k==1
        Idx=find(~cellfun(@isempty, Feature_var));
    else 
        Idx=[Idx;find(~cellfun(@isempty, Feature_var))];
    end
end


name_features=Name_vars(Idx);

    
cnt=0;
cnt0=0;Acc_max=0;SCSA_X_op=[];
d=1;
Z=max(size(name_features));
combined_features='';
%% list the existing feaetures
Existing_features = 1:Z;

%% try combinaisons with incremetatl size from 1 to all features
for sz_combinaison=1:Z

    new_combinaison = nchoosek(Existing_features,uint16(sz_combinaison));

    %% Build the features matrix for classification 
    for k_sz=1:size(new_combinaison,1)

        Used_combinaison=new_combinaison(k_sz,:); %Existing_features; % 
        combined_features='';Combine_features_names='';

        for z=Used_combinaison
          combined_features=strcat(combined_features,',',name_features{z});
          feature_n=char(name_features(z));
          Combine_features_names=strcat(Combine_features_names,',',feature_n);
        end
        
        Combined_TR_names=strcat('[',combined_features(2:end),'];');

        eval(strcat('X=',Combined_TR_names));

        %% Run the classifer 
        cnt0=cnt0+1;
%         [accuracy,accuracy_avg,sensitivity_avg,specificity_avg,precision_avg,gmean_avg,f1score_avg]=K_Fold_CrossValidation(X, y, K, clf);starplus='';
        [accuracy,accuracy_avg,sensitivity_avg,specificity_avg,precision_avg,gmean_avg,f1score_avg,Avg_AUC]=Data_CrossValidation(X, y,CV_type, K,type_clf);


        V_com(Used_combinaison)=1; Hex_com(cnt0)=bi2de(V_com);
        Output_results(cnt0,:)=[h, mean(Nh_all) ,Normalization,sz_combinaison, Hex_com(cnt0),size(X,2), accuracy_avg,sensitivity_avg,specificity_avg,precision_avg,gmean_avg,f1score_avg,Avg_AUC];
        Output_Combinaisons{cnt0}=Combine_features_names(2:end);
        Dataset_k{cnt0}=filename;
        Classifier{cnt0}=type_clf;


        if Acc_max<accuracy_avg || (Acc_max==accuracy_avg & size(X,2)<size(SCSA_X_op,2))
            Combinaison_star=Combine_features_names(2:end);
            Hex_com_star=Hex_com(cnt0);
            Acc_max=accuracy_avg;
            SCSA_X_op=X;
        end

        clear  X_data   Data  Used_combinaison combined_features Combine_TS_names Combine_features_names  V_com

%          % save the results
%         save(strcat(root_folder,'/Optimal_combinaison_all.mat'),'Output_results','Output_Combinaisons','Combinaison_star','Hex_com_star','SCSA_X_op','Acc_max' )

    end                       
end      



%% Add the last results
         
colnames={'h','Mean_Nh','norm','Number_SCSA_features','Selected_Features','Vector_Size','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score0','AUC'};
perform_output= array2table(Output_results, 'VariableNames',colnames);
perform_output.Combination = Output_Combinaisons' ;

Output_Combinaisons=Output_Combinaisons';

%% Find the optimal combination 
perform_output_Mtr=table2array(perform_output(:,1:end-1));
Acc=perform_output.Accuracy;
N_f=perform_output.Vector_Size;

Idx=find(Acc==max(Acc));
Idx=Idx(find(N_f(Idx)==min(N_f(Idx))));

%% Get the optimal accuracy 
perform_output.Dataset=Dataset_k';
perform_output.Classifier=Classifier';

if max(size(Idx))>1
    Idx=Idx(1);   
end
    
    


op_comb=perform_output(Idx,:);
op_comb_name=Output_Combinaisons(Idx);

SCSA_parameters_op=max(perform_output.Accuracy);


