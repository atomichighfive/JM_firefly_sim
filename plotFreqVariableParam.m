function [ ] = plotFreqVariableParam( name )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
colors=['b', 'r', 'y', 'k', 'g', 'm', 'c', 'w'];
% G? in i sparade simuleringar
cd_str=['~/Documents/JM_Firefly_Sim/output/simulations/',name];
if exist(cd_str, 'dir') == 7
    cd(cd_str);
    %lista simuleringar
    dirs=dir;
    dirs(3).name;
    % (. .. sim1 sim2 sim3) i dir
    figure('Name', 'Frequencychange for oscillators')
    for i=0:size(dirs,1)-4
        if exist(cd_str, 'dir') == 7
            cd(cd_str);
        end
        load([name num2str(i,'%03d') '.mat'])
        cd ..
        plotFrequencyChange(states, colors, i)
    end
       
    cd_pics_str=[cd_str,'/pics'];
    cd(cd_pics_str);
    print(name,'-depsc','-r200');
    %ut till r?tt dir
    cd ../../../..
end

end

