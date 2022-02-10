[y,Fs]=audioread('蔡立1.wav');
y=y(:,1);
%把语音信号分帧，加窗（若要加窗请传入窗函数）
%overlap=win-inc
audiowrite('sound_wav_in/1.6.wav',y,16000)
function f = enframe(y,win,inc) %输入文件，窗体长度或窗函数，帧移
nx = length(y(:));      %输入数据长度
nwin = length(win);         %取窗长
if (nwin == 1)              %若nwin==1，表示输入的是数字，否则是窗函数
    len = win;              %帧长=win
else
    len = nwin;             %帧长=nwin
end 
if(nargin < 3)              %如果只有两个参数，则inc=帧长
    inc = len;
end
nf = fix((nx-len+inc)/inc); %计算帧数
f = zeros(nf,len);
indf = inc*(0:(nf-1)).';    %设置每帧在x中的位移量位置
inds = (1:len);
f(:)=y(indf(:,ones(1,len))+inds(ones(nf,1),:)); %分帧
if(nwin > 1)                %若有窗函数，则每帧乘以窗函数
    w = win(:)';
    f = f.* w(ones(nf,1),:);
end
end
