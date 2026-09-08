import CoreAudio
import CoreMediaIO
import Foundation

func audioDevices() -> [AudioObjectID] {
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    var size: UInt32 = 0
    guard AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size) == noErr else {
        return []
    }
    var devices = [AudioObjectID](repeating: 0, count: Int(size) / MemoryLayout<AudioObjectID>.size)
    guard AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size, &devices) == noErr else {
        return []
    }
    return devices
}

func deviceHasInputStreams(_ device: AudioObjectID) -> Bool {
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyStreams,
        mScope: kAudioDevicePropertyScopeInput,
        mElement: kAudioObjectPropertyElementMain
    )
    var size: UInt32 = 0
    return AudioObjectGetPropertyDataSize(device, &address, 0, nil, &size) == noErr
        && size >= MemoryLayout<AudioStreamID>.size
}

func microphoneIsActive() -> Bool {
    for device in audioDevices() {
        guard deviceHasInputStreams(device) else { continue }
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyDeviceIsRunningSomewhere,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: kAudioObjectPropertyElementMain
        )
        guard AudioObjectHasProperty(device, &address) else { continue }
        var running: UInt32 = 0
        var size = UInt32(MemoryLayout<UInt32>.size)
        if AudioObjectGetPropertyData(device, &address, 0, nil, &size, &running) == noErr && running != 0 {
            return true
        }
    }
    return false
}

func cameraDevices() -> [CMIODeviceID] {
    var address = CMIOObjectPropertyAddress(
        mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyDevices),
        mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
        mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMain)
    )
    var size: UInt32 = 0
    guard CMIOObjectGetPropertyDataSize(CMIOObjectID(kCMIOObjectSystemObject), &address, 0, nil, &size) == noErr else {
        return []
    }
    var devices = [CMIODeviceID](repeating: 0, count: Int(size) / MemoryLayout<CMIODeviceID>.size)
    var used: UInt32 = 0
    guard CMIOObjectGetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &address, 0, nil, size, &used, &devices) == noErr else {
        return []
    }
    return devices
}

func cameraIsActive() -> Bool {
    for device in cameraDevices() {
        var address = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIODevicePropertyDeviceIsRunningSomewhere),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMain)
        )
        guard CMIOObjectHasProperty(device, &address) else { continue }
        var running: UInt32 = 0
        let size = UInt32(MemoryLayout<UInt32>.size)
        var used: UInt32 = 0
        if CMIOObjectGetPropertyData(device, &address, 0, nil, size, &used, &running) == noErr && running != 0 {
            return true
        }
    }
    return false
}

print("mic=\(microphoneIsActive() ? 1 : 0) camera=\(cameraIsActive() ? 1 : 0)")
