function walog_record(cmd)
%usage walog_record [listen|save|cancel|replay]
eval(cmd)

function listen
global Rec
Rec = audiorecorder(16000,16,1);
record(Rec);% speak into microphone...
Rec.UserData=now;

function cancel
global Rec
try stop(Rec); end 

function replay
global Rec
persistent Player
try stop(Rec); end
Player=play(Rec);

function save
global Rec
if isempty(Rec); warning('No Audio Record in Progress');return; end
stop(Rec)
w = getaudiodata(Rec,'double'); 
f=[datestr(Rec.UserData,'yyyymmdd-HHMMSS') ' MAPS Wallog'];
if max(abs(w))>=1; w=w*0.99; end    
wavwrite(w,Rec.SampleRate,Rec.BitsPerSample,f)
disp([num2str(round(length(w)/22050)) ' seconds saved to ' f])
dos(['lame --quiet -b 24 "' f '.wav" "' f '.mp3"']);
if exist([f '.mp3']); delete([f '.wav']);end
clear global Rec
walog_writelog('audiocomment');
