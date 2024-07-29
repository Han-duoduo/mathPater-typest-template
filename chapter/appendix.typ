#import "../template/template.typ":*

#let code1 =  ```matlab
clc;clear;close all;
%导入数据
data=importdata('DATA.mat');%需要优化小区编号，频点及现网PCI的信息
MR1=importdata('MR1.mat');%有关小区间冲突及干扰MR值
MR2=importdata('MR2.mat');%有关小区间混淆MR值
A=zeros(2067); B=A; C=B;%预先分配A，B，C矩阵维度

%数据清理
id=ismember(MR1(:,1:2),data(:,1));%将附件一和附件二进行比较，找到不需要优化小区并用0-1表示
[row,~]=find(~id);%找出所有0所在的行数
row=sort(row);%将行数升序处理
MR1(row,:)=[];%删去0所在的行数只保留优化小区

id=ismember(MR2(:,1:2),data(:,1));%将附件一和附件三进行比较，同上
[row,~]=find(~id);
row=sort(row);
MR2(row,:)=[];

%构造矩阵
LN=1;%LN为每次筛选行数的开始，随循环次数增多，减少搜索量
for i =1:2067
    N=ismember(MR1(:,1),data(i,1));%查找附件二中每一个主控小区的邻小区个数，用0—1表示
    if sum(N)~=0         %若邻小区个数不为0
        N=find(N);       %则将0—1矩阵转换成具体邻小区个数
        N=N(end);
        for j =1:2067
            M=ismember(MR1(LN:N,2),data(j,1));%则记录邻小区出现在附件一当中的行数，用0—1表示
            if sum(M)==0       %若附件一按顺序当中出现的小区不在附件二中，即没有MR值
                M=sum(M);      %令M=0
            else               %若存在于附件一当中
                M=find(M)+LN-1;%将0—1的矩阵转换成具体的行数 
            end
            if data(j,2)==data(i,2)%再判断主控小区与邻小区是否频点相同
                if M==0            %若相同，但附件二中没有给出MR值，则认为0
                    A(i,j)=0;
                else               %若相同，则将附件二的对应冲突MR值填入冲突矩阵
                    A(i,j)=MR1(M,3);
                end
            else                   %若频点不同，则两者之间不发生干扰，则为0
            A(i,j)=0;
            end
        end
            LN=find(ismember(MR1(:,1),MR1(LN,1)));%则将LN值适量增加，减少搜索量
            LN=LN(end)+1
    else                 %若邻小区个数为0，则不与任何小区干扰，则为0
        A(i,:)=0;        
    end
end
```

#let code2 = ```matlab
clc;clear;close all;

%导入数据
data=importdata('DATA.mat');%需要优化小区编号，频点及现网PCI的信息
MR1=importdata('MR1.mat');%有关小区间冲突及干扰MR值
MR2=importdata('MR2.mat');%有关小区间混淆MR值
A=zeros(2067); B=A; C=B;%预先分配A，B，C矩阵维度

%数据清理
id=ismember(MR1(:,1:2),data(:,1));%将附件一和附件二进行比较，找到不需要优化小区并用0-1表示
[row,~]=find(~id);%找出所有0所在的行数
row=sort(row);%将行数升序处理
MR1(row,:)=[];%删去0所在的行数只保留优化小区

id=ismember(MR2(:,1:2),data(:,1));%将附件一和附件三进行比较，同上
[row,~]=find(~id);
row=sort(row);
MR2(row,:)=[];

%构造矩阵
LN=1;%LN为每次筛选行数的开始，随循环次数增多，减少搜索量
for i =1:2067
    N=ismember(MR2(:,1),data(i,1));%查找附件三中每一个主控小区的邻小区个数，用0—1表示
    if sum(N)~=0         %若邻小区个数不为0
        N=find(N);       %则将0—1矩阵转换成具体邻小区个数
        N=N(end);
        for j =1:2067
            M=ismember(MR2(LN:N,2),data(j,1));%则记录邻小区出现在附件一当中的行数，用0—1表示
            if sum(M)==0       %若附件一按顺序当中出现的小区不在附件三中，即没有MR值
                M=sum(M);      %令M=0
            else               %若存在于附件一当中
                M=find(M)+LN-1;%将0—1的矩阵转换成具体的行数 
            end
            if data(j,2)==data(i,2)%再判断主控小区与邻小区是否频点相同
                if M==0            %若相同，但附件三中没有给出MR值，则认为0
                    B(i,j)=0;
                else               %若相同，则将附件三的对应混淆MR值填入混淆矩阵
                    B(i,j)=MR2(M,3);
                end
            else                   %若频点不同，则两者之间不发生干扰，则为0
            B(i,j)=0;
            end
        end
            LN=find(ismember(MR2(:,1),MR2(LN,1)));%则将LN值适量增加，减少搜索量
            LN=LN(end)+1
    else                 %若邻小区个数为0，则不与任何小区混淆，则为0
        B(i,:)=0;        
    end
end

```

#let code3 = ```matlab
clc;clear;close all;

%导入数据
data=importdata('DATA.mat');%需要优化小区编号，频点及现网PCI的信息
MR1=importdata('MR1.mat');%有关小区间冲突及干扰MR值
MR2=importdata('MR2.mat');%有关小区间混淆MR值
A=zeros(2067); B=A; C=B;%预先分配A，B，C矩阵维度

%数据清理
id=ismember(MR1(:,1:2),data(:,1));%将附件一和附件二进行比较，找到不需要优化小区并用0-1表示
[row,~]=find(~id);%找出所有0所在的行数
row=sort(row);%将行数升序处理
MR1(row,:)=[];%删去0所在的行数只保留优化小区

id=ismember(MR2(:,1:2),data(:,1));%将附件一和附件三进行比较，同上
[row,~]=find(~id);
row=sort(row);
MR2(row,:)=[];

%构造矩阵
LN=1;%LN为每次筛选行数的开始，随循环次数增多，减少搜索量
for i =1:2067
    N=ismember(MR1(:,1),data(i,1));%查找附件二中每一个主控小区的邻小区个数，用0—1表示
    if sum(N)~=0         %若邻小区个数不为0
        N=find(N);       %则将0—1矩阵转换成具体邻小区个数
        N=N(end);
        for j =1:2067
            M=ismember(MR1(LN:N,2),data(j,1));%则记录邻小区出现在附件一当中的行数，用0—1表示
            if sum(M)==0       %若附件一按顺序当中出现的小区不在附件二中，即没有MR值
                M=sum(M);      %令M=0
            else               %若存在于附件一当中
                M=find(M)+LN-1;%将0—1的矩阵转换成具体的行数 
            end
            if data(j,2)==data(i,2)%再判断主控小区与邻小区是否频点相同
                if M==0            %若相同，但附件二中没有给出MR值，则认为0
                    C(i,j)=0;
                else               %若相同，则将附件二的对应干扰MR值填入干扰矩阵
                    C(i,j)=MR1(M,4);
                end
            else                   %若频点不同，则两者之间不发生干扰，则为0
            C(i,j)=0;
            end
        end
            LN=find(ismember(MR1(:,1),MR1(LN,1)));%则将LN值适量增加，减少搜索量
            LN=LN(end)+1
    else                 %若邻小区个数为0，则不与任何小区干扰，则为0
        C(i,:)=0;        
    end
end

```

#let code4 = ```matlab
clc,clear,close all;
A=importdata('A.mat');
B=importdata('B.mat');
C=importdata('C.mat');

% 蒙特卡洛模拟
n = 10^5; % 模拟次数
sol = []; % 保存满足约束条件的解
fval = +inf; % 保存最小值
for i = 1:n
    rng('shuffle')
    a=randi([0,1007],1,2067);
    b=zeros(1008,2067);
    x=zeros(2067);
    y=zeros(2067);
    for k=0:1007     %将相同PCI的小区筛选出来
        b=find(a==k);%得到相同小区的序号
        x(b,b)=1;    %创建x矩阵
    end
    c=mod(a,3);%将现有PCI进行mod 3处理
    for m=0:2        %将相同mod值的小区筛选出来
        d=find(c==m);%得到相同小区的序号
        y(d,d)=1;    %创建y矩阵
    end
    s1=sum(sum(x.*A));
    s2=sum(sum(x.*B));
    s3=sum(sum(y.*C));
    f=s1+s2+s3 % 计算目标函数值
    if f < fval % 更新最小值
        fval = f;
        sol = a;
    end
end


```

#let code5 = ```matlab
clc,clear,close all;
A=importdata('A.mat');
B=importdata('B.mat');
C=importdata('C.mat');

% 蒙特卡洛模拟
n = 10^2; % 模拟次数
sol1 = [];% 保存满足约束条件的解
sol2 = [];
sol3 = [];
fval1 = inf; % 保存最小值
fval2 = inf;
fval3 = +inf;
x1=[];%保存x矩阵
for i = 1:n
    rng('shuffle')
    a=randi([0,1007],1,2067);
    b=zeros(1008,2067);
    x=zeros(2067);
    
    for k=0:1007     %将相同PCI的小区筛选出来
        b=find(a==k);%得到相同小区的序号
        x(b,b)=1;    %创建x矩阵
    end
    s1=sum(sum(x.*A));%用x矩阵求得冲突数
    if s1 < fval1 % 更新最小值
        fval1 = cat(1,fval1,s1);%记录每次更新的冲突数
        sol1 = cat(1,sol1,a);   %记录每次更新对应的PCI值
        x1=cat(1,x1,x);         %记录每次更新对应的x矩阵
    else 
        if s1<80000
            fval1 = cat(1,fval1,s1);%记录每次更新的冲突数
            sol1 = cat(1,sol1,a);   %记录每次更新对应的PCI值
            x1=cat(1,x1,x);         %记录每次更新对应的x矩阵
        end
    end
    hold on
        scatter(0,s1)%做出每次冲突的图像
        
        xlim([-1,1]);
        ylim([30000,90000]);
end
fval1(1,:)=[];

for q=1:5
    s2=sum(sum(x1(end-(6-q)*2067+1:end-(5-q)*2067,:).*B))%取靠前5组的PCI进行混淆数的计算
    if s2<fval2% 更新最小数
        fval2=cat(1,fval2,s2);%记录每次更新的混淆数
        sol2=cat(1,sol2,sol1(end-(5-q),:));%记录每次对应的PCI值
    else
        if s2<300000
            fval2=cat(1,fval2,s2);%记录每次更新的混淆数
            sol2=cat(1,sol2,sol1(end-(5-q),:));%记录每次对应的PCI值
        end
    end
end
fval2(1,:)=[];
for j=1:3      %取靠前三组的PCI进行干扰数的计算
    c=mod(sol2(end-(3-j),:),3);%将现有PCI进行mod 3处理
    y=zeros(2067);
    for m=0:2        %将相同mod值的小区筛选出来
        d=find(c==m);%得到相同小区的序号
        y(d,d)=1;    %创建y矩阵
    end
    s3=sum(sum(y.*C))%用y矩阵计算此时的干扰数
    if s3<fval3% 更新最小数
        fval3=s3;%记录此时的最小干扰数
        sol3=sol2(end-(3-j),:);%记录此时的PCI
    end
    y=zeros(2067);
end


```

#let code6=```matlab
clc,clear,close all;
all=importdata('all.mat');
MR1=importdata('MR1.mat');
MR2=importdata('MR2.mat');

%清洗数据
id=ismember(all(:,1),MR1(:,1:2));%将附件一与附件二进行比较，在附件一中用0—1标记出没有在附件二中出现过的
row=find(~id);
all(row,:)=[];
data=all;%删去所有附件一中其他小区的数据
A=zeros(2857);

%构造矩阵
LN=1;%LN为每次筛选行数的开始，随循环次数增多，减少搜索量
for i =1:2857
    N=ismember(MR1(:,1),data(i,1));%查找附件二中每一个主控小区的邻小区个数，用0—1表示
    if sum(N)~=0         %若邻小区个数不为0
        N=find(N);       %则将0—1矩阵转换成具体邻小区个数
        N=N(end);
        for j =1:2857
            M=ismember(MR1(LN:N,2),data(j,1));%则记录邻小区出现在附件一当中的行数，用0—1表示
            if sum(M)==0       %若附件一按顺序当中出现的小区不在附件二中，即没有MR值
                M=sum(M);      %令M=0
            else               %若存在于附件一当中
                M=find(M)+LN-1;%将0—1的矩阵转换成具体的行数 
            end
            if data(j,2)==data(i,2)%再判断主控小区与邻小区是否频点相同
                if M==0            %若相同，但附件二中没有给出MR值，则认为0
                    A(i,j)=0;
                else               %若相同，则将附件二的对应冲突MR值填入冲突矩阵
                    A(i,j)=MR1(M,3);
                end
            else                   %若频点不同，则两者之间不发生干扰，则为0
            A(i,j)=0;
            end
        end
           LN=find(ismember(MR1(:,1),MR1(LN,1)));%则将LN值适量增加，减少搜索量
           LN=LN(end)+1
    else                 %若邻小区个数为0，则不与任何小区干扰，则为0
        A(i,:)=0;        
    end
end

```

#let code7 = ```matlab
clc,clear,close all;
all=importdata('all.mat');
MR1=importdata('MR1.mat');
MR2=importdata('MR2.mat');

%清洗数据
id=ismember(all(:,1),MR2(:,1:2));%将附件一与附件三进行比较，在附件一中用0—1标记出没有在附件三中出现过的
row=find(~id);
all(row,:)=[];
data=all;
B=zeros(2857);

%构造矩阵
LN=1;%LN为每次筛选行数的开始，随循环次数增多，减少搜索量
for i =1:2802
    N=ismember(MR2(:,1),data(i,1));%查找附件二中每一个主控小区的邻小区个数，用0—1表示
    if sum(N)~=0         %若邻小区个数不为0
        N=find(N);       %则将0—1矩阵转换成具体邻小区个数
        N=N(end);
        for j =1:2802
            M=ismember(MR2(LN:N,2),data(j,1));%则记录邻小区出现在附件一当中的行数，用0—1表示
            if sum(M)==0       %若附件一按顺序当中出现的小区不在附件二中，即没有MR值
                M=sum(M);      %令M=0
            else               %若存在于附件一当中
                M=find(M)+LN-1;%将0—1的矩阵转换成具体的行数 
            end
            if data(j,2)==data(i,2)%再判断主控小区与邻小区是否频点相同
                if M==0            %若相同，但附件二中没有给出MR值，则认为0
                    B(i,j)=0;
                else               %若相同，则将附件二的对应冲突MR值填入冲突矩阵
                    B(i,j)=MR2(M,3);
                end
            else                   %若频点不同，则两者之间不发生干扰，则为0
            B(i,j)=0;
            end
        end
           LN=find(ismember(MR2(:,1),MR2(LN,1)));%则将LN值适量增加，减少搜索量
           LN=LN(end)+1
    else                 %若邻小区个数为0，则不与任何小区干扰，则为0
        B(i,:)=0;        
    end
end


```

#let code8 = ```matlab
clc,clear,close all;
all=importdata('all.mat');
MR1=importdata('MR1.mat');
MR2=importdata('MR2.mat');

%清洗数据
id=ismember(all(:,1),MR1(:,1:2));%将附件一与附件二进行比较，在附件一中用0—1标记出没有在附件二中出现过的
row=find(~id);
all(row,:)=[];
data=all;%删去所有附件一中其他小区的数据
C=zeros(2857);

%构造矩阵
LN=1;%LN为每次筛选行数的开始，随循环次数增多，减少搜索量
for i =1:2857
    N=ismember(MR1(:,1),data(i,1));%查找附件二中每一个主控小区的邻小区个数，用0—1表示
    if sum(N)~=0         %若邻小区个数不为0
        N=find(N);       %则将0—1矩阵转换成具体邻小区个数
        N=N(end);
        for j =1:2857
            M=ismember(MR1(LN:N,2),data(j,1));%则记录邻小区出现在附件一当中的行数，用0—1表示
            if sum(M)==0       %若附件一按顺序当中出现的小区不在附件二中，即没有MR值
                M=sum(M);      %令M=0
            else               %若存在于附件一当中
                M=find(M)+LN-1;%将0—1的矩阵转换成具体的行数 
            end
            if data(j,2)==data(i,2)%再判断主控小区与邻小区是否频点相同
                if M==0            %若相同，但附件二中没有给出MR值，则认为0
                    C(i,j)=0;
                else               %若相同，则将附件二的对应冲突MR值填入冲突矩阵
                    C(i,j)=MR1(M,4);
                end
            else                   %若频点不同，则两者之间不发生干扰，则为0
            C(i,j)=0;
            end
        end
           LN=find(ismember(MR1(:,1),MR1(LN,1)));%则将LN值适量增加，减少搜索量
           LN=LN(end)+1
    else                 %若邻小区个数为0，则不与任何小区干扰，则为0
        C(i,:)=0;        
    end
end

```

#let code9 = ```matlab
clc,clear,close all;
A=importdata('Q3A.mat');
B=importdata('Q3B.mat');
C=importdata('Q3C.mat');

% 蒙特卡洛模拟
n = 10^4; % 模拟次数
sol = []; % 保存满足约束条件的解
fval = +inf; % 保存最小值
for i = 1:n
    rng('shuffle')
    a=randi([0,1007],1,2857);
    b=zeros(1008,2857);
    x=zeros(2857);
    y=zeros(2857);
    for k=0:1007     %将相同PCI的小区筛选出来
        b=find(a==k);%得到相同小区的序号
        x(b,b)=1;    %创建x矩阵
    end
    c=mod(a,3);%将现有PCI进行mod 3处理
    for m=0:2        %将相同mod值的小区筛选出来
        d=find(c==m);%得到相同小区的序号
        y(d,d)=1;    %创建y矩阵
    end
    s1=sum(sum(x.*A));
    s2=sum(sum(x.*B));
    s3=sum(sum(y.*C));
    f=s1+s2+s3 % 计算目标函数值
    if f < fval % 更新最小值
        fval = f;
        sol = a;
    end
end

```

#let code10 = ```matlab
clc,clear,close all;
A=importdata('Q3A.mat');
B=importdata('Q3B.mat');
C=importdata('Q3C.mat');

% 蒙特卡洛模拟
n = 10^4; % 模拟次数
sol1 = [];% 保存满足约束条件的解
sol2 = [];
sol3 = [];
fval1 = inf; % 保存最小值
fval2 = inf;
fval3 = +inf;
x1=[];%保存x矩阵
for i = 1:n
    rng('shuffle')
    a=randi([0,1007],1,2857);
    b=zeros(1008,2857);
    x=zeros(2857);
    for k=0:1007     %将相同PCI的小区筛选出来
        b=find(a==k);%得到相同小区的序号
        x(b,b)=1;    %创建x矩阵
    end
    s1=sum(sum(x.*A));%用x矩阵求得冲突数
    if s1 < fval1 % 更新最小值
        fval1 = cat(1,fval1,s1);%记录每次更新的冲突数
        sol1 = cat(1,sol1,a);   %记录每次更新对应的PCI值
        x1=cat(1,x1,x);         %记录每次更新对应的x矩阵
    else 
        if s1<80000
            fval1 = cat(1,fval1,s1);%记录每次更新的冲突数
            sol1 = cat(1,sol1,a);   %记录每次更新对应的PCI值
            x1=cat(1,x1,x);         %记录每次更新对应的x矩阵
        end
    end
    hold on
    scatter(0,s1)%做出每次冲突的图像
    xlim([-1,1]);
    ylim([50000,120000]);
end
fval1(1,:)=[];

figure
for q=1:5
    s2=sum(sum(x1(end-(6-q)*2857+1:end-(5-q)*2857,:).*B))%取靠前5组的PCI进行混淆数的计算
    if s2<fval2% 更新最小数
        fval2=cat(1,fval2,s2);%记录每次更新的混淆数
        sol2=cat(1,sol2,sol1(end-(5-q),:));%记录每次对应的PCI值
    else
        if s2<1200000
            fval2=cat(1,fval2,s2);%记录每次更新的混淆数
            sol2=cat(1,sol2,sol1(end-(5-q),:));%记录每次对应的PCI值
        end
    end
    hold on
    scatter(0,s2)%做出每次冲突的图像
    xlim([-1,1]);
    ylim([900000,1500000]);
end
fval2(1,:)=[];
for j=1:3      %取靠前三组的PCI进行干扰数的计算
    c=mod(sol2(end-(3-j),:),3);%将现有PCI进行mod 3处理
    y=zeros(2857);
    for m=0:2        %将相同mod值的小区筛选出来
        d=find(c==m);%得到相同小区的序号
        y(d,d)=1;    %创建y矩阵
    end
    s3=sum(sum(y.*C))%用y矩阵计算此时的干扰数
    if s3<fval3% 更新最小数
        fval3=s3;%记录此时的最小干扰数
        sol3=sol2(end-(3-j),:);%记录此时的PCI
    end
end

```


#let codeZip = (
    问题一清洗数据加构建冲突矩阵A:code1,
    问题一洗数据加构建混淆矩阵B:code2,
    问题一清洗数据加构建干扰矩阵C:code3,
    问题一蒙特卡洛模拟进行求解:code4,
    问题二蒙特卡洛模拟求解分层多目标规划问题:code5,
    问题三清洗数据加构建冲突矩阵D:code6,
    问题三清洗数据加构建混淆矩阵E:code7,
    问题三清洗数据加构建干扰矩阵F:code8,
    问题三蒙特卡洛模拟:code9,
    问题四蒙特卡洛模拟求解分层多目标规划问题:code10
)


= 附录
// #codeAppendix(
//     code1,
//     caption: [清洗数据加构建冲突矩阵A],
// )
#for (desc,code) in codeZip{
    codeAppendix(
        code,
        caption: desc
    )
    v(2em)
}


#let code = ```cpp
#include<iostream>
using namespace std;
cout << "hello World!" << endl;
```
#codeAppendix(
    code,
    caption:[问题1的示例代码]
)




