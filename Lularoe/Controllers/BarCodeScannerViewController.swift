//
//  BarCodeScannerViewController.swift
//  Lularoe
//
//  Created by Collin Lochinski on 11/15/16.
//  Copyright © 2016 Collin Lochinski. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var viewItem: UIButton!
    @IBOutlet weak var addToInventory: UIButton!
    let session = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var identifiedBorder : BarCodeView?
    var timer : Timer?
    var codeStringValue : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let inputDevice = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            session.addInput(inputDevice)
            addPreviewLayer()
            
            identifiedBorder = BarCodeView(frame: self.view.bounds)
            identifiedBorder?.backgroundColor = .clear
            identifiedBorder?.isHidden = true;
            self.view.addSubview(identifiedBorder!)
            
            
            /* Check for metadata */
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            session.startRunning()
        }
        catch let error as NSError {
            print(error)
            let alert = UIAlertController(title: "Error", message: "Could not access camera", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        viewItem.isHidden = true
        addToInventory.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        session.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let preview = previewLayer {
            
            preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            preview.bounds = self.view.bounds;
            preview.position = CGPoint(x:self.view.bounds.midX, y:self.view.bounds.midY)
            
            if preview.connection.isVideoOrientationSupported {
                switch (UIDevice.current.orientation) {
                case .portrait:
                    preview.connection.videoOrientation = .portrait
                    break
                case .landscapeRight:
                    preview.connection.videoOrientation = .landscapeLeft
                    break
                case .landscapeLeft:
                    preview.connection.videoOrientation = .landscapeRight
                    break
                case .portraitUpsideDown:
                    preview.connection.videoOrientation = .portraitUpsideDown
                    break
                default:
                    preview.connection.videoOrientation = .portrait
                    break
                }
            }
        }
    }
    
    func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.bounds = self.view.bounds
        previewLayer?.position = CGPoint(x:self.view.bounds.midX, y:self.view.bounds.midY)
        self.view.layer.addSublayer(previewLayer!)
    }
    
    func translatePoints(points : [AnyObject], fromView : UIView, toView: UIView) -> [CGPoint] {
        var translatedPoints : [CGPoint] = []
        for point in points {
            let dict = point as! NSDictionary
            let x = CGFloat((dict.object(forKey: "X") as! NSNumber).floatValue)
            let y = CGFloat((dict.object(forKey: "Y") as! NSNumber).floatValue)
            let curr = CGPoint(x:x, y:y)
            let currFinal = fromView.convert(curr, to: toView)
            translatedPoints.append(currFinal)
        }
        return translatedPoints
    }
    
    @IBAction func addToInventory(_ sender: Any) {
        
        if let codeValue = codeStringValue {
            
            print(codeValue)
            
            let vc = ItemViewController()
            self.present(vc, animated: true, completion: {})
            
        }
    }
    
    @IBAction func viewItem(_ sender: Any) {
        
    }
    
    @IBAction func dismissScan(_ sender: Any) {
        viewItem.isHidden = true
        addToInventory.isHidden = true
        removeBorder()
        session.startRunning()
    }
    
    // MARK:- Border Timer functions
    
    func startTimer() {
        if timer?.isValid != true {
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(removeBorder), userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
        }
    }
    
    func removeBorder() {
        /* Remove the identified border */
        self.identifiedBorder?.isHidden = true
    }
    
    func awaitForAction() {
        
        session.stopRunning()
        
        viewItem.isHidden = false
        addToInventory.isHidden = false
        view.bringSubview(toFront: viewItem)
        view.bringSubview(toFront: addToInventory)
        
    }
    
    // MARK:- AVCapture Delegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        for data in metadataObjects {
            
            let metaData = data as! AVMetadataObject
            let transformed = previewLayer?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
            
            if let unwrapped = transformed {
                
                // Target metadata with border
                identifiedBorder?.frame = unwrapped.bounds
                identifiedBorder?.isHidden = false
                let identifiedCorners = self.translatePoints(points: unwrapped.corners as [AnyObject], fromView: self.view, toView: self.identifiedBorder!)
                identifiedBorder?.drawBorder(points: identifiedCorners)
                self.identifiedBorder?.isHidden = false
                //                self.startTimer()
                
                // Get string value out of metadata
                
                if unwrapped.type == AVMetadataObjectTypeQRCode {
                    
                    print("QR Tag")
                    print(unwrapped.stringValue)
                    codeStringValue = unwrapped.stringValue
                    awaitForAction()
                    
                }
                else if unwrapped.type == AVMetadataObjectTypeEAN8Code {
                    
                    print("Lularoe Tag")
                    print(unwrapped.stringValue)
                    
                    codeStringValue = unwrapped.stringValue
                    awaitForAction()
                }
            }
        }
    }
}
