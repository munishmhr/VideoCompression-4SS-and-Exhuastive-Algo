function [motionVectorX,motionVectorY]  = motionEstimationES(refFrame,curFrame)

row = 352;
col= 288;
p=14;
mbSize = 16;
newSad=0;
for pI = 1 : mbSize : row-mbSize+1
    for pJ = 1 : mbSize : col-mbSize+1
        minSad=10000000000000000000000000000000000000000000000000000000000;
        mX=0;
        mY=0;
        for rI = -p: 1 : p
            for rJ = -p : 1 : p 
               if(pI+rI > 0 && pJ+rJ > 0 && pI+rI+mbSize-1 <=row && pJ+rJ+mbSize-1 <= col )                      
                   newSad = SadCal(curFrame(pI : pI+mbSize-1 , pJ : pJ+mbSize-1),...
                       refFrame(pI+rI : pI+rI+mbSize-1 , pJ+rJ : pJ+rJ+mbSize-1));
               end
               if(newSad<minSad)
                 minSad = newSad;
                 mX = rI;
                 mY = rJ;
              end
            end
        end
        motionVectorX(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16)) = mX ;
        motionVectorY(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16)) = mY ;
    end
   
end

end