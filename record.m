function p=record(id,flag)
%flag=0;
a();
if flag==0
%�ж��ļ����Ƿ����
%    id='4';%
    head='user';
    ok = exist(fullfile(vl_rootnn,head,id), 'dir');
    if ok==0        
        creat=['md',32,fullfile(vl_rootnn,head,id)];%����ո�
        dos(creat);%��ָ��·���½��ļ���
        addpath(genpath(fullfile(vl_rootnn,head,id)));%���½����ļ��м��뵽��ǰ·��
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
% ¼��¼5����
recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, 5);
disp('End of Recording.');
% �ط�¼������
play(recObj);
% ��ȡ¼������
myRecording = getaudiodata(recObj);
% ����¼�����ݲ���
%plot(myRecording);
%�洢�����ź�
filename1 = '1.wav';
filename2 = '2.wav';
paths = fullfile(vl_rootnn,head,id,filename1) ;
ok = exist(paths, 'file') ;%�ж��ļ��Ƿ����
if ok==0
    audiowrite(paths,myRecording,16000);
else
    paths = fullfile(vl_rootnn,head,id,filename2) ;
    audiowrite(paths,myRecording,16000);
end
p=1;