[y,Fs]=audioread('����1.wav');
y=y(:,1);
%�������źŷ�֡���Ӵ�����Ҫ�Ӵ��봫�봰������
%overlap=win-inc
audiowrite('sound_wav_in/1.6.wav',y,16000)
function f = enframe(y,win,inc) %�����ļ������峤�Ȼ򴰺�����֡��
nx = length(y(:));      %�������ݳ���
nwin = length(win);         %ȡ����
if (nwin == 1)              %��nwin==1����ʾ����������֣������Ǵ�����
    len = win;              %֡��=win
else
    len = nwin;             %֡��=nwin
end 
if(nargin < 3)              %���ֻ��������������inc=֡��
    inc = len;
end
nf = fix((nx-len+inc)/inc); %����֡��
f = zeros(nf,len);
indf = inc*(0:(nf-1)).';    %����ÿ֡��x�е�λ����λ��
inds = (1:len);
f(:)=y(indf(:,ones(1,len))+inds(ones(nf,1),:)); %��֡
if(nwin > 1)                %���д���������ÿ֡���Դ�����
    w = win(:)';
    f = f.* w(ones(nf,1),:);
end
end
