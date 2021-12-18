
data = load("ex1data1.txt");
X = data(:,1);
Y = data(:,2);
M = length(Y);
plot(X,Y,'r.','MarkerSize',10);
ylabel('Profit');
xlabel('Population');
