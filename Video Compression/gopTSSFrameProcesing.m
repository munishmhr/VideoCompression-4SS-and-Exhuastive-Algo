function [motionVectorX,motionVectorY] = gopTSSFrameProcesing(gopFrames,noOfFrames)
for nF = 1:noOfFrames-1
    [motionVectorX(:,:,nF),motionVectorY(:,:,nF)]=motionEstimationTSS(gopFrames(:,:,nF),gopFrames(:,:,nF+1));
end
end