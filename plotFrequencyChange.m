function [ ] = plotFrequencyChange( states, colors, color_iter)
    %figure('Name','Oscillator frequency','NumberTitle','off');
    %xlabel('Time in simulation steps');
   % ylabel('Frequency');
    for i=1:size(states(:,:,:),2)
        plot(linspace(1,size(states(:,:,:),1),size(states(:,:,:),1)),states(:,i,6),colors(color_iter+1))
        
        hold on
    end
   % legend(char(legend_a(color_iter+1)))
end