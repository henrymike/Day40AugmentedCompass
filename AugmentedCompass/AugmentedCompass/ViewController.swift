//
//  ViewController.swift
//  AugmentedCompass
//
//  Created by Mike Henry on 11/16/15.
//  Copyright © 2015 Mike Henry. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //MARK: - Camera Methods
    
    @IBOutlet weak var cameraView :UIView!
    var captureSession = AVCaptureSession()
    var previewLayer :AVCaptureVideoPreviewLayer?
//    @IBOutlet weak var capturedImage :UIImageView!
//    var stillImageOutput = AVCaptureStillImageOutput()
    
    func startCaptureSession() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error :NSError?
        var input :AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print("Error")
        }
        if error == nil && captureSession.canAddInput(input) {
            captureSession.addInput(input)
            
//            stillImageOutput = AVCaptureStillImageOutput()
//            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
//            if captureSession.canAddOutput(stillImageOutput) {
//                captureSession.addOutput(stillImageOutput)
//            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer!.connection?.videoOrientation = .Portrait
            cameraView.layer.addSublayer(previewLayer!)
            
            captureSession.startRunning()
        }
    }
    
//    @IBAction func didPressTakePhotoButton(sender: UIButton) {
//        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
//            videoConnection.videoOrientation = .Portrait
//            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
//                if sampleBuffer != nil {
//                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
//                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
//                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
//                    
//                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: .Right)
//                    self.capturedImage.image = image
//                }
//            })
//        }
//        
//    }
    
    //MARK: - Compass Methods
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var compassHeadingLabel :UILabel!
    
    func startGettingHeading() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var headingString = ""
        switch newHeading.magneticHeading {
        case 0...22.5:
            headingString = "N"
        case 22.5...67.5:
            headingString = "NE"
        case 67.5...112.5:
            headingString = "E"
        case 112.5...157.5:
            headingString = "SE"
        case 157.5...202.5:
            headingString = "S"
        case 202.5...247.5:
            headingString = "SE"
        case 247.5...292.5:
            headingString = "W"
        case 292.5...337.5:
            headingString = "NW"
        case 337.5...360.0:
            headingString = "N"
        default:
            headingString = "?"
        }
        let wholeDegrees = String(format: "%.0f", newHeading.magneticHeading)
        compassHeadingLabel.text = "\(headingString) \(wholeDegrees)°"
    }
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGettingHeading()
        startCaptureSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = cameraView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

