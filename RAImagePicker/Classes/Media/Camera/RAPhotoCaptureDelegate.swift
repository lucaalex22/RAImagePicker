////
////  RAPhotoCaptureDelegate.swift
////  RAImagePicker
////
////  Created by Rashed Al Lahaseh on 11/29/17.
////
//
//import AVFoundation
//import Photos
//
//final class RAPhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
//    
//    // MARK: - Public Methods
//    
//    /// set this to false if you dont wish to save taken picture to photo library
//    var savesPhotoToLibrary = true
//    
//    /// this contains photo data when taken
//    private(set) var photoData: Data? = nil
//    
//    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
//    
//    /// not nil if error occured during capturing
//    private(set) var processError: Error?
//    
//    // MARK: Private Methods
//    
//    private let willCapturePhotoAnimation: () -> ()
//    private let capturingLivePhoto: (Bool) -> ()
//    private let completed: (RAPhotoCaptureDelegate) -> ()
//    private var livePhotoCompanionMovieURL: URL? = nil
//    
//    init(with requestedPhotoSettings: AVCapturePhotoSettings, willCapturePhotoAnimation: @escaping () -> (), capturingLivePhoto: @escaping (Bool) -> (), completed: @escaping (RAPhotoCaptureDelegate) -> ()) {
//        self.requestedPhotoSettings = requestedPhotoSettings
//        self.willCapturePhotoAnimation = willCapturePhotoAnimation
//        self.capturingLivePhoto = capturingLivePhoto
//        self.completed = completed
//    }
//    
//    private func didFinish() {
//        if let livePhotoCompanionMoviePath = livePhotoCompanionMovieURL?.path {
//            if FileManager.default.fileExists(atPath: livePhotoCompanionMoviePath) {
//                do {
//                    try FileManager.default.removeItem(atPath: livePhotoCompanionMoviePath)
//                }
//                catch {
//                    print("photo capture delegate: Could not remove file at url: \(livePhotoCompanionMoviePath)")
//                }
//            }
//        }
//        
//        completed(self)
//    }
//    
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//        if resolvedSettings.livePhotoMovieDimensions.width > 0 && resolvedSettings.livePhotoMovieDimensions.height > 0 {
//            capturingLivePhoto(true)
//        }
//    }
//    
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//        willCapturePhotoAnimation()
//    }
//    
//    @available(iOS 10.0, *)
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        if let photoSampleBuffer = photoSampleBuffer {
//            photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
//        }
//        else if let error = error {
//            print("photo capture delegate: error capturing photo: \(error)")
//            processError = error
//            return
//        }
//    }
//    
//    @available(iOS 10.0, *)
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {
//        capturingLivePhoto(false)
//    }
//    
//    @available(iOS 10.0, *)
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
//        if let error = error {
//            print("photo capture delegate: error processing live photo companion movie: \(error)")
//            return
//        }
//        
//        livePhotoCompanionMovieURL = outputFileURL
//    }
//    
//    @available(iOS 10.0, *)
//    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
//        
//        if let error = error {
//            print("photo capture delegate: Error capturing photo: \(error)")
//            didFinish()
//            return
//        }
//        
//        guard let photoData = photoData else {
//            print("photo capture delegate: No photo data resource")
//            didFinish()
//            return
//        }
//        
//        guard savesPhotoToLibrary == true else {
//            print("photo capture delegate: photo did finish without saving to photo library")
//            didFinish()
//            return
//        }
//        
//        PHPhotoLibrary.requestAuthorization { [unowned self] status in
//            if status == .authorized {
//                PHPhotoLibrary.shared().performChanges({ [unowned self] in
//                    let creationRequest = PHAssetCreationRequest.forAsset()
//                    creationRequest.addResource(with: .photo, data: photoData, options: nil)
//                    
//                    if let livePhotoCompanionMovieURL = self.livePhotoCompanionMovieURL {
//                        let livePhotoCompanionMovieFileResourceOptions = PHAssetResourceCreationOptions()
//                        livePhotoCompanionMovieFileResourceOptions.shouldMoveFile = true
//                        creationRequest.addResource(with: .pairedVideo, fileURL: livePhotoCompanionMovieURL, options: livePhotoCompanionMovieFileResourceOptions)
//                    }
//                    
//                    }, completionHandler: { [unowned self] success, error in
//                        if let error = error {
//                            print("photo capture delegate: Error occurered while saving photo to photo library: \(error)")
//                        }
//                        self.didFinish()
//                    }
//                )
//            }
//            else {
//                self.didFinish()
//            }
//        }
//    }
//}
