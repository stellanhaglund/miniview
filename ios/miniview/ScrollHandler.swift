
import UIKit

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
    }
    
}
