feature_type='Raw_Data';

[accuracy,accuracy_avg,sensitivity_avg,specificity_avg,precision_avg,gmean_avg,f1score_avg]=K_Fold_CrossValidation(X, y, K, type_clf);
 


 %% save the optimal combinaision
Acc_op=accuracy_avg;
save(strcat('./Classification_results/',feature_type,suff,'_norm',num2str(Normalization),'_Acc',num2str(Acc_op),'.mat'),'accuracy','accuracy_avg','sensitivity_avg','specificity_avg','precision_avg','gmean_avg','f1score_avg',...
                                                             'X','y','L_max','EN_L','EN_b','bmin','bmax','suff','filename')

