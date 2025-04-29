import UIKit

struct Tool {
    static func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, 
                                    message: message, 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
}

extension UIView {
    func addBorder(color: UIColor = .lightGray) {
        layer.borderWidth = 0.5
        layer.borderColor = color.cgColor
    }
}