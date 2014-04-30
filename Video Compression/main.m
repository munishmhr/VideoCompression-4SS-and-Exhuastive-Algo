% readerobj = VideoReader('test.mp4');
% numFrames = get(readerobj, 'numberOfFrames');
% for k = 1 : numFrames
%     vidFrames = read(readerobj,k);
%     mov(k).cdata = vidFrames;
%     mov(k).colormap = [];

% end
%
% for i = 1 : numFrames
%   I=mov(i).cdata;
%   R=I(:,:,1); G=I(:,:,2); B=I(:,:,3);
%   I = .299*R + .587*G + .114*B;
%   framesArray(:,:,i) = imresize(I, [352 288]);
% end

fileID = fopen('akiyo_cif.yuv');

for i = 1:300
    Y(:,:,i)=fread(fileID,[352 288],'uchar');
    U(:,:,i)=fread(fileID,[352/2 288/2],'uchar');
    V(:,:,i)=fread(fileID,[352/2 288/2],'uchar');
end

framesArray = Y;

indexi = 1;
ifram = 1;
for i = 0: 30 :270
    gopFrames = framesArray(:,:,i+1:i+30);
    iFrame(:,:,ifram) = gopFrames(:,:,1);
    ifram = ifram+1;
    [mVX,mVY]=gopTSSFrameProcesing(gopFrames,30);
    for j1 = 1 : 1:29
        motionVectorX(:,:,indexi) = mVX(:,:,j1);
        motionVectorY(:,:,indexi) = mVY(:,:,j1);
        indexi = indexi +1;
    end
end


indexc=1;
for g = 1:10
  iRefFrame = iFrame(:,:,g);
  fun = @(block_struct) dct2(block_struct.data);
  iRefFrame = blockproc(iRefFrame,[8 8],fun);
  QuantRefFrame = round((8/13)*(iRefFrame./repmat(Quantization1,44,36)));
  for coloums = 1 : 8 : 352
   for rows = 1 : 8 : 288
    subZigzagArray = zigzag(QuantRefFrame(coloums:coloums+8-1,rows:rows+8-1));
    count = 0;
        p=2;
        runLenCoding = 0;
        for i = 2:1:length(subZigzagArray)
            if subZigzagArray(i) ~=0
                runLenCoding(p) = count;
                p = p+1;
                runLenCoding(p) = subZigzagArray(i);
                p = p+1;
                count = 0;
            else
                count = count +1;
            end
        end
        runLenCoding(1) = subZigzagArray(1);
        dlmwrite('runlength.txt',runLenCoding,'-append','delimiter',' ');
   end
  end

end

for r = 1: 290
    horpad = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]';
    vertpad= [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    moX = horzcat(motionVectorX(:,:,r),horpad,horpad,horpad,horpad,horpad,horpad);
    moY = horzcat(motionVectorY(:,:,r),horpad,horpad,horpad,horpad,horpad,horpad);
    iXRefFrame =  vertcat(moX,vertpad,vertpad);
    iYRefFrame =  vertcat(moY,vertpad,vertpad);
    
    fun = @(block_struct) dct2(block_struct.data);
    iXRefFrame = blockproc(iXRefFrame,[8 8],fun);
    iYRefFrame = blockproc(iYRefFrame,[8 8],fun);
    QuantRefFrameX = ((8/13)*(iXRefFrame./repmat(Quantization2,3,3)));
    QuantRefFrameY = ((8/13)*(iYRefFrame./repmat(Quantization2,3,3)));
    motionVectorXQ(:,:,r) = QuantRefFrameX(1:22,1:18);
    motionVectorYQ(:,:,r) = QuantRefFrameY(1:22,1:18);
    
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Decoding %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

indexv=1;
fDecoding = fopen('runlength.txt','r');
while ~feof(fDecoding)
for coloums = 1 : 8 : 352
   for rows = 1 : 8 : 288
       line1 = fgets(fDecoding);
       DQuantRefFrame(coloums:coloums+8-1,rows:rows+8-1) = reverseZigZag(line1);
   end
end
Decoded = (13/8)*(DQuantRefFrame.*(repmat(Quantization1,44,36)));
fun = @(block_struct) idct2(block_struct.data);
Decoded = blockproc(Decoded,[8 8],fun);
iFrames(:,:,indexv) =  Decoded;
indexv = indexv+1;
end

for r = 1: 290
    QuantRefFrameX = (13/8)*((QuantRefFrameX.*(repmat(Quantization2,3,3))));
    QuantRefFrameY = (13/8)*((QuantRefFrameY.*(repmat(Quantization2,3,3))));
    fun = @(block_struct) idct2(block_struct.data);
    QuantRefFrameX = blockproc(QuantRefFrameX,[8 8],fun);
    QuantRefFrameY = blockproc(QuantRefFrameY,[8 8],fun);
    motionVectorXD(:,:,r) = QuantRefFrameX(1:22,1:18);
    motionVectorYD(:,:,r) = QuantRefFrameY(1:22,1:18);
end

j=1;
indexa=1;
for i = 1: 1 :10
        gopFrames = iFrame(:,:,i);
        imagesD(:,:,indexa) = gopFrames;
        indexa= indexa+1;
    for j = j:1:j+28       
        imagesD(:,:,indexa) = imageRecover(gopFrames,floor(motionVectorX(:,:,j)),floor(motionVectorY(:,:,j)));
        indexa= indexa+1;
    end
    j=j+1;
end

writerObj = VideoWriter('CIFdecodedTSS');
open(writerObj);
for k = 1:300 
    imag = imagesD(:,:,k);
     writeVideo(writerObj,imag);
end
close(writerObj);

