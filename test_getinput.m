function inp = test_getinput(image,meta,buckets)

	audfile 	= [image(1:end-3),'wav'];
	z         	= audioread(audfile);%读文件    
	SPEC 		= runSpec(z,meta.audio);%mfcc处理
	mu    		= mean(SPEC,2);%对SPEC从第二列往后每行取均值
    stdev 		= std(SPEC,[],2) ;%计算spec从第二列往后的标准差
    nSPEC 		= bsxfun(@minus, SPEC, mu);%对spec与mu做矩阵减法
    nSPEC 		= bsxfun(@rdivide, nSPEC, stdev);%对nSPEC与stdev做矩阵右除

    rsize 	= buckets.width(find(buckets.width(:)<=size(nSPEC,2),1,'last'));
    rstart  = round((size(nSPEC,2)-rsize)/2);

	inp(:,:) = gpuArray(single(nSPEC(:,rstart:rstart+rsize-1)));

end 

