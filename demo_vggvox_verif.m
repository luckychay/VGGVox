function dist=demo_vggvox_verif(id,varargin)
% DEMO_VGGVOX_VERIF - minimal demo with the VGGVox model pretrained on the
% VoxCeleb dataset for Speaker Verification

% downloads the VGGVox model and
% prints the distance on a test evalutation pair

opts.modelPath = '' ;
opts.gpu = 3;
opts.dataDir = fullfile(vl_rootnn,'user'); 
opts = vl_argparse(opts, varargin) ;

% Example speech segments for input 
%cd('contrib\VGGVox');
head='user';
%id='1';%用户id，用于指定用户文件夹位置
type='*.wav';
full=fullfile(vl_rootnn,head,id,type);
wavs=dir(full);
N=length(wavs);
names={};
if N>0
    for k=1:N
        names{k}=wavs(k).name;
    end
else
    disp("no wav files");
    return
end
opts.dataDir=fullfile(opts.dataDir,id);%选择文件路径至相应文件夹
inpPath1 = fullfile(opts.dataDir, names{1});
inpPath2 = fullfile(opts.dataDir, names{2}); 

% Load or download the VGGVox model for Verification
modelName = 'vggvox_ver_net.mat' ;
paths = {opts.modelPath, ...
    modelName, ...
    fullfile(vl_rootnn, 'data', 'models-import', modelName)} ;
ok = find(cellfun(@(x) exist(x, 'file'), paths), 1) ;

if isempty(ok)
    fprintf('Downloading the VGGVox model for Verification ... this may take a while\n') ;
    opts.modelPath = fullfile(vl_rootnn, 'data/models-import', modelName) ;
    mkdir(fileparts(opts.modelPath)) ; base = 'http://www.robots.ox.ac.uk' ;
    url = sprintf('%s/~vgg/data/voxceleb/models/%s', base, modelName) ;
    urlwrite(url, opts.modelPath) ;
else
    opts.modelPath = paths{ok} ;
end
load(opts.modelPath); net = dagnn.DagNN.loadobj(netStruct);dagnn.ContrastiveLoss

% Remove loss layers and add distance layer
names = {'loss'} ;
for i = 1:numel(names)
    layer = net.layers(net.getLayerIndex(names{i})) ;
    net.removeLayer(names{i}) ;
    net.renameVar(layer.outputs{1}, layer.inputs{1}, 'quiet', true) ;
end
net.addLayer('dist', dagnn.PDist('p',2), {'x1_s1', 'x1_s2'}, 'distance');

% Evaluate network on GPU and set up network to be in test
% mode
net.move('gpu');
net.conserveMemory = 0;
net.mode = 'test' ;

% Setup buckets
buckets.pool 	= [2 5 8 11 14 17 20 23 27 30];
buckets.width 	= [100 200 300 400 500 600 700 800 900 1000];

% Load input pair and do a forward pass
inp1 = test_getinput(inpPath1, net.meta, buckets);
inp2 = test_getinput(inpPath2, net.meta, buckets);

s1 = size(inp1,2);
s2 = size(inp2,2);

p1 = buckets.pool(s1==buckets.width);
p2 = buckets.pool(s2==buckets.width);

net.layers(22).block.poolSize=[1 p1];
net.layers(47).block.poolSize=[1 p2];
featid = strcmp({net.vars.name},'distance');
net.eval({ 'input_b1', gpuArray(inp1) ,'input_b2', gpuArray(inp2) });
dist = gather(squeeze(net.vars(featid).value));

% Print distance
fprintf('dist: %05d \n',dist); % should output a small distance if the two segments come from the same identity
