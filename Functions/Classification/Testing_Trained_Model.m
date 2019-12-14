function [accuracy,sensitivity,specificity,precision,gmean,f1score]=Testing_Trained_Model(type_clf, Mdl, X, y)



    switch type_clf
        case 'LR' 
            % Logistic regression model 
            yfit0 = Mdl.predict(X);
            yfit0=yfit0-min(yfit0);yfit0=yfit0/max(yfit0);
            yfit=double(yfit0>0.5);

        case 'SVM'

            [yfit,scores] = predict(Mdl,X);

          otherwise

            warning(strcat('The chosen classifier:',type_clf,' is not available.'));

    end


    %% Compute the accuracy
    [accuracy,sensitivity,specificity,precision,gmean,f1score]=prediction_performance(y, yfit);


