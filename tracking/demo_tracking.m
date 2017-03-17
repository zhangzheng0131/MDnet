%% DEMO_TRACKING
%
% Running the MDNet tracker on a given sequence.
%
% Hyeonseob Nam, 2015
%
%[nameotb]=textread('./dataset/OTB/tb_50zz.txt','%s','headerlines',0)
%[nameotb]=textread('./../dataset/VOT/2015/list.txt','%s','headerlines',0)
azz=2
for j=1:1
    switch(azz)
        case 0
            [nameotb]=textread('./../dataset/VOT/2014/list.txt','%s','headerlines',0)
        case 1
            [nameotb]=textread('./../dataset/VOT/2015/list.txt','%s','headerlines',0)
        case 2
            [nameotb]=textread('./../dataset/OTB/tb_ano50.txt','%s','headerlines',0)
    end
    %azz=azz+1;     
     
            
for i=1:length(nameotb)
    
%conf = genConfig('otb',char(nameotb(i)));
switch(azz)
    case 0
        conf = genConfig('vot2013',char(nameotb(i)));
    case 1
        conf = genConfig('vot2014',char(nameotb(i)));
    case 2
        conf = genConfig('otb',char(nameotb(i)));
end
%conf = genConfig('vot2015',char(nameotb(i)));
%conf = genConfig('otb',char(nameotb(i)));%conf = genConfig('vot2015','ball1');

switch(conf.dataset)
    case 'otb'
        net = fullfile('./../models','mdnet_vot-otb_new.mat');
    case 'vot2014'
        %net = fullfile('models','mdnet_otb-vot14.mat');
        net = fullfile('./../models','mdnet_otb-vot14_new.mat');
    case 'vot2015'
       % net = fullfile('models','mdnet_otb-vot15.mat');
       net = fullfile('models','mdnet_otb-vot15_new.mat');
end

result = mdnet_run(conf.imgList, conf.gt(1,:), net);
%filename=['./results/otb/' char(nameotb(i)) '_MDnet' '.mat'];
%filename=['./../results/vot2015/' char(nameotb(i)) '_MDnet' '.mat'];
switch(azz)
    case 0
        filename=['./../results/vot2014/' char(nameotb(i)) '_MDnet' '.mat'];
    case 1
        
    case 2
        filename=['./../results/otb_ano50/' char(nameotb(i)) '_MDnet' '.mat'];
end
save(filename,'result');
end
end
