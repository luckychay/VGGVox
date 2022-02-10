function inp = test_getinput(image,meta,buckets)

	audfile 	= [image(1:end-3),'wav'];
	z         	= audioread(audfile);%���ļ�    
	SPEC 		= runSpec(z,meta.audio);%mfcc����
	mu    		= mean(SPEC,2);%��SPEC�ӵڶ�������ÿ��ȡ��ֵ
    stdev 		= std(SPEC,[],2) ;%����spec�ӵڶ�������ı�׼��
    nSPEC 		= bsxfun(@minus, SPEC, mu);%��spec��mu���������
    nSPEC 		= bsxfun(@rdivide, nSPEC, stdev);%��nSPEC��stdev�������ҳ�

    rsize 	= buckets.width(find(buckets.width(:)<=size(nSPEC,2),1,'last'));
    rstart  = round((size(nSPEC,2)-rsize)/2);

	inp(:,:) = gpuArray(single(nSPEC(:,rstart:rstart+rsize-1)));

end 

