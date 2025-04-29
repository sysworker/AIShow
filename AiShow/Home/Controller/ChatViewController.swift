import UIKit

class ChatViewController: BaseVC {
    var aiModel : AITool = AITool(icon: "", name: "AI", description: "", tag: 1)
    
    private let tableView = UITableView()
    private let inputContainerView = UIView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    private var messages: [ChatMessage] = []
    private let disposeBag = DisposeBag()
    
    private let lastData = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        bindActions()
        setupMockData()
    }
    
    
    override func initUI() {
        super.initUI()
        // 导航栏设置
        view.backgroundColor = .hex(hexString: "#F3F4F5")
        navTitleLabel.text = "\(aiModel.name) 对话"
        // 表格视图
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        // 输入区域
        inputContainerView.backgroundColor = .white
        inputContainerView.layer.borderWidth = 0.5
        inputContainerView.layer.borderColor = UIColor.hex(hexString: "#E5E5E5").cgColor
        
        messageTextField.borderStyle = .roundedRect
        messageTextField.placeholder = "输入消息"
        
        sendButton.setTitle("发送", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func setupConstraints() {
        // 使用SnapKit布局
        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(messageTextField)
        inputContainerView.addSubview(sendButton)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputContainerView.snp.top)
        }
        
        inputContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        messageTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading).offset(-12)
            make.height.equalTo(36)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
    }
    
    private func bindActions() {
        // 发送按钮点击
        sendButton.rx.tap
            .withLatestFrom(messageTextField.rx.text.orEmpty)/**- withLatestFrom ：在点击事件发生时获取输入框的最新内容
                                                              - orEmpty ：将可选字符串转换为普通字符串（空字符串替代nil）*/
            .filter { !$0.isEmpty }/**过滤空字符串，避免发送空白消息*/
            .subscribe(onNext: { [weak self] text in
                let newMessage = ChatMessage(
                    content: text,
                    isOutgoing: true,
                    timestamp: Date()
                )
                self?.messages.append(newMessage)
                self?.messages.append(ChatMessage(content: "服务器繁忙请重试...", isOutgoing: false, timestamp: Date()))
                self?.tableView.reloadData()
                self?.messageTextField.text = nil
                self?.scrollToBottom()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupMockData() {
        // 添加测试数据
        messages = [
            ChatMessage(content: "你好，我是你的AI助手\(self.aiModel.name)", isOutgoing: false, timestamp: Date()),
            ChatMessage(content: "Hi!", isOutgoing: true, timestamp: Date()),
            ChatMessage(content: "Hi,我有什么可以帮助你的吗？", isOutgoing: false, timestamp: Date()),
        ]
    }
    
    private func scrollToBottom() {
        let lastIndex = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatMessageCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}
