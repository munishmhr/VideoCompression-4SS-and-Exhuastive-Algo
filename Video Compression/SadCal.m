function newSad = SadCal(refFrame,currentFrame)
newSad = 0;
newSad = sum(sum(refFrame(:))-sum(currentFrame(:))) / (16*16);

end