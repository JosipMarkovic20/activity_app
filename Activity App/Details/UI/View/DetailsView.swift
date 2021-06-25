//
//  DetailsView.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

class DetailsView: UIView{
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let typeView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let participantsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let accessibility: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubviews(views: [nameLabel,
                            typeView,
                            participantsLabel,
                            priceLabel,
                            accessibility])
        setupConstraints()
    }
    
    func setupConstraints(){
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        typeView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.width.height.equalTo(60)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(typeView)
        }
        
        participantsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
        }
        
        accessibility.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(participantsLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with item: ActivityViewItem){
        self.nameLabel.text = item.name
        self.typeView.image = item.type.image
        self.priceLabel.text = "\(R.string.localizable.price()): " + String(item.priceSign) + " (\(item.price)$)"
        self.participantsLabel.text = "\(R.string.localizable.participants()): " + String(item.participants)
        self.accessibility.text = "\(R.string.localizable.accessibility()): " + String(item.accessibility)
    }
}
