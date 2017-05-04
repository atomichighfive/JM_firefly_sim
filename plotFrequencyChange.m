function [ ] = plotFrequencyChange( states )
% plot frequency change over simulationsteps for every oscillator in states.

    for i=1:size(states(:,:,:),2)
        plot(linspace(1,size(states(:,:,:),1),size(states(:,:,:),1)),states(:,i,6))
        hold on
    end

end