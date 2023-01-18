import UIKit
import WebKit

class ModalController: UIViewController, UINavigationControllerDelegate, WKUIDelegate {
    
    var wv: WKWebView!
    var nested = false
    var ctrl: WKUserContentController!
    var cfg: WKWebViewConfiguration!
    var url = K.url
    
    func createWebview(){
        cfg = WKWebViewConfiguration()
        
        cfg.allowsInlineMediaPlayback = true
        cfg.limitsNavigationsToAppBoundDomains = true
        
        let frame = CGRect(x: 0.0, y: 0.0,
           width: UIScreen.main.bounds.width,
           height: UIScreen.main.bounds.height)
        wv = WKWebView(frame: frame, configuration: cfg)
        wv.uiDelegate = self
        wv.isOpaque = false;
        wv.backgroundColor = UIColor(red: 24/255, green: 24/255, blue: 27/255, alpha: 1)
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        view = wv
        wv.load(URLRequest(url:URL(string: url)!))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor(red: 24/255, green: 24/255, blue: 27/255, alpha: 1)
        
        if !nested {
            createWebview()
        }
    }
    
    
    /*@available(iOS 15, *)
    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }*/
    
    /*func webView(_ webView: WKWebView,
        requestMediaCapturePermissionFor
        origin: WKSecurityOrigin,initiatedByFrame
        frame: WKFrameInfo,type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void){
            decisionHandler(.grant)
     }
     */
    
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
    

    
}
