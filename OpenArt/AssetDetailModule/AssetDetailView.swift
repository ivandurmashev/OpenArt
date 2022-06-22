//
//  AssetView.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import Foundation
import UIKit

protocol IAssetDetailView: AnyObject {
    
}

final class AssetDetailView: UIView {
 //MARK: - private enums
    private enum Constant {
        static let cornerRadius: CGFloat = 8
        static let separatorViewAlphaComponent: CGFloat = 0.04
    }
    
    private enum Constraint {
        static let assetImageViewTopOffset: CGFloat = 27
        static let placeBidViewHorizontalInset: CGFloat = 16
        
        static let profileAndDescriptionHorizontalOffset: CGFloat = 24
        
        static let separatorViewHeight: CGFloat = 1
    }
    
//MARK: - properties
    var onLikedButtonTappedHandler: ((AssetModel.SaveAsset.Request) -> Void)?
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let assetImageView = ResizingImageView()
    private let collectionHeaderView = CollectionHeaderView()
    private let descriptionView = AssetDescriptionView()
    private let separatorView = UIView()
    private let likedButton = LikedButton(text: "Save")
    
//MARK: - init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(assetImage: UIImage?) {
        self.assetImageView.setImageAndUpdateAspectRatio(image: assetImage ?? UIImage())
    }
    
    func set(collectionName: String?) {
        self.collectionHeaderView.set(collectionName: collectionName)
    }
    
    func set(collectionImage: UIImage?) {
        self.collectionHeaderView.set(collectionImage: collectionImage)
    }
    
    func set(title: String?) {
        self.descriptionView.set(title: title)
    }
    
    func set(description: String?) {
        self.descriptionView.set(description: description)
    }
}

//MARK: - private method
extension AssetDetailView: IAssetDetailView {
    func setupLayout() {
        self.setupScrollViewLayout()
        self.setupContainerViewLayout()        
        self.setupAssetImageViewLayout()
        self.setupProfileViewLayout()
        self.setupDescriptionViewLayout()
        self.setupSeparatorViewLayout()
        self.setupLikedButtonLayout()
    }
    
    func setupScrollViewLayout() {
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupContainerViewLayout() {
        self.scrollView.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    func setupAssetImageViewLayout() {
        self.containerView.addSubview(self.assetImageView)
        self.configureAssetImageView()
        
        NSLayoutConstraint.activate([
            self.assetImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: Constraint.assetImageViewTopOffset),
            self.assetImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.assetImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset),
        ])
    }
    
    func configureAssetImageView() {
        self.assetImageView.translatesAutoresizingMaskIntoConstraints = false
        self.assetImageView.layer.cornerRadius = Constant.cornerRadius
        self.assetImageView.layer.masksToBounds = true
        self.assetImageView.contentMode = .scaleAspectFit
    }
    
    func setupProfileViewLayout() {
        self.containerView.addSubview(self.collectionHeaderView)
        
        NSLayoutConstraint.activate([
            self.collectionHeaderView.topAnchor.constraint(equalTo: self.assetImageView.bottomAnchor, constant: Constraint.profileAndDescriptionHorizontalOffset),
            self.collectionHeaderView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.collectionHeaderView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset),
        ])
        let topConstraint = self.collectionHeaderView.topAnchor.constraint(equalTo: self.assetImageView.bottomAnchor, constant: Constraint.profileAndDescriptionHorizontalOffset)
        topConstraint.priority = UILayoutPriority(250)
        topConstraint.isActive = true
    }
    
    func setupDescriptionViewLayout() {
        self.containerView.addSubview(self.descriptionView)
        
        NSLayoutConstraint.activate([
            self.descriptionView.topAnchor.constraint(equalTo: self.collectionHeaderView.bottomAnchor, constant: Constraint.profileAndDescriptionHorizontalOffset),
            self.descriptionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constraint.placeBidViewHorizontalInset),
            self.descriptionView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constraint.placeBidViewHorizontalInset)
        ])
    }
    
    func setupSeparatorViewLayout() {
        self.containerView.addSubview(self.separatorView)
        self.configureSeparatorView()
        
        NSLayoutConstraint.activate([
            self.separatorView.topAnchor.constraint(equalTo: self.descriptionView.bottomAnchor, constant: Constraint.profileAndDescriptionHorizontalOffset),
            self.separatorView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: Constraint.separatorViewHeight)
        ])
    }
    
    func configureSeparatorView() {
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.backgroundColor = Color.black.tone.withAlphaComponent(Constant.separatorViewAlphaComponent)
    }
    
    func setupLikedButtonLayout() {
        self.containerView.addSubview(self.likedButton)
        self.configureLikedButton()
        
        NSLayoutConstraint.activate([
            self.likedButton.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor, constant: 32),
            self.likedButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16),
            self.likedButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16),
            self.likedButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -16)
        ])
    }
    
    func configureLikedButton() {
        self.likedButton.addTarget(self, action: #selector(onLikedButtonTapped), for: .touchUpInside)
    }
    
    @objc func onLikedButtonTapped() {
        let assetName = descriptionView.assetName()
        let assetDescription = descriptionView.assetDescription()
        let assetImage = assetImageView.image
        let collectionName = collectionHeaderView.collectionName()
        let collectionImage = collectionHeaderView.collectionImage()
        
        let request = AssetModel.SaveAsset.Request.init(assetName: assetName, assetImage: assetImage, assetDescription: assetDescription, collectionName: collectionName, collectionImage: collectionImage)
        
        self.onLikedButtonTappedHandler?(request)
    }
}
