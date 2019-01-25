function [accuracy,sensitivity,specificity,precision,gmean,f1score]=prediction_performance(ytrue, yfit)
 
if size(ytrue,1)>1
 
    C=confusionmat(ytrue, yfit);
    sensitivity = C(2,2)/(C(2,1)+C(2,2))*100;
    specificity = C(1,1)/(C(1,1)+C(1,2))*100;
    precision = (C(2,2)/(C(2,2)+C(1,2)))*100;
    accuracy= (C(1,1)+C(2,2))/(C(1,1)+C(1,2)+C(2,1)+C(2,2))*100;

    
else
    
    if ytrue==yfit
        sensitivity =100;
        specificity =100;
        precision = 100;
        accuracy= 100;
        
    else
        sensitivity =0;
        specificity =0;
        precision = 0;
        accuracy= 0;
        
        
        
    end
    
    
    
end


    gmean = (sqrt(sensitivity*specificity));
    f1score = (2*((precision*sensitivity)/(precision+sensitivity)));
    
    
    
    d=1;
    