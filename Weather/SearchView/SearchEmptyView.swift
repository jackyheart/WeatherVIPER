//
//  SearchEmptyView.swift
//  Weather
//
//  Created by Jacky Tjoa on 26/9/24.
//

import UIKit

class SearchEmptyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageLabel)
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        messageLabel.text = "No search results available"
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
    }
}
