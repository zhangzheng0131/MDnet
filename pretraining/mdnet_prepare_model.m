function mdnet_prepare_model()
% MDNET_PREPARE_MODEL
% Prepare a initial CNN model for learning MDNet.
%
% conv1-3 are adopted from VGG-M network.
% fc4-fc6 are randomly initialized.
% fc6 will be replaced by multiple domain-specific layers when training MDNet.
%
% Hyeonseob Nam, 2015
% 

% conv1-3 layers from VGG-M network pretrained on ImageNet
%src_model = './models/imagenet-vgg-m-conv1-3.mat';
src_model = '/home/zhangzheng/workplace/master/nntrackerpapers/matlab/MDNet-master/MDNet-master/models/imagenet-vgg-m-conv1-3.mat';

% output network 
dst_model = '/home/zhangzheng/workplace/master/nntrackerpapers/matlab/MDNet-master/MDNet-master/models/mdnet_init.mat';

if exist(dst_model,'file')
    return;
end
    
%% load conv layers
load(src_model);

new_layers = {};
for i=1:numel(layers)
    if strcmp(layers{i}.name,'conv4'), break; end
    switch (layers{i}.type)
        case 'conv'
            layers{i}.filters = layers{i}.weights{1};
            layers{i}.biases = layers{i}.weights{2};
            layers{i} = rmfield(layers{i},'weights');
            layers{i}.pad = 0;
            last_dim = size(layers{i}.biases,2);
        case 'pool'
            layers{i}.pad = 0;
    end
    new_layers{end+1} = layers{i};
end

%% init fc layers
scal = 1 ;
init_bias = 0.1;

% Block 4
new_layers{end+1} = struct('type', 'conv', ...
                           'name', 'fc4', ...
                           'filters', 0.01/scal * randn(3,3,last_dim,512,'single'),...
                           'biases', init_bias*ones(1,512,'single'), ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'filtersLearningRate', 10, ...
                           'biasesLearningRate', 20, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
new_layers{end+1} = struct('type', 'relu', 'name', 'relu4') ;
new_layers{end+1} = struct('type', 'dropout', 'name', 'drop4', 'rate', 0.5) ;

% Block 5
new_layers{end+1} = struct('type', 'conv', ...
                           'name', 'fc5', ...
                           'filters', 0.01/scal * randn(1,1,512,512,'single'),...
                           'biases', init_bias*ones(1,512,'single'), ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'filtersLearningRate', 10, ...
                           'biasesLearningRate', 20, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
new_layers{end+1} = struct('type', 'relu', 'name', 'relu5') ;
new_layers{end+1} = struct('type', 'dropout', 'name', 'drop5', 'rate', 0.5) ;

% Block 6
new_layers{end+1} = struct('type', 'conv', ...
                           'name', 'fc6', ...
                           'filters', 0.01/scal * randn(1,1,512,2,'single'), ...
                           'biases', zeros(1, 2, 'single'), ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'filtersLearningRate', 10, ...
                           'biasesLearningRate', 20, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
new_layers{end+1} = struct('type', 'softmaxloss', 'name', 'loss') ;

clear layers; layers = new_layers;
save(dst_model,'layers');