
local functor = require("functor")

local ContextRecorder = {}
local ContextRecorder_mt = {
    __index = ContextRecorder;
}

function ContextRecorder.new(self, obj)
    if not obj then return nil end
    if not obj.drawingContext then return nil, "must specify drawing context" end

    obj.basename = obj.basename or "ctxframe"
    obj.frameRate = obj.frameRate or 30;
    obj.isRecording = false;
    obj.currentFrame = obj.currentFrame or 0;

    setmetatable(obj, ContextRecorder_mt)

    return obj;
end

function ContextRecorder.saveFrame(self)
    if not self.isRecording then return false end

    if self.maxFrames then
        if self.currentFrame >= self.maxFrames then
            return false, 'reached max frames'
        end
    end

    local frameName = string.format("%s%06d", self.basename, self.currentFrame)
    BLImageCodec("BMP"):writeImageToFile(self.drawingContext:getReadyBuffer(), frameName)    
    
    self.currentFrame = self.currentFrame + 1;
end

function ContextRecorder.record(self)
    -- need to cancel existing timer
    if self.isRecording then return false, "already recording" end
    self.isRecording = true;

    self.timer = periodic(1000/self.frameRate, functor(self.saveFrame, self))
end

function ContextRecorder.pause(self)
    if self.timer then
        self.timer:cancel()
    end

    self.isRecording = false;
end

function ContextRecorder.stop(self)
    if self.timer then
        self.timer:cancel()
    end

    self.currentFrame = 0;
    self.isRecording = false;
end


return ContextRecorder