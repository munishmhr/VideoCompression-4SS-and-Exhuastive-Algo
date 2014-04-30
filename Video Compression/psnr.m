
readerobj = VideoReader('SelfOriginal.mp4');
numFrames = get(readerobj, 'numberOfFrames');
for k = 1 : numFrames
    vidFrames = read(readerobj,k);
    orig(k).cdata = vidFrames;
    orig(k).colormap = [];
end

for i = 1 : numFrames
  I=orig(i).cdata;
  R=I(:,:,1); G=I(:,:,2); B=I(:,:,3);
  I = .299*R + .587*G + .114*B;
  or(:,:,i) = imresize(I, [352 288]);
end

readerobj = VideoReader('SelfdecodedTSS.avi');
numFrames = get(readerobj, 'numberOfFrames');
for k = 1 : numFrames
    vidFrames = read(readerobj,k);
    compi(k).cdata = vidFrames;
    compi(k).colormap = [];
end

for i = 1 : numFrames
  I=compi(i).cdata;
  R=I(:,:,1); G=I(:,:,2); B=I(:,:,3);
  I = .299*R + .587*G + .114*B;
  com(:,:,i) = imresize(I, [352 288]);
end

o=or(:,:,11); c= com(:,:,11);
mse = (o(:) - c(:)) .^ 2;
mse = sum(mse(:)) / (352*288);
psnr1 = 10 * log10( double(max(o(:)))^2 / mse)
