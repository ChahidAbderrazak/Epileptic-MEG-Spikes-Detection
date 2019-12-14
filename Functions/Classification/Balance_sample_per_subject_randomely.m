fs2=4;             % Downsampling the frame size

%%  balance the data per subject
fprintf(' --> balance the data per subject \n ')

if exist('Patient_Spk','var') == 0 , Patient_Spk=y_PatientID;  end                 


Patients=unique(Patient_Spk); NB_patient=max(size(Patients));
X_blcd=[];y_blcd=[];y_patient_blcd=[];
for subj = patient_k%:NB_patient
    
    
    % get subj data
    subject=Patients(subj);
    idx = find(Patient_Spk==Patients(subj));
    
    Xi=X(idx,:); yi=y(idx); y_patient_i=Patient_Spk(idx);
    
    idxn=find(yi==0);idxp=find(yi==1);
    Ni_p=max(size(idxp));  Ni_n=max(size(idxn));
    s = RandStream('mlfg6331_64'); Rndm_idx=randsample(s,max(Ni_p,Ni_n),min(Ni_p,Ni_n),false);
    
    if Ni_n> min(Ni_p,Ni_n)
        
        idxn=idxn(Rndm_idx);
    else
        
        idxp=idxp(Rndm_idx);
    end
    
    Idx_blcd=[idxp;idxn];
    
    
    %update the datset
    X_blcd=[X_blcd; Xi(Idx_blcd,:)];
    y_blcd=[y_blcd; yi(Idx_blcd)];
    y_patient_blcd=[y_patient_blcd; y_patient_i(Idx_blcd)];
    d=1;
end

%%  Downsampling by Frame Step
Frame_Step=fs2*Frame_Step;downsampled=1;

fprintf(' --> Downsampling by %d samples per frame-step size \n ',Frame_Step)
X_blcd=X_blcd(1:fs2:end,:);
y_blcd=y_blcd(1:fs2:end);               idp=find(y==1);
y_patient_blcd=y_patient_blcd(1:fs2:end);
%clearvars *_blcd



X=X_blcd;y=y_blcd; y_PatientID=y_patient_blcd;

d=1;