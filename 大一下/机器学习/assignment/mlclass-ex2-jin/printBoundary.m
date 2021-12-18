function printBoundary(theta)
x = linspace(30, 100, 100);
y = linspace(30, 100, 100);
n = length(x);
z = zeros(n,n);
for i = 1 : n
    for j = 1 : n 
        z(i,j) =  [1,x(i),y(j),x(i)^2,y(j)^2]*theta;
    end
end
contour(x,y,z);
end