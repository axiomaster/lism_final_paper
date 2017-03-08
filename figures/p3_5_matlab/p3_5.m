f = -5:0.01:5;
w = 20*pi;
%% 
h1 = 0.95;
h2 = 0.05;
tau1 = 0.1;
tau2 = 0.12;
subplot(2,2,1);
p1 = plot(f,sf);
p1.LineWidth = 2;
h1_h2 = repmat(h1^2+h2^2,1,1001);
rf=sf.*sqrt(h1_h2+2*h1*h2*cos(w*(tau1-tau2)*f));
hold on;
p2 = plot(f,rf);
p2.LineWidth = 2;
axis([-6 6 0 1.2])

%% 
tau1 = 0.1;
tau2 = 0.4;

subplot(2,2,2);
p1 = plot(f,sf);
p1.LineWidth = 2;
h1_h2 = repmat(h1^2+h2^2,1,1001);
rf=sf.*sqrt(h1_h2+2*h1*h2*cos(w*(tau1-tau2)*f));
hold on;
p2 = plot(f,rf);
p2.LineWidth = 2;
axis([-6 6 0 1.2])

%%
h1 = 0.49;
h2 = 0.51;
tau1 = 0.1;
tau2 = 0.12;
subplot(2,2,3);
p1 = plot(f,sf);
p1.LineWidth = 2;
h1_h2 = repmat(h1^2+h2^2,1,1001);
rf=sf.*sqrt(h1_h2+2*h1*h2*cos(w*(tau1-tau2)*f));
hold on;
p2 = plot(f,rf);
p2.LineWidth = 2;
axis([-6 6 0 1.2])

%%
tau1 = 0.1;
tau2 = 0.4;
subplot(2,2,4);
p1 = plot(f,sf);
p1.LineWidth = 2;
h1_h2 = repmat(h1^2+h2^2,1,1001);
rf=sf.*sqrt(h1_h2+2*h1*h2*cos(w*(tau1-tau2)*f));
hold on;
p2 = plot(f,rf);
p2.LineWidth = 2;
axis([-6 6 0 1.2])