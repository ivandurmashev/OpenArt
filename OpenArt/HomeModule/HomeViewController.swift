//
//  HomeViewController.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 02.06.2022.
//

import UIKit

protocol IHomeViewController: AnyObject {
    func displayAssets(viewModel: HomeModel.FetchAssets.ViewModel)
    func displayCollectionImage(viewModel: HomeModel.FetchCollectionImage.ViewModel)
    func displayAssetImage(viewModel: HomeModel.FetchAssetImage.ViewModel)
}

final class HomeViewController: UIViewController {
    private var interactor: IHomeInteractor?
    private var router: (IHomeRouter & IHomeDataPassing)?
    private var customView = HomeView()
    
    init(interactor: IHomeInteractor, router: (IHomeRouter & IHomeDataPassing)) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interactor
        self.router = router
        
        self.configureNavBar()
        
        self.customView.fetchDataHandler = { request in
            interactor.fetchAssets(request: request)
        }
        
        self.customView.didSelectItemAt = { indexPath in
            router.routeToPlaceBidVC(from: indexPath)
        }
        
        self.customView.savedButtonTappedHandler = {
            router.routeToSavedVC()
        }
        
        self.customView.fetchImagesForCellHandler = { request in
            interactor.fetchImagesForCell(request: request)
        }
        
        self.customView.saveButtonTappedHandler = { request in
            interactor.saveAsset(request: request)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customView.fetchDataHandler?(.init(nextPage: nil))
    }
}

extension HomeViewController: IHomeViewController {
    func displayAssets(viewModel: HomeModel.FetchAssets.ViewModel) {
        self.customView.viewModel = viewModel
        self.customView.collectionView.reloadData()
    }
    
    func displayAssetImage(viewModel: HomeModel.FetchAssetImage.ViewModel) {
        if let cell = self.customView.collectionView.cellForItem(at: viewModel.indexPath) as? AssetCollectionViewCell {
            cell.set(assetImage: viewModel.assetImage)
        }
    }
    
    func displayCollectionImage(viewModel: HomeModel.FetchCollectionImage.ViewModel) {
        if let cell = self.customView.collectionView.cellForItem(at: viewModel.indexPath) as? AssetCollectionViewCell {
            cell.set(collectionImage: viewModel.collectionImage)
        }
    }
}

private extension HomeViewController {
    func configureNavBar() {
        let savedBarButton = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled"), style: .done, target: self, action: #selector(onSavedBarButtonTapped))
        savedBarButton.tintColor = Color.black.tone
        self.navigationItem.rightBarButtonItem = savedBarButton
    }
    
    @objc func onSavedBarButtonTapped() {
        self.router?.routeToSavedVC()
    }
}




