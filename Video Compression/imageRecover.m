function imageRec = imageRecover(refFrame,motionVectorX,motionVectorY)
mbSize = 16;
row = 352;
col = 288;
for pI = 1 : mbSize : row-mbSize+1
    for pJ = 1 : mbSize : col-mbSize+1
        if(motionVectorX(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16))==-14 ...
                || motionVectorX(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16))==-14)
            motionVectorX(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16)) = 0; ...
                motionVectorY(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16)) =0 ;
        end
     imageRec(pI:pI+mbSize-1,pJ:pJ+mbSize-1) = ...
         refFrame(pI+motionVectorX(floor(pI/16)+mod(pI,16),...
         floor(pJ/16)+mod(pJ,16)):pI+motionVectorX(floor(pI/16)+mod(pI,16),...
         floor(pJ/16)+mod(pJ,16))+mbSize-1, ...
         pJ+motionVectorY(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16))...
     :pJ+motionVectorY(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16))+mbSize-1);
    end
end
end