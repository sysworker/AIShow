import Foundation
import UIKit

class ChatMessageCell: UITableViewCell {
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setupLayout() {
        contentView.addSubview(bubbleView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        // 使用SnapKit布局
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
        }
        
        bubbleView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-8)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(bubbleView).inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.content
        timeLabel.text = formatDate(message.timestamp)
        timeLabel.isHidden = true
        // 根据消息方向设置样式
        if message.isOutgoing {
            bubbleView.backgroundColor = .hex(hexString: "#95EC69")
            bubbleView.snp.remakeConstraints { make in
                make.top.equalTo(timeLabel.snp.bottom).offset(4)
                make.trailing.equalToSuperview().offset(-12)
                make.bottom.equalToSuperview().offset(-8)
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
            }
        } else {
            bubbleView.backgroundColor = .white
            bubbleView.snp.remakeConstraints { make in
                make.top.equalTo(timeLabel.snp.bottom).offset(4)
                make.leading.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().offset(-8)
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
