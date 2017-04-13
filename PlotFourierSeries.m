function PlotFourierSeries(a, b, label)
    t = linspace(0, 2*pi, 1000);
    y = 0;
    for k = 1:length(a)
        y = y + a(k)*exp(1i*k*t) + b(k)*exp(-1i*k*t);
        %y = y + a(k)*cos(k*t) + 1i*conj(a(k))*sin(k*t);
    end
    plot(y*exp(-1i*pi/2));
    title(sprintf('Fourier Series Expansion of Character %d, %d Coefficients', label, 10))
    xlabel('Re(z)')
    ylabel('Im(z)')
    figure;
    t = linspace(0, 2*pi, 1000);
    y = 0;
    for k = 1:30
        y = y + a(k)*exp(1i*k*t) + b(k)*exp(-1i*k*t);
        %y = y + a(k)*cos(k*t) + 1i*conj(a(k))*sin(k*t);
    end
    plot(y*exp(-1i*pi/2));
    title(sprintf('Fourier Series Expansion of Character %d, %d Coefficients', label, 30))
    xlabel('Re(z)')
    ylabel('Im(z)')
    figure;
    t = linspace(0, 2*pi, 1000);
    y = 0;
    for k = 1:10
        y = y + a(k)*exp(1i*k*t) + b(k)*exp(-1i*k*t);
        %y = y + a(k)*cos(k*t) + 1i*conj(a(k))*sin(k*t);
    end
    plot(y*exp(-1i*pi/2));
    title(sprintf('Fourier Series Expansion of Character %d, %d Coefficients', label, length(a)))
    xlabel('Re(z)')
    ylabel('Im(z)')
end