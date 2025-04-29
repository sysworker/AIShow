import UIKit

class AIChatViewController: BaseVC {
    
    private let tableView = UITableView()
    private let inputToolView = UIView()
    private let addButton = UIButton()
    private let inputTextView = UITextView()
    private let sendButton = UIButton()
    private let disposeBag = DisposeBag()
    
    // 数据源
    private var messages: [Message] = []
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func initUI() {
        super.initUI()
        
        // 导航栏
        navTitleLabel.text = "AI Chat"
        
        // 输入工具栏
        view.addSubview(inputToolView)
        inputToolView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        // 添加按钮
        addButton.setImage(UIImage(named: "add_icon"), for: .normal)
        inputToolView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        
        // 发送按钮
        sendButton.setTitle("发送", for: .normal)
        sendButton.backgroundColor = .systemBlue
        sendButton.layer.cornerRadius = 6
        inputToolView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 36))
        }
        
        // 输入框
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 6
        inputToolView.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.leading.equalTo(addButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(36)
        }
        
        // 表格视图
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputToolView.snp.top)
        }
        
        // 配置表格视图
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
        
    }
    
    private func setupBindings() {
        // 发送按钮状态绑定
        inputTextView.rx.text
            .map { $0?.isEmpty == false }
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 发送按钮点击
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sendMessage()
            }).disposed(by: disposeBag)
        
        // 添加按钮点击
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showImagePicker()
            }).disposed(by: disposeBag)
    }
    
    private func sendMessage() {
        guard let text = inputTextView.text, !text.isEmpty else { return }
        
        // 创建消息对象并加入数据源
        let newMessage = Message(content: text, type: .text)
        messages.append(newMessage)
        tableView.reloadData()
        
        // 清空输入框
        inputTextView.text = nil
        
        // 新增滚动到底部
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func showImagePicker() {
        let imagePicker = TZImagePickerController(maxImagesCount: 1, delegate: self)
        imagePicker?.allowCrop = false
        imagePicker?.didFinishPickingPhotosHandle = { [weak self] (photos, _, _) in
            if let image = photos?.first {
                self?.sendImage(image: image)
            }
        }
        present(imagePicker!, animated: true)
    }
    
    private func sendImage(image: UIImage) {
        // 创建图片消息并加入数据源
        var newMessage = Message(content: "", type: .image)
        newMessage.image = image
        messages.append(newMessage)
        tableView.reloadData()
        
        // 新增滚动到底部
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension AIChatViewController: TZImagePickerControllerDelegate {
    // 图片选择回调处理
}

// 消息模型
struct Message {
    enum MessageType {
        case text
        case image
    }
    
    var content: String
    var type: MessageType
    var image: UIImage?
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


// 添加数据源扩展
extension AIChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let message = messages[indexPath.row]
        
        if message.type == .text {
            cell.textLabel?.text = "我：\(message.content)"
            cell.imageView?.image = nil
        } else if message.type == .image {
            cell.textLabel?.text = "我:"
            cell.imageView?.image = message.image?.resized(to: CGSize(width: 200, height: 200))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AIChatViewController: UITableViewDelegate {
    // 可选：根据需要实现高度等代理方法
}
