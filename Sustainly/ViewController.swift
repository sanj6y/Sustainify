//
//  ViewController.swift
//  Sustainly
//
//  Created by Sanjay Chandrasekar on 2/3/23.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        let alertController = UIAlertController(title: "Barcode Found", message: code, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func scanTapped(_ sender: UIButton) {
        captureSession.startRunning()
    }
}

//import UIKit
//import SwiftUI
//import AVFoundation  //audio video foundation
//
//class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
//
//    var video = AVCaptureVideoPreviewLayer()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let session = AVCaptureSession() //creating session
//        //Here I am going to define the capture device, the device we use
//        let captureDevice = AVCaptureDevice.default(for: .video)
//
//        do
//        {
//            let input = try AVCaptureDeviceInput(device: captureDevice!)
//            if session.canAddInput(input) {
//                session.addInput(input)
//            }
//        }
//
//        catch
//        {
//            print("ERROR")
//        }
//        let output = AVCaptureMetadataOutput()
//        session.addOutput(output)
//
//        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//
//        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr ]
//
//        video = AVCaptureVideoPreviewLayer(session: session)
//        video.frame = view.layer.bounds
//        view.layer.addSublayer(video)
//
//        //self.view.bringSubView(toFront: square)
//
//        session.startRunning()
//
//    }
//
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
//    {
//        if metadataObjects != nil && metadataObjects.count != 0
//        {
//            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
//            {
//                if object.type == AVMetadataObject.ObjectType.qr
//                {
//                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Retake", style: .default,  handler: nil))
//                    alert.addAction(UIAlertAction(title: "Copy", style: .default,  handler: { (nill) in UIPasteboard.general.string = object.stringValue}))
//
//                    present(alert, animated: true, completion: nil )
//                }
//            }
//        }
//    }
//
//    func didRecieveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//}
