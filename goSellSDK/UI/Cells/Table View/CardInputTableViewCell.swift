//
//  CardInputTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import struct CoreGraphics.CGGeometry.CGPoint
import class EditableTextInsetsTextField.EditableTextInsetsTextField
import struct TapAdditionsKit.TypeAlias
import class TapEditableView.TapEditableView
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIButton.UIButton
import class UIKit.UICollectionView.UICollectionView
import class UIKit.UIEvent.UIEvent
import struct UIKit.UIGeometry.UIEdgeInsets
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIScreen.UIScreen
import class UIKit.UISwitch.UISwitch
import class UIKit.UITableView.UITableView
import var UIKit.UITableView.UITableViewAutomaticDimension
import class UIKit.UITableViewCell.UITableViewCell
import class UIKit.UIView.UIView

internal class CardInputTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CardInputTableViewCellModel?
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isSelected {
            
            return super.hitTest(point, with: event)
        }
        
        if self.bounds.contains(point) {
            
            self.enableUserInteractionAndUpdateToolbarInAllControls()
            self.model?.manuallySelectCellAndCallTableViewDelegate()
        }
        
        return super.hitTest(point, with: event)
    }
    
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        
        if !selected {
            
            self.firstResponder?.resignFirstResponder()
            self.controls?.forEach { $0.isUserInteractionEnabled = false }
        }
        
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let cvvFieldInsets = UIEdgeInsets(top: 0.0, left: 26.0, bottom: 0.0, right: 0.0)
        fileprivate static let layoutAnimationDuration: TimeInterval = 0.25
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var iconsTableView: UITableView?
    
    @IBOutlet private weak var cardNumberTextField: EditableTextInsetsTextField?
    @IBOutlet private weak var cardScannerButton: UIButton?
    
    @IBOutlet private var constraintsToDisableWhenCardScanningAvailable: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenCardScanningAvailable: [NSLayoutConstraint]?
    
    @IBOutlet private weak var expirationDateTextField: EditableTextInsetsTextField?
    @IBOutlet private weak var expirationDateEditableView: TapEditableView?
    
    @IBOutlet private weak var cvvTextField: EditableTextInsetsTextField? {
        
        didSet {
            
            self.cvvTextField?.textInsets = Constants.cvvFieldInsets
        }
    }
    
    @IBOutlet private weak var nameOnCardTextField: EditableTextInsetsTextField?
    
    @IBOutlet private weak var saveCardSwitch: UISwitch?
    
    @IBOutlet private var controls: [UIView]?
    
    @IBOutlet private weak var addressOnCardLabel: UILabel?
    @IBOutlet private weak var addressOnCardArrowImageView: UIImageView?
    
    @IBOutlet private var constraintsToDisableWhenAddressOnCardRequired: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenAddressOnCardRequired: [NSLayoutConstraint]?
    
    // MARK: Methods
    
    private func enableUserInteractionAndUpdateToolbarInAllControls() {
        
        self.controls?.forEach { $0.isUserInteractionEnabled = true }
        self.controls?.forEach { $0.updateToolbarButtonsState() }
    }
    
    private func updateCardScannerButtonVisibility(animated: Bool, layout: Bool) -> Bool {
        
        guard
            
            let nonnullModel = self.model,
            let nonnullConstraintsToDeactivateIfScanningEnabled = self.constraintsToDisableWhenCardScanningAvailable,
            let nonnullConstraintsToActivateIfScanningEnabled = self.constraintsToEnableWhenCardScanningAvailable
        
        else { return false }
        
        let scanButtonAlphaAnimation: TypeAlias.ArgumentlessClosure = {
            
            self.cardScannerButton?.alpha = nonnullModel.scanButtonVisible ? 1.0 : 0.0
        }
        
        return NSLayoutConstraint.reactivate(inCaseIf: nonnullModel.scanButtonVisible,
                                             constraintsToDisableOnSuccess: nonnullConstraintsToDeactivateIfScanningEnabled,
                                             constraintsToEnableOnSuccess: nonnullConstraintsToActivateIfScanningEnabled,
                                             viewToLayout: layout ? self : nil,
                                             animationDuration: animated ? Constants.layoutAnimationDuration : 0.0,
                                             additionalAnimations: scanButtonAlphaAnimation)
    }
    
    private func updateAddressOnCardFieldVisibility(animated: Bool, layout: Bool) -> Bool {
        
        guard
        
            let nonnullModel = self.model,
            let nonnullConstraintsToDeactivateIfAddressRequired = self.constraintsToDisableWhenAddressOnCardRequired,
            let nonnullConstraintsToActivateIfAddressRequired = self.constraintsToEnableWhenAddressOnCardRequired
        
        else { return false }
        
        return NSLayoutConstraint.reactivate(inCaseIf: nonnullModel.displaysAddressFields,
                                             constraintsToDisableOnSuccess: nonnullConstraintsToDeactivateIfAddressRequired,
                                             constraintsToEnableOnSuccess: nonnullConstraintsToActivateIfAddressRequired,
                                             viewToLayout: layout ? self : nil,
                                             animationDuration: animated ? Constants.layoutAnimationDuration : 0.0)
    }
}

// MARK: - LoadingWithModelCell
extension CardInputTableViewCell: LoadingWithModelCell {

    internal func updateContent(animated: Bool) {

        self.updateCollectionViewContent(animated)
        
        self.addressOnCardLabel?.font = self.model?.addressOnCardTextFont
        self.addressOnCardLabel?.text = self.model?.addressOnCardText
        self.addressOnCardLabel?.textColor = self.model?.addressOnCardTextColor
        
        let needScannerButtonLayout = self.updateCardScannerButtonVisibility(animated: animated, layout: false)
        let needAddressOnCardLayout = self.updateAddressOnCardFieldVisibility(animated: animated, layout: false)
        if needScannerButtonLayout || needAddressOnCardLayout {
            
            let animations: TypeAlias.ArgumentlessClosure = {
                
                self.layout()
            }
            
            if animated {
                
                UIView.animate(withDuration: Constants.layoutAnimationDuration, animations: animations)
            }
            else {
                
                UIView.performWithoutAnimation {
                    
                    animations()
                }
            }
        }
        
        self.setGlowing(self.model?.isSelected ?? false)
        
        self.addressOnCardArrowImageView?.image = self.model?.addressOnCardArrowImage
        self.cardScannerButton?.setImage(self.model?.scanButtonImage, for: .normal)
    }

    private func updateCollectionViewContent(_ animated: Bool) {

        if animated {

            self.iconsTableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        else {

            self.iconsTableView?.reloadData()
        }
    }
}

// MARK: - BindingWithModelCell
extension CardInputTableViewCell: BindingWithModelCell {
    
    internal func bindContent() {
        
        self.iconsTableView?.dataSource = self.model?.tableViewHandler
        self.iconsTableView?.delegate = self.model?.tableViewHandler
        
        if let cardNumberField = self.cardNumberTextField {
            
            self.model?.bind(cardNumberField, displayLabel: nil, for: .cardNumber)
        }
        
        if let expirationDateField = self.expirationDateTextField {
            
            self.model?.bind(expirationDateField, displayLabel: nil, editableView: self.expirationDateEditableView, for: .expirationDate)
        }
        
        if let cvvField = self.cvvTextField {
            
            self.model?.bind(cvvField, displayLabel: nil, for: .cvv)
        }
        
        if let nameField = self.nameOnCardTextField {
            
            self.model?.bind(nameField, displayLabel: nil, for: .nameOnCard)
        }
        
        if let addressLabel = self.addressOnCardLabel {
            
            self.model?.bind(nil, displayLabel: addressLabel, for: .addressOnCard)
        }
    }
}

// MARK: - GlowingCell
extension CardInputTableViewCell: GlowingCell {
    
    internal var glowingView: UIView { return self }
}
