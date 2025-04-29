import UIKit
import SnapKit
import SDWebImage
import SVProgressHUD

class AIPhotoDetailViewController: BaseVC {
    
    var bannerModel: AIBannerModel?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.maximumZoomScale = 3.0
        view.minimumZoomScale = 1.0
        view.delegate = self
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap)))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        super.initUI()
        
        view.backgroundColor = .hex(hexString: "0x989898")
        navTitleLabel.text = "图片详情"
        setupUI()
        loadImage()
        setupRightBarButton()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.lessThanOrEqualToSuperview().offset(-40)
        }
    }
    
    private func loadImage() {
        guard let urlString = bannerModel?.icon, let url = URL(string: urlString) else {
            SVProgressHUD.showError(withStatus: "无效图片地址")
            return
        }
        
        SVProgressHUD.show()
        imageView.sd_setImage(with: url) { [weak self] (img, error, _, _) in
            SVProgressHUD.dismiss()
            if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            } else {
                self?.adjustImageLayout()
            }
        }
    }
    
    private func adjustImageLayout() {
        guard let image = imageView.image else { return }
        
        let screenSize = UIScreen.main.bounds.size
        let imageSize = image.size
        let widthRatio = screenSize.width / imageSize.width
        let heightRatio = screenSize.height / imageSize.height
        let minScale = min(widthRatio, heightRatio)
        
        scrollView.zoomScale = minScale
        scrollView.minimumZoomScale = minScale
    }
    
    private func setupRightBarButton() {
        let button = UIButton(type: .system)
        button.setTitle("保存", for: .normal)
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func saveImage() {
        guard let image = imageView.image else {
            SVProgressHUD.showInfo(withStatus: "图片未加载完成")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func handleDoubleTap() {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.zoomScale = self.scrollView.zoomScale == 1.0 ? 2.0 : 1.0
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        } else {
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
    }
}

extension AIPhotoDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}
