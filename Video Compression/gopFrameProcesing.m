function [motionVectorX,motionVectorY] = gopFrameProcesing(gopFrames,noOfFrames)
for nF = 1:noOfFrames-1
    [motionVectorX(:,:,nF),motionVectorY(:,:,nF)]=motionEstimationES(gopFrames(:,:,nF),gopFrames(:,:,nF+1));
end
end