//
//  PaymentOptionsViewController+UITableView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIScrollView.UIScrollView
import protocol UIKit.UIScrollView.UIScrollViewDelegate
import class UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class UIKit.UITableViewCell.UITableViewCell

// MARK: - UIScrollViewDelegate
extension PaymentOptionsViewController: UIScrollViewDelegate {
    
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.view.firstResponder?.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension PaymentOptionsViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PaymentDataManager.shared.paymentOptionCellViewModels.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = PaymentDataManager.shared.paymentOptionViewModel(at: indexPath)
        
        if let currencyCellModel = model as? CurrencySelectionTableViewCellViewModel {
            
            let cell = currencyCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let emptyCellModel = model as? EmptyTableViewCellModel {
            
            let cell = emptyCellModel.dequeueCell(from: tableView)
            return cell
        }
        if let groupCellModel = model as? GroupTableViewCellModel {
            
            let cell = groupCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let webCellModel = model as? WebPaymentOptionTableViewCellModel {
            
            let cell = webCellModel.dequeueCell(from: tableView)
            return cell
        }
        else if let cardCellModel = model as? CardInputTableViewCellModel {
            
            let cell = cardCellModel.dequeueCell(from: tableView)
            cell.bindContent()
            return cell
        }
        else {
            
            fatalError("Unknown cell model: \(model)")
        }
    }
}

// MARK: - UITableViewDelegate
extension PaymentOptionsViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let model = PaymentDataManager.shared.paymentOptionViewModel(at: indexPath)
        
        if let currencyModel = model as? CurrencySelectionTableViewCellViewModel {
            
            currencyModel.updateCell()
        }
        else if let groupModel = model as? GroupTableViewCellModel {
            
            groupModel.updateCell()
        }
        else if let webCellModel = model as? WebPaymentOptionTableViewCellModel {
            
            webCellModel.updateCell()
        }
        else if let cardCellModel = model as? CardInputTableViewCellModel {
            
            cardCellModel.updateCell()
        }
    }
    
    internal func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let model = PaymentDataManager.shared.paymentOptionViewModel(at: indexPath)
        return model.indexPathOfCellToSelect
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = PaymentDataManager.shared.paymentOptionViewModel(at: indexPath)
        model.tableViewDidSelectCell(tableView)
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let model = PaymentDataManager.shared.paymentOptionViewModel(at: indexPath)
        model.tableViewDidDeselectCell(tableView)
    }
}