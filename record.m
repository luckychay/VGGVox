function p=record(id,flag)
%flag=0;
a();
if flag==0
%判断文件夹是否存在
%    id='4';%
    head='user';
    ok = exist(fullfile(vl_rootnn,head,id), 'dir');
    if ok==0        
        creat=['md',32,fullfile(vl_rootnn,head,id)];%加入空格
        dos(creat);%在指定路径新建文件夹
        addpath(genpath(fullfile(vl_rootnn,head,id)));%将新建的文件夹加入到当前路径
    else
        disp('id exist!\n');
        p=0;
        return;
    end
else
    head='user';
%    id='4';%
    ok = exist(fullfile(vl_rootnn,head,id), 'dir');
    if ok==0
        disp('user not exist');
        p=0;
        return
    end
end
% 录音录5秒钟
recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, 5);
disp('End of Recording.');
% 回放录音数据
play(recObj);
% 获取录音数据
myRecording = getaudiodata(recObj);
% 绘制录音数据波形
%plot(myRecording);
%存储语音信号
filename1 = '1.wav';
filename2 = '2.wav';
paths = fullfile(vl_rootnn,head,id,filename1) ;
ok = exist(paths, 'file') ;%判断文件是否存在
if ok==0
    audiowrite(paths,myRecording,16000);
else
    paths = fullfile(vl_rootnn,head,id,filename2) ;
    audiowrite(paths,myRecording,16000);
end
p=1;