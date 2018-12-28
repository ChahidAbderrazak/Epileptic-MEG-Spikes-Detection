% f_framed=frame_fun(f,f_ref)
% set the function f in the same frame (Amin,Amax) with the reference 
% function f_ref 
function f_framed=frame2fun(f,f_ref)
Amax=max(f_ref);Amin=min(f_ref);
f=f-min(f);
if max(f)~=0
f = ((Amax-Amin)/max(f))*f;
f_framed =f +Amin;
else
  f_framed=f;  
end
end