//
//  CryptoTableViewCell.swift
//  CryptoCoin Tracker
//
//  Created by Calvin Sung on 2021/8/4.
//

import UIKit

class CryptoViewModel {
    let name: String
    let symbol: String
    let price: String
    let iconUrl: URL?
    var iconImageData: Data?
    
    init(name: String, symbol: String, price: String, iconUrl: URL?) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
}


class CryptoTableViewCell: UITableViewCell {
    static let identifier = "CryptoTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(assetLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        return nameLabel
    }()
    
    private let assetLabel: UILabel = {
        let assetLabel = UILabel()
        assetLabel.font = .systemFont(ofSize: 17, weight: .regular)
        return assetLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        priceLabel.textAlignment = .right
        return priceLabel
    }()
    
    private let iconImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height/1.1
        
        nameLabel.sizeToFit()
        assetLabel.sizeToFit()
        priceLabel.sizeToFit()
        
        iconImageView.frame = CGRect(x: 20, y: (contentView.frame.size.height-size)/2, width: size, height: size)
        nameLabel.frame = CGRect(x: 30 + size, y: 0, width: contentView.frame.size.width/2, height: contentView.frame.size.height/2)
        assetLabel.frame = CGRect(x: 30 + size, y: contentView.frame.size.height/2, width: contentView.frame.size.width/2, height: contentView.frame.size.height/2)
        priceLabel.frame = CGRect(x: contentView.frame.size.width/2, y: 0, width: (contentView.frame.size.width/2) - 15, height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        assetLabel.text = nil
    }
    
    func configure(with viewModel: CryptoViewModel) {
        nameLabel.text = viewModel.name
        assetLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        
        if let data = viewModel.iconImageData {
            iconImageView.image = UIImage(data: data)
        } else if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard error == nil && data != nil else {
                    return
                }
                viewModel.iconImageData = data
                DispatchQueue.main.async {
                    self.iconImageView.image = UIImage(data: data!)
                }
            }
            task.resume()
        }
    }

}
