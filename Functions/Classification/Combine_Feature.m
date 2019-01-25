function perform_output=Find_the_optimal_feature_combinaition(data_file,feature_TAG,K, filename)
load(data_file)
% feature_TAG='h1'        % features TAG to be combined
% K=5; 
% folds 
%%   Excel file
% filename='Optimal_combinaison_SCSA_features';
% root_folder='./Feature_Selection/';

%% Collect the existing features
Name_vars=who;
cnt=1;

%% Get the name of variables related to the specific variable
Feature_var=strfind(Name_vars,feature_TAG );
Idx=find(~cellfun(@isempty, Feature_var));
name_features=Name_vars(Idx);

    
cnt=0;
cnt0=0;Acc_max=0;
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

        %% Run the logitic regression 
        cnt0=cnt0+1;
        [accuracy,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=K_Fold_CrossValidation(X, y, K, 'SVM');


        V_com(Used_combinaison)=1; Hex_com(cnt0)=bi2de(V_com);
        Output_results(cnt0,:)=[Hex_com(cnt0),size(X,2), accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]
        Output_Combinaisons{cnt0}=Combine_features_names(2:end);

        if Acc_max<accuracy0
            Combinaison_star=Combine_features_names(2:end);
            Hex_com_star=Hex_com(cnt0);
            Acc_max=accuracy0;
            star_X_data=X;
        end

        clear  X_data   Data  Used_combinaison combined_features Combine_TS_names Combine_features_names  V_com

         %% save the results
%         save(strcat(root_folder,'/Optimal_combinaison_all.mat'),'Output_results','Output_folder','Output_Combinaisons','Combinaison_star','Hex_com_star','star_X_data','star_Combine_TS','Acc_max' )

    end                       
end      



%% Add the last results
colnames={'SCSA_Combinaison','Size','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score0'};
perform_output= array2table(Output_results, 'VariableNames',colnames);
perform_output.Combination = Output_Combinaisons' ;
Output_Combinaisons=Output_Combinaisons';

%% save to Excel file
% sheetnames=strcat('combinaison_',num2str(cnt0));
% A = Output_results;
% sheet = 1;
% xlswrite(strcat(root_folder,'/',filename,'.xlsx'),A,sheet);
% mtrix2excel(filename,A,colnames,sheetnames);
