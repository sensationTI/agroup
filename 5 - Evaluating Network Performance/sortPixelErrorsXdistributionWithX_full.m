% find the errors for x pixel values on the LHS and RHS of the image plane.
% From here, create a large vector that can be used to creade a probability
% density function. Use DisplayBirdsEyeGTruthAndDet_v5 to get the
% pixPairTable variable

% range1 = 129;
range1 = 214;
% range2 = 427;
% range3 = 513;
range2 = 427;
range3 = 640;
% range2 = 481;
% range5 = 561;
% range3 = 640;

% range1Y = 195;
% range2Y = 206;
range1Y = 175;
range2Y = 512;

% % comb range 1 and 2 (241,321);
% % comb range 1 and 2 (161,241); range 5,6 (561,640)
% % comb range 1 and 2 (81,161) ; range 5,6 (401,481)
% % range1 = 81;
% % range1 = 161;
% % range1 = 241;
% range1 = 321;
% % range5 = 401;
% range2 = 481;
% % range5 = 561;
% range3 = 640;

range1pixErrX = [];
range2pixErrX = [];
range3pixErrX = [];
range4pixErrX = [];
range5pixErrX = [];
range6pixErrX = [];
range7pixErrX = [];
range8pixErrX = [];
allRange=[];

range1pixErrX1 = [];
range1pixErrX2 = [];
range1pixErrX3 = [];
range1pixErrX4 = [];

range2pixErrX1 = [];
range2pixErrX2 = [];
range2pixErrX3 = [];
range2pixErrX4 = [];

range3pixErrX1 = [];
range3pixErrX2 = [];
range3pixErrX3 = [];
range3pixErrX4 = [];

for x = 1:size(pixPairTable,1)
    for y = 1:size(pixPairTable,2)
        if size(pixPairTable{x,y}{1}{1},1)>0
            for z = 1:size(pixPairTable{x,y}{1}{1},1)
                if pixPairTable{x,y}{1}{2}(z,1)<range1
                    if pixPairTable{x,y}{1}{2}(z,2)<range1Y
                        range1pixErrX1 = [range1pixErrX1; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];  
                    elseif pixPairTable{x,y}{1}{2}(z,2)>=range1Y && pixPairTable{x,y}{1}{2}(z,2)<=range2Y
                        range1pixErrX2 = [range1pixErrX2; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                     elseif pixPairTable{x,y}{1}{2}(z,2)>=range2Y && pixPairTable{x,y}{1}{2}(z,2)<=range3Y
%                         range1pixErrX3 = [range1pixErrX3; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                     elseif pixPairTable{x,y}{1}{2}(z,2)>=range3Y && pixPairTable{x,y}{1}{2}(z,2)<=range4Y
%                         range1pixErrX4 = [range1pixErrX4; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];   
                    end
                elseif pixPairTable{x,y}{1}{2}(z,1)>=range1 && pixPairTable{x,y}{1}{2}(z,1)<range2
                    if pixPairTable{x,y}{1}{2}(z,2)<range1Y
                        range2pixErrX1 = [range2pixErrX1; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];  
                    elseif pixPairTable{x,y}{1}{2}(z,2)>=range1Y && pixPairTable{x,y}{1}{2}(z,2)<=range2Y
                        range2pixErrX2 = [range2pixErrX2; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                     elseif pixPairTable{x,y}{1}{2}(z,2)>=range2Y && pixPairTable{x,y}{1}{2}(z,2)<=range3Y
%                         range1pixErrX3 = [range1pixErrX3; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                     elseif pixPairTable{x,y}{1}{2}(z,2)>=range3Y && pixPairTable{x,y}{1}{2}(z,2)<=range4Y
%                         range1pixErrX4 = [range1pixErrX4; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];   
                    end
                elseif pixPairTable{x,y}{1}{2}(z,1)>=range2 && pixPairTable{x,y}{1}{2}(z,1)<=range3
                    if pixPairTable{x,y}{1}{2}(z,2)<range1Y
                        range3pixErrX1 = [range3pixErrX1; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];  
                    elseif pixPairTable{x,y}{1}{2}(z,2)>=range1Y && pixPairTable{x,y}{1}{2}(z,2)<=range2Y
                        range3pixErrX2 = [range3pixErrX2; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                     elseif pixPairTable{x,y}{1}{2}(z,2)>=range2Y && pixPairTable{x,y}{1}{2}(z,2)<=range3Y
%                         range1pixErrX3 = [range1pixErrX3; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                     elseif pixPairTable{x,y}{1}{2}(z,2)>=range3Y && pixPairTable{x,y}{1}{2}(z,2)<=range4Y
%                         range1pixErrX4 = [range1pixErrX4; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];   
                    end
                 
%                 elseif pixPairTable{x,y}{1}{2}(z,1)>=range1 && pixPairTable{x,y}{1}{2}(z,1)<=range2
%                     range2pixErrX = [range2pixErrX; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,1)>=range2 && pixPairTable{x,y}{1}{2}(z,1)<range3
%                     range3pixErrX = [range3pixErrX; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,1)>=range3 && pixPairTable{x,y}{1}{2}(z,1)<range4
%                     range4pixErrX = [range4pixErrX; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,1)>=range4 && pixPairTable{x,y}{1}{2}(z,1)<range5
%                     range5pixErrX = [range5pixErrX; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,1)>=range5 && pixPairTable{x,y}{1}{2}(z,1)<range6
%                     range6pixErrX = [range6pixErrX; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,1)>=range6 && pixPairTable{x,y}{1}{2}(z,1)<range7
%                     range7pixErrX = [range7pixErrX; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];    
%                 elseif pixPairTable{x,y}{1}{2}(z,1)>=range7 && pixPairTable{x,y}{1}{2}(z,1)<range8
%                     range8pixErrX = [range8pixErrX; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
                end
                allRange = [allRange; (pixPairTable{x,y}{1}{2}(z,2)-pixPairTable{x,y}{1}{1}(z,2))];
                if abs((pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1)))>100
                    stop = 1
                end
            end
        end
    end
end

legendVars = {'range1','range2','range3','range4','range5','range6'};%,'range7','range8'};

x_values = -40:0.1:40;
pd1 = fitdist(range1pixErrX1,'Normal')
y=pdf(pd1,x_values);
figure
plot(x_values,y,'LineWidth',2)
title('Distribution for X-Pixel Error Ranges w.r.t X and Y pixel values')
hold on
pd2 = fitdist(range1pixErrX2,'Normal')
y=pdf(pd2,x_values);
plot(x_values,y,'LineWidth',2)
pd3 = fitdist(range2pixErrX1,'Normal')
y=pdf(pd3,x_values);
plot(x_values,y,'LineWidth',2)
pd4 = fitdist(range2pixErrX2,'Normal')
y=pdf(pd4,x_values);
plot(x_values,y,'LineWidth',2)
pd5 = fitdist(range3pixErrX1,'Normal')
y=pdf(pd5,x_values);
plot(x_values,y,'LineWidth',2)
pd6 = fitdist(range3pixErrX2,'Normal')
y=pdf(pd6,x_values);
plot(x_values,y,'LineWidth',2)
% pd7 = fitdist(range7pixErrX,'Normal')
% y=pdf(pd7,x_values);
% plot(x_values,y,'LineWidth',2)
% pd8 = fitdist(range8pixErrX,'Normal')
% y=pdf(pd8,x_values);
% plot(x_values,y,'LineWidth',2)
legend(legendVars,'Location', 'NorthEast')

% calc z scores:
zTopBottom1 = (pd1.mu-pd2.mu)/sqrt(pd1.sigma^2/length(range1pixErrX1)+pd2.sigma^2/length(range1pixErrX2))
zTopBottom2 = (pd3.mu-pd4.mu)/sqrt(pd3.sigma^2/length(range2pixErrX1)+pd4.sigma^2/length(range2pixErrX2))
zTopBottom3 = (pd5.mu-pd6.mu)/sqrt(pd5.sigma^2/length(range3pixErrX1)+pd6.sigma^2/length(range3pixErrX2))

ztopComp12 = (pd1.mu-pd3.mu)/sqrt(pd1.sigma^2/length(range1pixErrX1)+pd3.sigma^2/length(range2pixErrX1))
ztopComp23 = (pd3.mu-pd5.mu)/sqrt(pd3.sigma^2/length(range2pixErrX1)+pd5.sigma^2/length(range3pixErrX1))

zbottomComp12 = (pd2.mu-pd4.mu)/sqrt(pd2.sigma^2/length(range1pixErrX2)+pd4.sigma^2/length(range2pixErrX2))
zbottomComp23 = (pd4.mu-pd6.mu)/sqrt(pd4.sigma^2/length(range2pixErrX2)+pd6.sigma^2/length(range3pixErrX2))

z23 = (pd2.mu-pd3.mu)/sqrt(pd2.sigma^2/length(range1pixErrX2)+pd3.sigma^2/length(range1pixErrX3))
z34 = (pd3.mu-pd4.mu)/sqrt(pd3.sigma^2/length(range1pixErrX3)+pd4.sigma^2/length(range1pixErrX4))
z45 = (pd4.mu-pd5.mu)/sqrt(pd4.sigma^2/length(range4pixErrX)+pd5.sigma^2/length(range5pixErrX))
% z56 = (pd5.mu-pd6.mu)/sqrt(pd5.sigma^2/length(range5pixErrX)+pd6.sigma^2/length(range6pixErrX))
% z67 = (pd6.mu-pd7.mu)/sqrt(pd6.sigma^2/length(range6pixErrX)+pd7.sigma^2/length(range7pixErrX))
% z78 = (pd7.mu-pd8.mu)/sqrt(pd7.sigma^2/length(range7pixErrX)+pd8.sigma^2/length(range8pixErrX))
