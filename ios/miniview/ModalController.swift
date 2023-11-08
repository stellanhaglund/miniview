import UIKit
import WebKit
import AVFoundation


protocol ModalViewControllerDelegate: AnyObject {
    func modalViewControllerDidFinish(data: String)
}

func fixOrientation(img: UIImage) -> UIImage {
    if (img.imageOrientation == UIImage.Orientation.up) {
        return img
    }
    UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
    img.draw(in: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
    let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return normalizedImage
}

extension ModalController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        print("photo output")
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Unable to retrieve image data")
            return
        }
        
        // Correct image orientation
        let correctOrientationImage = fixOrientation(img: image)
        
        guard let pngData = correctOrientationImage.pngData() else {
            print("Unable to convert UIImage to PNG data")
            return
        }

        let base64String = pngData.base64EncodedString()
        let dataURI = "data:image/png;base64,\(base64String)"
        
        delegate?.modalViewControllerDidFinish(data:dataURI)
        
        parentController?.dismiss(animated: true)
        
        // Process the captured image as needed
        // For example, you can display it in an image view:
        //imageView.image = image
        
        // Save the image to the photo library if desired
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
    
class ModalController: UIViewController, UINavigationControllerDelegate, WKUIDelegate, WKNavigationDelegate {
    
    var wv: WKWebView!
    var nested = false
    var ctrl: WKUserContentController!
    var cfg: WKWebViewConfiguration!
    var url = K.url
    weak var delegate: ModalViewControllerDelegate?
    private var containerView: UIView!
    var parentController: UIViewController!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        
        guard let captureSession = captureSession else {
            print("Failed to create AVCaptureSession")
            return
        }
        
        captureDevice = AVCaptureDevice.default(for: .video)
        
        guard let captureDevice = captureDevice else {
            print("Failed to get AVCaptureDevice")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            // Adding photo output here
            let photoOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            } else {
                print("Could not add photo output to the session")
                return
            }
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    
    func createWebview(){
        
        /*
        cfg = WKWebViewConfiguration()
        ctrl = WKUserContentController()
        ctrl.add(self, name: "myMessage")
        cfg.userContentController = ctrl
        
        cfg.allowsInlineMediaPlayback = true
        cfg.limitsNavigationsToAppBoundDomains = true
        
        let executionTime = measureExecutionTime {
            
            let frame = CGRect(x: 0.0, y: 0.0,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
            wv = WKWebView(frame: frame, configuration: cfg)
            wv.uiDelegate = self
            wv.isOpaque = false;
            wv.backgroundColor = UIColor(red: 24/255, green: 24/255, blue: 27/255, alpha: 1)
            wv.scrollView.contentInsetAdjustmentBehavior = .never
            wv.navigationDelegate = self
            view = wv
            
            wv.load(URLRequest(url:URL(string: url)!))
            
        }
        
        print("Execution time: \(executionTime) seconds")*/
        
        setupCamera()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        /*print("created ModalController \n")
        navigationController?.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor(red: 24/255, green: 24/255, blue: 27/255, alpha: 1)
        
        if !nested {
            createWebview()
         
        }*/
        
        view.backgroundColor = UIColor.black
        
        setupCamera()
        
        let buttonDiameter: CGFloat = 70
        let innerCircleDiameter: CGFloat = buttonDiameter - 10
        let innerCircleMargin: CGFloat = (buttonDiameter - innerCircleDiameter) / 2

        // Button
        let button = UIButton(type: .system)
        button.frame = CGRect(x: (view.bounds.width - buttonDiameter) / 2, y: view.bounds.height - buttonDiameter - 100, width: buttonDiameter, height: buttonDiameter)
        button.layer.cornerRadius = buttonDiameter / 2
        button.backgroundColor = .white
        
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)

        // Change the button color on highlight
        button.addTarget(self, action: #selector(buttonHighlight), for: .touchDown)
        button.addTarget(self, action: #selector(buttonNormal), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonNormal), for: .touchUpOutside)

        let innerCircle = UIView(frame: CGRect(x: innerCircleMargin, y: innerCircleMargin, width: innerCircleDiameter, height: innerCircleDiameter))
        innerCircle.backgroundColor = .clear
        innerCircle.layer.borderWidth = 5
        innerCircle.layer.borderColor = UIColor.gray.cgColor // Change border color here
        innerCircle.layer.cornerRadius = innerCircleDiameter / 2
        innerCircle.isUserInteractionEnabled = false

        button.addSubview(innerCircle)

        view.addSubview(button)
    }
    @objc func buttonHighlight(sender: UIButton) {
        sender.backgroundColor = .gray
    }

    @objc func buttonNormal(sender: UIButton) {
        sender.backgroundColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //ctrl.removeScriptMessageHandler(forName: "myMessage")
    }
    @objc func captureButtonTapped() {
        capturePhoto()
    }
    
    func capturePhoto() {
        guard let captureSession = captureSession,
              captureSession.isRunning,
              let videoConnection = captureSession.connections.first(where: { $0.inputPorts.contains(where: { $0.mediaType == .video }) }),
              videoConnection.isActive,
              videoConnection.isEnabled,
              let captureOutput = captureSession.outputs.first(where: { $0 is AVCapturePhotoOutput }) as? AVCapturePhotoOutput else {
            return
        }
        
        print("capture")
        
        let settings = AVCapturePhotoSettings()
        
        captureOutput.capturePhoto(with: settings, delegate: self)
    }
    
    
    @available(iOS 15, *)
    public func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Start measuring load time
        DispatchQueue.main.async {
            self.startLoadTimeMeasurement()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Stop measuring load time
        DispatchQueue.main.async {
            self.stopLoadTimeMeasurement()
        }
    }

    // MARK: - Load Time Measurement Methods

    var loadStartTime: Date!

    func startLoadTimeMeasurement() {
        loadStartTime = Date()
    }

    func stopLoadTimeMeasurement() {
        guard let startTime = loadStartTime else {
            return
        }

        let loadTime = Date().timeIntervalSince(startTime)
        print("Web view load time: \(loadTime) seconds")
    }
    

    
}
