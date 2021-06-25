//
//  HomeCell.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

class HomeCell: UITableViewCell{
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let typeImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubviews(views: [nameLabel, typeImage])
        selectionStyle = .none
        setupConstraints()
    }
    
    func setupConstraints(){
        typeImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.height.width.equalTo(60).priority(.required)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(typeImage)
        }
    }
    
    func configure(item: ActivityViewItem){
        self.nameLabel.text = item.name
        self.typeImage.image = item.type.image
    }
}
