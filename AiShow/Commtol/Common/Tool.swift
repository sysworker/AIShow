import UIKit
import Foundation

///颜色
extension UIColor{
    
    static func hex(hexString: String, alpha:CGFloat = 1) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0x") { cString = String(subString) }
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 { return UIColor.black }
        
        var range: NSRange = NSRange(location: 0, length: 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        
        let r = UInt32(rString, radix: 16) ?? 0x0
        let g = UInt32(gString, radix: 16) ?? 0x0
        let b = UInt32(bString, radix: 16) ?? 0x0
        
        
        return UIColor(r: r, g: g, b: b).withAlphaComponent(alpha)
    }
    
    convenience init(r: UInt32, g: UInt32, b: UInt32, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
}


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

private var disposeBagKey = "DisposeBagKey"

extension NSObject {
    ///rx监听释放包
    var disBag: DisposeBag {
        get {
            guard let disBag = objc_getAssociatedObject(self, disposeBagKey.addressKey) as? DisposeBag else {
                let disBag = DisposeBag();
                self.disBag = disBag;
                return disBag;
            }
            return disBag

        }
        set {
            objc_setAssociatedObject(self, disposeBagKey.addressKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
  
}


extension String{    
    var addressKey: UnsafeRawPointer {
        return UnsafeRawPointer(bitPattern: abs(hashValue))!
    }
    
}
