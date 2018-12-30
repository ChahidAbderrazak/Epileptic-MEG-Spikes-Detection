 %% Apply Leave One Out CV with PWM features using diffferent classifers
% X: The data  sample
% y  The Class
% clf: The calssifier:{'nbayes','logisticRegression','SVM','','',''}
function [accuracy1,sz_fPWM]= Classify_LeaveOut_PWM(X,y,clf)
global Levels Level_intervals

y=y+1;
%% Leave one sample Out Cross-Validation
C = cvpartition(y, 'LeaveOut');

for num_fold = 1:C.NumTestSets
    clearvars -except X y Levels Levels PWM_P PWM_N Level_intervals Level_intervals acc1 num_fold C outcome outcome2 outcome classPrior accuracy11 accuracy21 accuracy31 accuracy41 accuracy51 accuracy61
    
    trIdx = C.training(num_fold);
    teIdx = C.test(num_fold);
    Idx= find(teIdx);
    X_train= X(trIdx,:);
    X_test= X(teIdx,:);
    
    y_train= y(trIdx);
    y_test= y(teIdx);
    
    Xp=X_train(y_train==2,:);   Np=size(Xp, 1);
    Xn=X_train(y_train==1,:);   Ns=size(Xn, 1);
    
    Xp= mapping_levels(Xp,Level_intervals, Levels);
    Xn= mapping_levels(Xn,Level_intervals, Levels);
    
    PWM_P = Generate_PWM_matrix(Xp, Levels);
    PWM_N = Generate_PWM_matrix(Xn, Levels);
    
    X_train_levels=[Xp;Xn];
    fPWM_train= Generate_PWM_features(X_train_levels, PWM_P, PWM_N); 
    
    X_test_levels= mapping_levels(X_test, Level_intervals, Levels);
    fPWM_test= Generate_PWM_features(X_test_levels, PWM_P, PWM_N);

    %% plot PWM features
%     plot_PWM_features(fPWM_train,fPWM_test,Np)

    %% Train and test the model
    [classifier] = trainClassifier(fPWM_train,y_train, 'logisticRegression');   %train classifier

    %% Test the model
    [y_predicted] = applyClassifier(fPWM_test, classifier);       %test it

    [result1,predictedLabels1,trace1] = summarizePredictions(y_predicted,classifier,'averageRank',y_test);
%    [accuracy(num_fold),sensitivity(num_fold),specificity(num_fold),precision(num_fold),gmean(num_fold),f1score(num_fold)]=prediction_performance(y_predicted , y_test);

            
            
    acc1(num_fold)= 1-result1{1};  % rank accuracy
%     global scores
%     outcome(num_fold,:)=[y_test  acc1(num_fold) scores];

end

%% Average Accuracy 
accuracy1= sum(acc1)/sum(C.TestSize);

sz_fPWM=size(fPWM_train,2)


end

%% Funtions


function plot_PWM_features(fPWM_train,fPWM_test,Np)
Np=124;
% close all
figure(125);
scatter(fPWM_train(1:Np,1), fPWM_train(1:Np,2),'r');  hold on
scatter(fPWM_train(Np+1:end,1) , fPWM_train(Np+1:end,2),'k');  hold on
scatter(fPWM_test(1), fPWM_test(2),'b', 'LineWidth',12 );  hold off
legend('Negative Class Training ', 'Positive Class Training ', 'Negative sample tested ')

title('LOO features using PWM projection of the samples')
xlabel('fPWM_1')
ylabel('fPWM_2')

set(gca,'fontsize',16)

end
% Quantization
function X=mapping_levels(X,Level_intervals, Levels)
    for i=1:size(X,1)
        for j=1:size(X,2)
             X(i,j)=Get_level(X(i,j),Level_intervals,Levels);    
        end
        
    end
d=1;
end


function L=Get_level(Vx,Level_intervals,Levels)  

    idx=find(Vx<=Level_intervals);

    if size(idx,2)==0
        L=Levels(end);
    else
       l=idx(1);
       L=Levels(l);

    end


    d=1;
end




function PWM_matrix= Generate_PWM_matrix(X_train, Levels)
Levels=size(Levels,2);
PWM_matrix= zeros(5, size(X_train,2));

for k=1:Levels
    for i=1:size(X_train, 2)
        PWM_matrix(k,i)= sum(X_train(:, i) == k)/size(X_train,1);
    end
end


end

 function fPWM_eatures= Generate_PWM_features(X_train, PWM_P, PWM_N)
    
fPWM_1= zeros(size(X_train,1), size(X_train,2)); %f1 is the first feature of PWM
fPWM_2= zeros(size(X_train,1), size(X_train,2)); %f1 is the second feature of PWM

% replace the integer values by its probability from VPM
for i=1:size(X_train,1)
    for j=1:size(X_train,2)
        PWM_idx=X_train(i,j);
        fPWM_1(i,j)= PWM_P(PWM_idx,j);
        fPWM_2(i,j)= PWM_N(PWM_idx,j);
    end
end
% sum all the probabilities to get the PWM
f1=sum(fPWM_1,2);
f2=sum(fPWM_2,2);
fPWM_eatures=[f1 f2];

end