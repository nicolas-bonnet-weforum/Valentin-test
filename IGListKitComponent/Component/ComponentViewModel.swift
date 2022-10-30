//
//  ComponentViewModel.swift
//  IGListKitComponent
//
//  Created by Nicolas Bonnet on 15.09.22.
//

import IGListKit

/// Model...
public class ComponentViewModel: NSObject, ComponentViewModelDataType {
    
    public var text: String?
    public var attributedText: NSAttributedString?
    public var imagesArray: [UIImage]
    public var lineSpacing: CGFloat = 20 {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            if let attributedText = attributedText {
                var attrStr = NSMutableAttributedString(attributedString: attributedText)
                attrStr.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
                self.attributedText = attrStr
            }
        }
    }
    
    /// String that allow IGListKit to recognize the view model from one refresh to an other. This is important to set when you want to have the component animating when data are being changed.
    let identifier: String?
    
    /// init that allow you to define all the variable associated to ``ComponentViewModel``
    /// - Parameters:
    ///   - text: ...
    ///   - identifier: String that allow IGListKit to recognize the view model from one refresh to an other. This is important to set when you want to have the component animating when data are being changed.
    public init(text: String? = nil, attributedText: NSAttributedString? = nil, imagesArray: [UIImage] = [UIImage](), identifier: String? = nil) {
        self.text = text
        self.attributedText = attributedText
        self.imagesArray = imagesArray

        self.identifier = identifier
        super.init()
    }
}

extension ComponentViewModel: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        guard let identifier = identifier else { return self }
        return identifier as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ComponentViewModel else { return false }
        guard self !== object else { return true }
        return text == object.text && attributedText == object.attributedText
    }
}

