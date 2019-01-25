function [t]=get_Time_from_Record(Comment,M)
Word=char(Comment);
semiC=strfind(Word,',');
StartC=strfind(Word,'(');
StopC=strfind(Word,')');

t0=str2double(Word(StartC+1:semiC-2));
t1=str2double(Word(semiC+1:StopC-2));


t=linspace(t0,t1,M);
d=1;