
import UIKit
import WebKit

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "myMessage" {
                        
            guard let data = message.body as? [String: Any] else { return }
            
            switch data["type"] as! String {
                
            case "data":
                print("incoming data")
                
            case "popstate":
                print("navigated backwards")
                
                navigationController?.popViewController(animated: true)
            case "initial":
                print("initial doing nothing")
                return
                
            default:
                print("navigated forward")
                
                guard let route = data["route"] as? [String: Any] else { return }
                guard let app = route["app"] as? [String: Any] else { return }
                
                switch app["type"] as! String {
                    

                    
                case "modal":
                    print("should show modal")
                    
                    let v = ModalController()
                    v.url = url + (data["to"] as! String)
                    present(v, animated: true)
                    
                case "plain":
                    print("should show plain")
            
                    let v = ViewController()
                    v.nested = true
                    v.view.addSubview(wv)
                    v.wv = wv
                    navigationController?.pushViewController(v, animated: true)
                case "tabs":
                    print("should show tabs")
                     
                    let v = TabController()
                    v.tabs = app["tabs"] as! [[String : String]]
                    wv.isHidden = true
                    v.url = url
                    navigationController?.pushViewController(v, animated: true)
                    
                default:
                    print("missing route type")
                    
                }
                
            }
            
        }
    }
    
}

extension ModalController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "myMessage" {
            
            print("incoming message modal", message.body)
                        
            guard let data = message.body as? [String: String] else { return }
        
            switch data["type"] as String? {
                
            case "data":
                print("incoming data")
                delegate?.modalViewControllerDidFinish(data:data["data"] as String? ?? "")
                parentController?.dismiss(animated: true)
            default:
                print("default")
                
            }
            
        }
    }
    
}

