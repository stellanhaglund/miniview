import UIKit
import WebKit

struct Nav {
    var left: navItem
    
    init(json: [String: Any]){
        left = navItem(json: json["left"] as! [String: Any])
    }
}

struct navItem {
    var action: String
    var image: String
    var title: String
    
    init(json: [String: Any]){
        
        action = json["action"] as! String
        image = json["image"] as! String
        title = json["title"] as! String
        
    }
}



class ViewController: UIViewController, UINavigationControllerDelegate, WKUIDelegate, ModalViewControllerDelegate {
    
    var wv: WKWebView!
    var nested = false
    var ctrl: WKUserContentController!
    var cfg: WKWebViewConfiguration!
    var url = K.url
    var activity: UIActivityIndicatorView!
    var background = K.background
    var tint = K.tint
    
    
    func modalViewControllerDidFinish(data: String) {
        self.wv.evaluateJavaScript("window.postMessage({\"image\": \"\(data)\"})")
        print("Sent to js")
    }
    

    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
                
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        
        let v = ModalController()
        v.url = navigationAction.request.url?.absoluteString ?? url
        print(v.url)
        v.delegate = self
        v.parentController = self
        present(v, animated: true)
    
        return nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        //print("hello")
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        view.backgroundColor = background
        /*navigationController?.navigationBar.tintColor = tint
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = background
        navigationController?.navigationBar.backgroundColor = background*/
        
        navigationController?.navigationBar.barStyle = .default
        
        //navigationController?.preferredStatusBarStyle = .darkContent
        
        //navigationController?.hidesBarsOnSwipe = true
        setNeedsStatusBarAppearanceUpdate()
        
        let config = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let image2 = UIImage(systemName: "chevron.left", withConfiguration: config)
        
        let backButton = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            self.wv.evaluateJavaScript("window.history.back()")
        }))
        
        backButton.setImage(image2, for: .normal)
        
        let btn = UIButton(type: .custom, primaryAction: UIAction(handler: {_ in }))
        let newBackButton = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = newBackButton
        
        tabBarController?.navigationItem.leftBarButtonItem = newBackButton
        tabBarController?.navigationItem.title = "Home"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        


        
        if !nested {
            let btn = UIButton(type: .custom, primaryAction: UIAction(handler: {_ in }))
            let newBackButton = UIBarButtonItem(customView: btn)
            self.navigationItem.leftBarButtonItem = newBackButton
        }
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        wv.isHidden = false
        wv.goBack()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.view.addSubview(wv)
    }
    
    func createWebview(){
        
        print("create")
        
        activity = UIActivityIndicatorView()
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.style = .large
        activity.backgroundColor = background
        //activity.isOpaque  = true
        activity.frame = view.frame
        

        cfg = WKWebViewConfiguration()
        ctrl = WKUserContentController()
        ctrl.add(self, name: "myMessage")
        cfg.userContentController = ctrl
        cfg.allowsInlineMediaPlayback = true
        cfg.limitsNavigationsToAppBoundDomains = true
        
        let frame = CGRect(x: 0.0, y: getStatusBarHeight(),
           width: UIScreen.main.bounds.width,
           height: UIScreen.main.bounds.height)
        wv = WKWebView(frame: frame, configuration: cfg)
        wv.isOpaque = false;
        wv.backgroundColor = background
        //wv.scrollView.automaticallyAdjustsScrollIndicatorInsets = true
        //wv.scrollView.sc
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        wv.addSubview(activity)
        wv.uiDelegate = self
        wv.scrollView.delegate = self
        
        
    
        //wv.scrollView.contentInset.top = 200
        //activity.startAnimating()
        view.addSubview(wv)
        wv.load(URLRequest(url:URL(string: url)!))
    }
    
    func getStatusBarHeight() -> CGFloat {
       var statusBarHeight: CGFloat = 0
       if #available(iOS 13.0, *) {
           let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       } else {
           statusBarHeight = UIApplication.shared.statusBarFrame.height
       }
       return statusBarHeight
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        
        if !nested {
            createWebview()
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
     if (error as NSError).code == -999 {
        return
     }
     print(error)
    }
    
    @available(iOS 15, *)
    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }
}





