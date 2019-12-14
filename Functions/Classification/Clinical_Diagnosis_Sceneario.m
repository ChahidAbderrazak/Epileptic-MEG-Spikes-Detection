function [accuracy,sensitivity,specificity,precision,gmean,f1score]=Clinical_Diagnosis_Sceneario(QuPWM_str, Q, y)
global type_clf
        Xf= Generate_PWM_features(Q, QuPWM_str.PWM_P, QuPWM_str.PWM_N);
        % Classification using trained model
        [accuracy,sensitivity,specificity,precision,gmean,f1score]=Testing_Trained_Model(type_clf, Mdl, Xf, y);
end
        