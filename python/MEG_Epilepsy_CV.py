import os
import sys
import scipy.io
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.datasets import make_moons, make_circles, make_classification
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
from sklearn.metrics import *

from sklearn.model_selection import cross_val_predict
from sklearn.model_selection import cross_validate
from sklearn.model_selection import ShuffleSplit
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.metrics import *
from sklearn import metrics

#from lib.Shared_Functions import *
import glob


#%          ################ FUNCTION   ###########################
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


#%%#################################################################################################
# input parameters
save_excel=1;
project_name='QuPWM'

#The classifier pipeline
names = ["Nearest Neighbors", "Linear SVM",
        "RBF SVM", "Decision Tree", "Random Forest", "Neural Net",# "AdaBoost",
        "Naive Bayes", "Quadratic Discriminant Analysis"]

classifiers = [KNeighborsClassifier(3), SVC(kernel="linear", C=0.025),
    SVC(gamma=2, C=1),
    DecisionTreeClassifier(max_depth=5),
    RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    MLPClassifier(alpha=1),#AdaBoostClassifier(),
    GaussianNB(),
    QuadraticDiscriminantAnalysis()]

#%% #################################################################################################
data_path='./mat/EA001EA002EA003EA004EA005EA006EA007EA008EA009/'
#data_path='./mat/'
#files = [f for f in glob.glob(data_path+"**/90/*.mat", recursive=True)]
#names, classifiers=["Nearest Neighbors"],[ KNeighborsClassifier(3)]
score=[];Clf_score=[];clf_k=[]
names_clf_L=[]
list_L=[80, 90,95, 100, 110]
for name, clf in zip(names, classifiers):
    for L in list_L:
        files = [f for f in glob.glob(data_path+"**/"+str(L) + "/*.mat", recursive=True)]
    #  ---------------------------- Train/Test Split  ----------------------------
        score_clf=[]; fold=0
        print('Cross Validation using:',name)

        for mat_filename in files:
            #print('File L=',L,' :',mat_filename)
            fold=fold+1

            #% The classifier pipelinLoad mat files
            loaded_mat_file = scipy.io.loadmat(mat_filename)
            X_train = loaded_mat_file['fPWM_train']
            X_test = loaded_mat_file['fPWM_test']
            y_train = loaded_mat_file['y_train'].ravel()
            y_test = loaded_mat_file['y_test'].ravel()


            print('---> fold=',fold)
            clf.fit(X_train, y_train)
            y_predicted= clf.predict(X_test)
            accuracy,sensitivity, specificity, precision, recall, f1, AUC=Get_model_performnace(y_test,y_predicted)
            score_clf.append(list([accuracy, sensitivity, specificity,precision, recall, f1, AUC]))

        Clf_score_clf = pd.DataFrame(np.asarray(score_clf).T)
        New_score=Clf_score_clf.mean(axis = 1, skipna = True)
        Clf_score_clf['Scores']=   list(['Accuracy','Sensitivity', 'Specificity','Precision', 'Recall','F1-score', 'ROC-AUC'])
        x = mat_filename.split("\\"); filename_sub=x[-1][:-13];filename_sub=filename_sub.replace(' ', '')
        score.append(list([name,L]+ list(New_score)))
#        clf_k.append(name'


Clf_score= pd.DataFrame(np.asarray(score).T)

Clf_score['scores']=   pd.DataFrame(list(['Classifier', 'L','Accuracy','Sensitivity', 'Specificity','Precision', 'Recall','F1-score', 'ROC-AUC']))


if save_excel==1:
    path='./Results'
    if not os.path.exists(path):
        # Create target Directory
        os.mkdir(path)

    path=path+'/'+project_name

    if not os.path.exists(path):
        # Create target Directory
        os.mkdir(path)

    Clf_score.to_csv(path+'/5Fold_CV_'+ project_name+ filename_sub+str(list_L)+'.csv', sep=',')


##%% ---------------------------- cell  ----------------------------
