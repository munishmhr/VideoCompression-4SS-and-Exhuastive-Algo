function [motionVectorX,motionVectorY]  = motionEstimationTSS(refFrame,curFrame)


row = 352;
col= 288;
mbSize = 16;
stepSize = 4;
newSad = 0;
for pI = 1 : mbSize : row-mbSize+1
    for pJ = 1 : mbSize : col-mbSize+1
        minSad=10000000000000000000000000000000000000000000000000000000000;
        mX=0;        mY=0;
        newCorX = pI; newCorY = pJ;
        while(stepSize >= 1)
            for rI = -stepSize: stepSize : stepSize
                for rJ = -stepSize: stepSize : stepSize
                    if(pI+rI > 0 && newCorX+rI>0 && pJ+rJ > 0 && newCorY+rJ >0 && pI+rI+mbSize-1 <=row &&...
                            newCorX+rI+mbSize-1 <=row  && pJ+rJ+mbSize-1 <= col && newCorY+rJ+mbSize-1<=col )
                        newSad = SadCal(curFrame(pI : pI+mbSize-1 , pJ : pJ+mbSize-1),...
                            refFrame(newCorX+rI : newCorX+rI+mbSize-1 , newCorY+rJ : newCorY+rJ+mbSize-1));
                    end
                    if(newSad<minSad)
                        minSad = newSad;
                        mX = rI;
                        mY = rJ;
                    end
                end
            end
            stepSize = stepSize / 2;
            newCorX = newCorX+mX;
            newCorY = newCorY+mY;
        end
      
        motionVectorX(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16)) = mX ;
        motionVectorY(floor(pI/16)+mod(pI,16),floor(pJ/16)+mod(pJ,16)) = mY ;
    end
    
end
end



