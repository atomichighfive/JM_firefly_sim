function [ ] = showResponseCurves( )
%SHOWRESPONSECURVES Summary of this function goes here
%   Detailed explanation goes here
    fig = figure();
    maxsamples = 1000;
    samples = ceil(sqrt(maxsamples));
    mkdir output showResponseCurves;    
    X = linspace(0,1,samples);
    Y = linspace(0,1,samples);
    Z = zeros(samples, samples,3);
    [XX,YY] = meshgrid(X,Y);
    for i = 1:samples
        for j = 1:samples
            [p,f,l] = calcResponse(XX(i,j), YY(i,j));
            Z(i,j,:) = [p,f,l];
        end
    end
    
    U = [];
    V = [];
    u = linspace(0,1,maxsamples);
    for i=1:maxsamples
        U(i) = u(i);
        [p,f,l] = calcResponse(u(i),1);
        V(i,:) = [p,f,l];
    end
    
    subplot(2,2,1)
    surf(X,Y,Z(:,:,1)); axis equal
    title('Evolutionssvar');
    xlabel('Evolution');
    ylabel('Frekvens');
    zlabel('ny');
    subplot(2,2,2)
    surf(X,Y,Z(:,:,2)); axis equal
    title('Frekvenssvar');
    xlabel('Evolution');
    ylabel('Frekvens');
    zlabel('ny');
    subplot(1,1,1);
    hold on;
    %yyaxis left;
    subplot(1,2,1);
    plot(U,V(:,1)); axis equal
    ylim([0,1.1]);
    xlim([0,1]);
    xlabel('evolution');
    ylabel('svar');
    title('frekvenssvar');
    grid on
    %yyaxis right;
    subplot(1,2,2);
    plot(U,V(:,2)); axis equal
    ylim([0.8,1.3]);
    xlim([0,1]);
    xlabel('evolution');
    ylabel('svar');
    title('evolutionssvar');
    grid on;
    %title('Svar för f=1')
    print('output/showResponseCurves/curves', '-djpeg');
end

