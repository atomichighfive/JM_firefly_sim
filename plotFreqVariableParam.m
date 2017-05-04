function [ ] = plotFreqVariableParam( name )
%plotFreqVariableParam, plot frequency change for oscillators with different parameters from .mat files in directory 'name'


% TODO:
% Need to manually cd_str to directory where JM_Firefly exist.
% JM_Firefly_Sim/output/simulations must exist
% Get legend to work



%   Order of color
colors=['b', 'r', 'y', 'k', 'g', 'm', 'c','b', 'r', 'y', 'k', 'g', 'm', 'c','b', 'r', 'y', 'k', 'g', 'm', 'c','b', 'r', 'y', 'k', 'g', 'm', 'c','b', 'r', 'y', 'k', 'g', 'm', 'c' ];
% Change directory to 'name'
cd_str=['~/Documents/JM_Firefly_Sim/output/simulations/',name];
if exist(cd_str, 'dir') == 7
    cd(cd_str);
    %lista simuleringar
    dirs=dir;
    dirs(3).name;
    % (. .. sim1 sim2 sim3) i dir
    figure('Name', ['Frequencychange for oscillators' char(datetime)])
    for i=0:size(dirs,1)-4
        if exist(cd_str, 'dir') == 7
            cd(cd_str);
        end
        load([name num2str(i,'%03d') '.mat'])
        cd ../../..
        plotFrequencyChange(states, colors, i)
    end
       
    cd_pics_str=[cd_str,'/pics'];
    cd(cd_pics_str);
    print(name,'-depsc','-r200');
    %back to workspace directory
    cd ../../../..
end

end

