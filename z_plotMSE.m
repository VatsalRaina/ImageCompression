
x = [0,1,2,3,4];
y1 = [1,1.33,1.39,1.32,1.25];
y2 = [1,1.393,1.539,1.548,1.549];
y3 = [1,1.276,1.331,1.285,1.221];
y4 = [1,1.289,1.41,1.421,1.419];

figure
plot(x,y1,x,y2,x,y3,x,y4)
title("Compression ratios for different compression schemes")
xlabel("Number of layers")
ylabel("Compression ratio")

legend('3-tap: Const step size','3-tap: Equal MSE','5-tap: Const step size','5-tap: Equal MSE')




