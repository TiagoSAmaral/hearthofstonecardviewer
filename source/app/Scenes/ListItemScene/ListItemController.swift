//
//  ListController.swift
//  BaseProjectTarget
//
//  Created by Tiago Amaral on 17/06/23.
//  Copyright © 2023 developerios. All rights reserved.
//

import UIKit

protocol ListDisplayLogic: AnyObject where Self: UIViewController {
    func display(viewModel: [Model]?)
    func display(message: String?)
}

final class ListItemController: UIViewController,
                                ListDisplayLogic,
                                TableViewAutomaticPaginateDelegate,
                                LoadingManagers,
                                AlertPresetable {
    
    var interactor: ListItemInteractorBusinessLogic?
    var router: ListItemRoutingLogic?
    var listView: TableViewUpdateEvent?
    var items: [Model]?
    
    func display(viewModel: [Model]?) {
        stopLoading(onFinish: nil)
        items = viewModel
        listView?.reloadView()
    }
    
    func display(message: String?) {
        stopLoading { [weak self] in
            self?.presentAlert(with: nil, and: message, handler: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFirstPage()
    }
    
    func fetchFirstPage() {
        if items == nil {
            startLoading()
            interactor?.fetchItems()
            (navigationController as? NavigationControllerDecorable)?.defineNavigationBarTitleViewWith(imageName: "navigationBarLogo")
        }
    }
    
    lazy var goToDetail: ((Model?) -> Void)? = { [weak self] item in
        if var item = item as? Selectable {
            item.actionOnTap = nil
            self?.router?.goToDetail(with: item)
        }
    }

    // MARK: TableViewAutomaticPaginateDelegate Methods
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRow(at section: Int) -> Int {
        items?.count ?? .zero
    }
    
    func pullToRefreshEvent() {
        interactor?.flushAndRequest()
    }
    
    func nextPageEvent() {
        interactor?.fetchNextPage()
    }

    func getModel(at indexPath: IndexPath) -> Model? {
        guard var item = items?[indexPath.row] as? Selectable else {
            return nil
        }
        item.actionOnTap = goToDetail
        return item
    }
}
