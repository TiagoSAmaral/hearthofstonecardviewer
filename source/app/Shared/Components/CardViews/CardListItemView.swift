//
//  CardListItem.swift
//  BaseProjectTarget
//
//  Created by Tiago Amaral on 17/06/23.
//  Copyright © 2023 developerios. All rights reserved.
//

import UIKit
import Kingfisher

protocol CardListItemViewModel where Self: Model {
    var cardTitle: String? { get }
    var cardDescriptionText: String? { get }
    var cardCropImageUrl: String? { get }
}

final class CardListItemView: CardSelectable {
    
    let cornerRadius: CGFloat = 8.0
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds =  true
        return view
    }()

    lazy var imageViewBackground: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds =  true
        return imageView
    }()

    lazy var vStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = FontPallet.mainFont?.withSize(22)
        label.textColor = ColorAssets.titleColor
        return label
    }()

    lazy var descriptionLabelBaseView: UIView = {
       let view = UIView()
        
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = FontPallet.mainFont
        label.textColor = ColorAssets.descriptionColor
        label.numberOfLines = .zero
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        label.layer.cornerRadius = cornerRadius
        label.clipsToBounds = true
        return label
    }()

    override func load(model: Model?) {
        self.model = model
        makeLayoutHorizontalStackView()
        populateViewElements()
        registerAction()
    }

    func populateViewElements() {
        let visibleModel = model as? CardListItemViewModel
        
        titleLabel.text = visibleModel?.cardTitle
        descriptionLabel.text = visibleModel?.cardDescriptionText
        if let imageUrl = visibleModel?.cardCropImageUrl {
            imageViewBackground.kf.setImage(with: URL(string: imageUrl))
        }
    }
    
    func registerAction() {
        let selectableModel = model as? Selectable
        self.action = selectableModel?.actionOnTap
    }
    
    func makeLayoutHorizontalStackView() {
        addSubviews([baseView])
        baseView.addSubviews([imageViewBackground, vStackView])
        
        imageViewBackground.edgeToSuperView()
        vStackView.edgeToSuperView(margin: 8.0)
        
        descriptionLabelBaseView.addSubviews([descriptionLabel])
        
        descriptionLabel.centerX(of: descriptionLabelBaseView)
        descriptionLabel.height(60)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(descriptionLabel)
        
        baseView.height(100.0)
        baseView.edgeToSuperView(margin: 8.0)
        imageViewBackground.edgeToSuperView()
        
        baseView.bringSubviewToFront(vStackView)
    }
}
