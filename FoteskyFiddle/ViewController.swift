//
//  ViewController.swift
//  FoteskyFiddle
//
//  Created by Pavel Peroutka on 03/11/2017.
//  Copyright © 2017 Pavel Peroutka. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var preView: UIView!
    var shotPicture: UIImage?
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    @IBAction func shoot(_ sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto

        // Call capturePhoto method by passing our photo settings and a
        // delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            if let input = try? AVCaptureDeviceInput(device: captureDevice) {
                captureSession = AVCaptureSession()
                captureSession.addInput(input)
                
                capturePhotoOutput = AVCapturePhotoOutput()
                capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                captureSession.addOutput(capturePhotoOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = .resizeAspectFill
                // TODO: co to je? view.layer?
                previewLayer?.frame = view.layer.bounds
                preView.layer.addSublayer(previewLayer!)
                
                captureSession?.startRunning()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showPic":
                let destination = segue.destination as! ImageViewController
                destination.image = self.shotPicture
            default:
                break
            }
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                            didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                            previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings,
                            bracketSettings: AVCaptureBracketedStillImageSettings?,
                            error: Error?) {
        // get captured image
        
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        // Initialise a UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
//            // Save our captured image to photos album
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            self.shotPicture = image
            performSegue(withIdentifier: "showPic", sender: nil)
        }
    }
}
