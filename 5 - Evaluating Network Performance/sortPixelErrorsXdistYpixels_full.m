% find the errors for x pixel values on the LHS and RHS of the image plane.
% From here, create a large vector that can be used to creade a probability
% density function. Use DisplayBirdsEyeGTruthAndDet_v5 to get the
% pixPairTable variable

% desired covariance pixel ranges
% first range (horizon and pixels with massive errors (>10m) when wrong)
% % comb 1 and 2 1 = 168; 2 = 195
% % comb 2 and 3
% % comb 3 and 4
% % comb 4 and 5
% % comb range 3 and 4, 8 and 9
% % comb range 1 and 2, range 4 and 5
% % range1 = 161;
% % range1 = 165;
% % range1 = 168;
% % range2 = 172;
% % range4 = 175;
% % range3 = 178;
% % range3 = 182;
% % 14.9 to 19.9m
% % range4 = 188;
% % 5.0 to 14.9m
% range1 = 195;
% % 1.1m to 5.0m
% range2 = 206;
% % 1.1m to 5.0m
% % range8 = 223;
% % range12 = 235;
% % 1.1m to 5.0m
% % range12 = 253;
% % 1.1m to 5.0m
% range3 = 324;
% % 1.1m to 5.0m
% range4 = 512;

% range1 = 161;
% range1 = 165;
% range1 = 168;
% range4 = 172;
range1 = 175;
% range2 = 178;
% range2 = 182;
% 14.9 to 19.9m
% range2 = 188;
% 5.0 to 14.9m
% range6 = 195;
% 1.1m to 5.0m
% range5 = 206;
% 1.1m to 5.0m
% range10 = 223;
% 1.1m to 5.0m
% range9 = 253;
% 1.1m to 5.0m
% range13 = 324;
% 1.1m to 5.0m
range2 = 512;


% % range1 = 161;
% % range2 = 165;
% % range1 = 168;
% % range4 = 172;
% % range4 = 175;
% % range1 = 178;
% % range5 = 182;
% % 14.9 to 19.9m
% % range1 = 188;
% % 5.0 to 14.9m
% % range8 = 195;
% % 1.1m to 5.0m
% range1 = 206;
% % 1.1m to 5.0m
% range2 = 223;
% % range12 = 235;
% % 1.1m to 5.0m
% range3 = 253;
% % 1.1m to 5.0m
% % range13 = 324;
% % 1.1m to 5.0m
% range4 = 512;

% range1 = 161;
% range2 = 165;
% range3 = 168;
% range4 = 172;
% range5 = 175;
% range6 = 178;
% range7 = 182;
% % 14.9 to 19.9m
% range8 = 188;
% % 5.0 to 14.9m
% range9 = 195;
% % 1.1m to 5.0m
% range10 = 206;
% % 1.1m to 5.0m
% range11 = 223;
% % 1.1m to 5.0m
% range12 = 253;
% % 1.1m to 5.0m
% range13 = 324;
% % 1.1m to 5.0m
% range14 = 512;



range1pixErrY = [];
range2pixErrY = [];
range3pixErrY = [];
range4pixErrY = [];
range5pixErrY = [];
range6pixErrY = [];
range7pixErrY = [];
range8pixErrY = [];
range9pixErrY = [];
range10pixErrY = [];
range11pixErrY = [];
range12pixErrY = [];
range13pixErrY = [];
range14pixErrY = [];
range15pixErrY = [];
allRange = [];
allRangeLessLast2 = [];

for x = 1:size(pixPairTable,1)
    for y = 1:size(pixPairTable,2)
        if size(pixPairTable{x,y}{1}{1},1)>0
            for z = 1:size(pixPairTable{x,y}{1}{1},1)
                if pixPairTable{x,y}{1}{2}(z,2)<range1
                    range1pixErrY = [range1pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];                
                elseif pixPairTable{x,y}{1}{2}(z,2)>=range1 && pixPairTable{x,y}{1}{2}(z,2)<range2
                    range2pixErrY = [range2pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range2 && pixPairTable{x,y}{1}{2}(z,2)<range3
%                     range3pixErrY = [range3pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range3 && pixPairTable{x,y}{1}{2}(z,2)<range4
%                     range4pixErrY = [range4pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range4 && pixPairTable{x,y}{1}{2}(z,2)<=range5
%                     range5pixErrY = [range5pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range5 && pixPairTable{x,y}{1}{2}(z,2)<=range6
%                     range6pixErrY = [range6pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range6 && pixPairTable{x,y}{1}{2}(z,2)<range7
%                     range7pixErrY = [range7pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];    
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range7 && pixPairTable{x,y}{1}{2}(z,2)<=range8
%                     range8pixErrY = [range8pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];   
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range8 && pixPairTable{x,y}{1}{2}(z,2)<range9
%                     range9pixErrY = [range9pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range9 && pixPairTable{x,y}{1}{2}(z,2)<range10
%                     range10pixErrY = [range10pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range10 && pixPairTable{x,y}{1}{2}(z,2)<range11
%                     range11pixErrY = [range11pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range11 && pixPairTable{x,y}{1}{2}(z,2)<=range12
%                     range12pixErrY = [range12pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range12 && pixPairTable{x,y}{1}{2}(z,2)<=range13
%                     range13pixErrY = [range13pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range13 && pixPairTable{x,y}{1}{2}(z,2)<=range14
%                     range14pixErrY = [range14pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];   
%                 elseif pixPairTable{x,y}{1}{2}(z,2)>=range14 && pixPairTable{x,y}{1}{2}(z,2)<=range15
%                     range15pixErrY = [range15pixErrY; (pixPairTable{x,y}{1}{2}(z,1)-pixPairTable{x,y}{1}{1}(z,1))];    
                end
%                 allRange = [allRange; (pixPairTable{x,y}{1}{2}(z,2)-pixPairTable{x,y}{1}{1}(z,2))];
%                 if pixPairTable{x,y}{1}{2}(z,2)>=range6 && pixPairTable{x,y}{1}{2}(z,2)<range8
% %                     range8pixErrY = [range8pixErrY; (pixPairTable{x,y}{1}{2}(z,2)-pixPairTable{x,y}{1}{1}(z,2))];   
%                 else
%                     allRangeLessLast2 = [allRangeLessLast2; (pixPairTable{x,y}{1}{2}(z,2)-pixPairTable{x,y}{1}{1}(z,2))];
%                 end
                if abs((pixPairTable{x,y}{1}{2}(z,2)-pixPairTable{x,y}{1}{1}(z,2)))>100
                    stop = 1
                end
            end
        end
    end
end

legendVars = {'range1','range2','range3','range4','range5','range6','range7','range8','range9','range10',...
    'range11','range12'};%,'range13','range14'};
x_values = -20:0.1:20;

pd1 = fitdist(range1pixErrY,'Normal')
y=pdf(pd1,x_values);
figure
plot(x_values,y,'LineWidth',2)
title('Distribution for X-Pixel Error Ranges w.r.t. Y-Pixels')
hold on
pd2 = fitdist(range2pixErrY,'Normal')
y=pdf(pd2,x_values);
plot(x_values,y,'LineWidth',2)
% pd3 = fitdist(range3pixErrY,'Normal')
% y=pdf(pd3,x_values);
% plot(x_values,y,'LineWidth',2)
% pd4 = fitdist(range4pixErrY,'Normal')
% y=pdf(pd4,x_values);
% plot(x_values,y,'LineWidth',2)
% pd5 = fitdist(range5pixErrY,'Normal')
% y=pdf(pd5,x_values);
% plot(x_values,y,'LineWidth',2)
% pd6 = fitdist(range6pixErrY,'Normal')
% y=pdf(pd6,x_values);
% plot(x_values,y,'LineWidth',2)
% pd7 = fitdist(range7pixErrY,'Normal')
% y=pdf(pd7,x_values);
% plot(x_values,y,'LineWidth',2)
% pd8 = fitdist(range8pixErrY,'Normal')
% y=pdf(pd8,x_values);
% plot(x_values,y,'LineWidth',2)
% pd9 = fitdist(range9pixErrY,'Normal')
% y=pdf(pd9,x_values);
% plot(x_values,y,'LineWidth',2)
% pd10 = fitdist(range10pixErrY,'Normal')
% y=pdf(pd10,x_values);
% plot(x_values,y,'LineWidth',2)
% pd11 = fitdist(range11pixErrY,'Normal')
% y=pdf(pd11,x_values);
% plot(x_values,y,'LineWidth',2)
% pd12 = fitdist(range12pixErrY,'Normal')
% y=pdf(pd12,x_values);
% plot(x_values,y,'LineWidth',2)
% pd13 = fitdist(range13pixErrY,'Normal')
% y=pdf(pd13,x_values);
% plot(x_values,y,'LineWidth',2)
% pd14 = fitdist(range14pixErrY,'Normal')
% y=pdf(pd14,x_values);
% plot(x_values,y,'LineWidth',2)
% pd = fitdist(range15pixErrY,'Normal')
% y=pdf(pd,x_values);
% plot(x_values,y,'LineWidth',2)
legend(legendVars,'Location', 'NorthEast')

% calc z scores:
z12 = (pd1.mu-pd2.mu)/sqrt(pd1.sigma^2/length(range1pixErrY)+pd2.sigma^2/length(range2pixErrY))
% z23 = (pd2.mu-pd3.mu)/sqrt(pd2.sigma^2/length(range2pixErrY)+pd3.sigma^2/length(range3pixErrY))
% z34 = (pd3.mu-pd4.mu)/sqrt(pd3.sigma^2/length(range3pixErrY)+pd4.sigma^2/length(range4pixErrY))
% z45 = (pd4.mu-pd5.mu)/sqrt(pd4.sigma^2/length(range4pixErrY)+pd5.sigma^2/length(range5pixErrY))
% z56 = (pd5.mu-pd6.mu)/sqrt(pd5.sigma^2/length(range5pixErrY)+pd6.sigma^2/length(range6pixErrY))
% z67 = (pd6.mu-pd7.mu)/sqrt(pd6.sigma^2/length(range6pixErrY)+pd7.sigma^2/length(range7pixErrY))
% z78 = (pd7.mu-pd8.mu)/sqrt(pd7.sigma^2/length(range7pixErrY)+pd8.sigma^2/length(range8pixErrY))
% z89 = (pd8.mu-pd9.mu)/sqrt(pd8.sigma^2/length(range8pixErrY)+pd9.sigma^2/length(range9pixErrY))
% z910 = (pd9.mu-pd10.mu)/sqrt(pd9.sigma^2/length(range9pixErrY)+pd10.sigma^2/length(range10pixErrY))
% z1011 = (pd10.mu-pd11.mu)/sqrt(pd10.sigma^2/length(range10pixErrY)+pd11.sigma^2/length(range11pixErrY))
% z1112 = (pd11.mu-pd12.mu)/sqrt(pd11.sigma^2/length(range11pixErrY)+pd12.sigma^2/length(range12pixErrY))
% z1213 = (pd12.mu-pd13.mu)/sqrt(pd12.sigma^2/length(range12pixErrY)+pd13.sigma^2/length(range13pixErrY))
% z1314 = (pd13.mu-pd14.mu)/sqrt(pd13.sigma^2/length(range13pixErrY)+pd14.sigma^2/length(range14pixErrY))
