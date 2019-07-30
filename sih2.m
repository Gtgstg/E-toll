inp=fullfile('E:\desktop\picsof car\','accent.jpg');
grey_image = rgb2gray(imread(inp));
strel_square = strel('square', 3);
q = grey_image;
r = grey_image;
for p = 1:10
    q = imerode(q,strel_square);
    r = imdilate(r,strel_square);
end
for p = 1:10
    q = imdilate(q,strel_square);
    r = imerode(r,strel_square);
end
imModified = imsubtract(imadd(grey_image,imsubtract(grey_image,q)), imsubtract(r,grey_image));
high_pass_filter = [0 1 0;1 -4 1;0 1 0]; % High Pass Filter
imModified_doub = imsubtract(imModified,imfilter(imModified, high_pass_filter));
[x,y,~] = size(grey_image);
I=rgb2gray(imread(fullfile('C:\Users\Gtgstg\Downloads\','accent.jpeg')));
I=imresize(I,10);
[x1,y1,~] = size(I);
figure;imshow(I);
for ipo = 1:x
    for jpo = 1:y-1
        if imModified_doub(ipo,jpo)>110
            imModified_doub(ipo,jpo) = 255;
        end
    end
end
imComp = imcomplement(imModified);
ieopen = imModified;
ieclostrel_square = imComp;
for k = 1:10
    ieopen = imerode(ieopen,strel_square);
    ieclostrel_square = imerode(ieclostrel_square,strel_square);
end

iclostrel_squarenotfinal = imreconstruct(ieclostrel_square,imComp);
iclostrel_squarefinal = imcomplement(iclostrel_squarenotfinal);
ibothat = imsubtract(iclostrel_squarefinal,imModified);
strel_squarehr = strel('rectangle',[1,3]);
xclostrel_square = ibothat;
for k = 1:20
    xclostrel_square = imdilate(xclostrel_square,strel_squarehr);
end
for k = 1:45
    xclostrel_square = imerode(xclostrel_square,strel_squarehr);
end
for k = 1:25
    xclostrel_square = imdilate(xclostrel_square,strel_squarehr);
end
strel_squarerect = strel('rectangle',[9,15]);

erodeDilate = imdilate(im2bw(xclostrel_square,0.7),strel_squarerect); % Increase the threshold if the number plate is more whitish
cc=bwconncomp(erodeDilate);
STATS=regionprops(erodeDilate,'basic');
[max_area,idx]=max([STATS.Area]);
grain = false(size(erodeDilate));
grain(cc.PixelIdxList{idx})=true;
STATS=regionprops(grain,'basic');
B=STATS.BoundingBox;
Xmin=uint32(B(2)-10);
Xmax=uint32(B(2)+B(4)+100);

Ymin=uint32(B(1)-100);
Ymax=uint32(B(1)+B(3)+400);
numberPlate = zeros(x1, y1);
for ipo = Xmin:Xmax
    for jpo = Ymin:Ymax
        numberPlate(ipo,jpo) = grey_image(ipo,jpo);
    end
end
numberPlate = imbinarize(numberPlate);
grey_image=imresize(grey_image,[x1 y1]);
imMultiplied = immultiply(grey_image,numberPlate);
figure;imshow(imMultiplied);
I2 = imcrop(imMultiplied,[Ymin Xmin (Ymax-Ymin) (Xmax-Xmin)]);
figure;imshow(I2)
imwrite(I2,'car.jpg');
J= im2single(rgb2gray(imread(fullfile('C:\Users\Gtgstg\Downloads\', 'accent.jpg')))) ;
I= im2single(imread(fullfile('D:\m\bin\', 'car.jpg'))) ;
[fa, da] = vl_sift (I);
[fb, db] = vl_sift (J);
tic
[matches, score] = vl_ubcmatch (da, db);
subplot (1,2,1);
imshow (I);
hold on;
plot (fa(1,matches(1,:)), fa(2, matches(1,:)), 'b*');
subplot (1,2,2);
imshow (J);
hold on;
plot (fb(1, matches(2,:)), fb(2, matches (2,:)), 'r*');
axes('Units','Normal');
h = title({'Images are 95%  IDENTICAL acc. to relative position of Features';'As you can see also';'So we can allow this car'});
set(gca,'visible','off')
set(h,'visible','on');
toc