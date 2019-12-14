import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn import metrics
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from collections import defaultdict
from sklearn.metrics import *
from sklearn import datasets
import timeit

#from __future__ import division
import matlab.engine
import io
out = io.StringIO()
err = io.StringIO()
#%%


def browse_file():
    import tkinter
    from tkinter import filedialog
    import functools
    import operator
    import os
    # hide root window
    root = tkinter.Tk()
    root.withdraw()
    root.attributes("-topmost", True)

    fname = filedialog.askopenfilename( initialdir= "./" ,title='Please select a *mat file')

    if fname[-3:]!='mat':
        print('Please choose a mat file not '+fname[-3:] +' file')

    return  functools.reduce(operator.add, (fname)),os.path.basename(fname)

def Run_Training_test_Classification(clf, name, X_train, y_train,X_test):

#%%----------------------------  Train/Test Split  -----------------------------------------
    print('\n\n Train/Test Split using:',name)
    #% model training
    start_time = timeit.default_timer()
    clf.fit(X_train, y_train)
    time_train = timeit.default_timer() - start_time

    #% model testing
    start_time = timeit.default_timer()
    y_predicted= clf.predict(X_test)
    time_test = timeit.default_timer() - start_time

#    #% model testing one sample
#    start_time = timeit.default_timer()
#    y1= clf.predict(X_test[0:1])
#    time_test1 = timeit.default_timer() - start_time


    return y_predicted, time_train, time_test

def Feature_selection_using_Tree(X,y,features0):
    from sklearn.ensemble import ExtraTreesClassifier

    print(features0,'000000')

    # Build a forest and compute the feature importances
    forest = ExtraTreesClassifier(n_estimators=250,
                                  random_state=0)

    forest.fit(X, y)
    importances = forest.feature_importances_
    std = np.std([tree.feature_importances_ for tree in forest.estimators_],
                 axis=0)
    indices = np.argsort(importances)[::-1]

    # Print the feature ranking
    print("Feature ranking:")

    for f in range(X.shape[1]):
        print("%d. feature %d (%f)" % (f + 1, indices[f], importances[indices[f]]))

    # Plot the feature importances of the fores

#    features_sel=[];
#    for k in indices:
#        print(k, '--',features0[k])
#        features_sel.append(features0[k])
#
#    print(indices)
#    print(features_sel)
#    print(features0)

    plt.figure()
    plt.title("Feature importances")
    plt.bar(range(X.shape[1]), importances[indices],
           color="r", yerr=std[indices], align="center")
#    plt.xticks(range(X.shape[1]),indices)
#    plt.xticks(range(X.shape[1]),indices)
    plt.xticks(range(X.shape[1]), features_sel, rotation=45)
    plt.xlim([-1, X.shape[1]])
    plt.show()

    #% feature selection using threshold
    return  indices,importances

def str_list_to_int_list(str_list):
    n = 0
    while n < len(str_list):
        str_list[n] = int(str_list[n])
        n += 1
    return(str_list)


def plot_something():
        #https://matplotlib.org/users/pyplot_tutorial.html
    plt.figure(1)                # the first figure
    plt.subplot(211)             # the first subplot in the first figure
    plt.plot([1,2,3,4], [1,4,9,16], 'r--')
    plt.xlim([0, 10])
    plt.ylim([0, 30])
    plt.legend({'curve 1'})
    plt.xlabel('Smarts')
    plt.ylabel('Probability')
    plt.title(r'$\sigma_i=15$' +'  Title here ')
    plt.text(3, 3, r'$\mu=100,\ \sigma=15$')
    plt.grid(True)
    plt.show()

def Explore_dataset(y):
    classes=set(y)
    data_dic=list();
    blcd=1
    print('\nThe Dataset has:', len(y), 'samples in Total',)

    for c in classes:
        data_dic.append([ int(c), list(y).count(c)])
        print('- Class ' , c, ' =' ,list(y).count(c) , 'samples')

    data_ar=np.asanyarray(data_dic)
    if len(set(data_ar[:,1]))>1:
        print('==> The dataste is unbalanced')
        blcd=0

    return blcd, classes, data_dic

def Get_model_performnace(y,y_predicted):
    if len(set(y ))==2:

        C = confusion_matrix(y,y_predicted)
    #    print('Confusion Matrix : \n', C)

        total1=sum(sum(C))
        #####from confusion matrix calculate accuracy
        accuracy=(C[0,0]+C[1,1])/total1
    #    print ('Accuracy : ', accuracy)

        sensitivity = C[0,0]/(C[0,0]+C[0,1])
    #    print('Sensitivity : ', sensitivity )

        specificity = C[1,1]/(C[1,0]+C[1,1])
    #    print('Specificity : ', specificity)


    #    # accuracy: (tp + tn) / (p + n)
    #    accuracy = accuracy_score(y, y_predicted)
    #    print('Accuracy: %f' % accuracy)
    #
    #
        # precision tp / (tp + fp)
        precision = precision_score(y, y_predicted)
    #    print('Precision: %f' % precision)
        # recall: tp / (tp + fn)
        recall = recall_score(y, y_predicted)
    #    print('Recall: %f' % recall)

        # f1: 2 tp / (2 tp + fp + fn)
        f1 = f1_score(y, y_predicted)
    #    print('F1 score: %f' % f1)
        fpr, tpr, thresholds = metrics.roc_curve(y, y_predicted)
        AUC=metrics.auc(fpr, tpr)
    #    print('AUC score: %f' % AUC)

    else:

        MC_performance=report2dict(classification_report(y, y_predicted))

        accuracy= round((y == y_predicted).mean().item(),2)
        specificity=-1
        recall=float(MC_performance['recall'][-1:])
        sensitivity=recall
        f1=float(MC_performance['f1-score'][-1:])
        precision=float(MC_performance['precision'][-1:])
        AUC=-1



#    print ('Accuracy : ', accuracy)

    return accuracy, sensitivity, specificity, precision, recall, f1, AUC #=Get_model_performnace(y_test,y_predicted)


def report2dict(cr):
    # Source: https://github.com/scikit-learn/scikit-learn/issues/7845
    # Parse rows
    tmp = list()
    for row in cr.split("\n"):
        parsed_row = [x for x in row.split("  ") if len(x) > 0]
        if len(parsed_row) > 0:
            tmp.append(parsed_row)

    # Store in dictionary
    measures = tmp[0]

    D_class_data = defaultdict(dict)

    for row in tmp[1:]:
        class_label = row[0]
        for j, m in enumerate(measures):
            D_class_data[class_label][m.strip()] = float(row[j + 1].strip())
    return pd.DataFrame(D_class_data).T



def  Get_ROC_Curve(y,y_predicted):
    fpr, tpr, thresholds = metrics.roc_curve(y, y_predicted)
    AUC=metrics.auc(fpr, tpr)

    plt.figure()
    plt.plot(fpr, tpr, color='darkorange', label='ROC curve (area = %0.2f)' % AUC)
    plt.plot([0, 1], [0, 1], color='navy', linestyle='--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver operating characteristic example')
    plt.legend(loc="lower right")
    plt.show()

    return fpr, tpr, AUC

## Set the parameters by cross-validation
#CV=5
#clf_model=SVC()
#tuned_parameters = [{'kernel': ['rbf'], 'gamma': [1e-3, 1e-4],'C': [1, 10, 100, 1000]}, {'kernel': ['linear'], 'C': [1, 10, 100, 1000]}]
#clf_op_param, clf_op=Tuning_hyper_parameters(clf_model, tuned_parameters, CV,X_train, y_train)
#print('\n\n ************ Test  using the best model parameters ***************\n')
#y_true, y_pred = y_test, clf_op.predict(X_test)
def Tuning_hyper_parameters(clf_model, tuned_parameters, CV,X_train, y_train):

    Myscore = {'precision'}# 'recall'#
    blcd, classes, data_dic=Explore_dataset(y_train)

#    if blcd==1:
#        scores = {'accuracy'}
#    else:
#        scores = Myscore

    if not (len(classes)==2) & (blcd==1):
        prefx=''
        scores = {'accuracy'}

    else:
        scores = Myscore
        prefx='_macro'
#    score=scores
    for score in scores:
        print("# Tuning hyper-parameters for %s" % score+prefx)
        print()

        if CV==0:
            clf = GridSearchCV(clf_model, tuned_parameters,scoring="%s" % score+prefx)

        else:
            clf = GridSearchCV(clf_model, tuned_parameters, cv=CV, scoring="%s" % score+prefx)

        clf.fit(X_train, y_train)


        print()
        print("Grid scores on development set:")
        print()
        means = clf.cv_results_['mean_test_score']
        stds = clf.cv_results_['std_test_score']
        for mean, std, params in zip(means, stds, clf.cv_results_['params']):
            print("%0.3f (+/-%0.03f) for %r"
                  % (mean, std * 2, params))
        print()

        print("Best parameters set found on development set:")
        print()
        print(clf.best_params_)
        print()
        return  clf.best_params_, clf



def Classification_Train_Test(names, classifiers, X_train, y_train, X_test, y_test ):
    score=[]
    acc_op=0
    for name, clf in zip(names, classifiers):
#        print('Train/Test Split using:',name)
        #% model training
        start_time = timeit.default_timer()
        clf.fit(X_train, y_train)
        time_train = timeit.default_timer() - start_time

        #% model testing
        start_time = timeit.default_timer()
        y_predicted= clf.predict(X_test)
        time_test = timeit.default_timer() - start_time

        #% model testing one sample
        start_time = timeit.default_timer()
        y1= clf.predict(X_test[0:1])
        time_test1 = timeit.default_timer() - start_time

        #% model evaluation
        accuracy,sensitivity, specificity, precision, recall, f1, AUC=Get_model_performnace(y_test,y_predicted)


        score.append(list([accuracy, sensitivity, specificity,precision, recall, f1, AUC, time_train, time_test]))
#        print('accuracy=',accuracy, 'sensitivity=',sensitivity,'specificity=', specificity,'sensitivity=',sensitivity,
#              'precision=', precision , 'recall=', recall , 'F1-Score=', f1 , 'AUC=',AUC,'time_train=', time_train, 's time_test=', time_test , 's')
        if acc_op<accuracy:
            acc_op=accuracy
            clf_op=name


        # ROC
    #    fpr, tpr, AUC=Get_ROC_Curve(y_test,y_predicted)

    Mdl_score = pd.DataFrame(np.asarray(score).T, columns=names)
    Mdl_score['Scores']=   list(['Accuracy','Sensitivity', 'Specificity','Precision', 'Recall','F1-score', 'ROC-AUC','time_train(s)','time_test(s)'])

#    print('Train/Test Split  results :\n\n',Mdl_score )
    print('\nOptimal classifier :',clf_op , ', Accuracy  :',acc_op,'\n\n')


    return Mdl_score