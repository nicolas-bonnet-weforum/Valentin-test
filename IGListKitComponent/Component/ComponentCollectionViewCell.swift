//
//  ComponentCollectionViewCell.swift
//  IGListKitComponent
//
//  Created by Nicolas Bonnet on 15.09.22.
//

import UIKit

/// A cell that...
class ComponentCollectionViewCell: UICollectionViewCell {
    
    fileprivate static let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    fileprivate static let font = UIFont.systemFont(ofSize: 14)
    static let imageSize: CGFloat = 32
    fileprivate static let imageOverlap: CGFloat = 12
    fileprivate static let hSpaceToContacts: CGFloat = 24
    

    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var viewContacts: UIView!
    @IBOutlet weak var constraintWViewContacts: NSLayoutConstraint!
    @IBOutlet weak var constraintHSpaceToContacts: NSLayoutConstraint!
    @IBOutlet weak var constraintContactsViewBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintLabelBottom: NSLayoutConstraint!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //remove recycled subviews
        for v in viewContacts.subviews {
            v.removeFromSuperview()
        }

    }
    
    func configureWith(_ model: ComponentViewModelDataType) {
        labelText.translatesAutoresizingMaskIntoConstraints = false

        if let text = model.text {
            labelText.text = text
        }
        else
        if let attributedText = model.attributedText {
            labelText.attributedText = attributedText
        }
        let imgCount = CGFloat(model.imagesArray.count)
        if imgCount == 0 {
            constraintHSpaceToContacts.constant = 0
            constraintWViewContacts.constant = 0
        }
        else {
            constraintHSpaceToContacts.constant = ComponentCollectionViewCell.hSpaceToContacts
            constraintWViewContacts.constant = ComponentCollectionViewCell.imageSize * imgCount - ComponentCollectionViewCell.imageOverlap * (imgCount - 1)
            print("constraintWViewContacts.constant = ", constraintWViewContacts.constant)
            for (index, img) in model.imagesArray.enumerated() {
                let imgView = UIImageView(image: img)
                imgView.frame = CGRect(x: 0, y: 0, width: ComponentCollectionViewCell.imageSize, height: ComponentCollectionViewCell.imageSize)
                imgView.translatesAutoresizingMaskIntoConstraints = false
                imgView.contentMode = .scaleAspectFill
                imgView.layer.borderWidth = 1
                imgView.layer.masksToBounds = false
                imgView.layer.borderColor = UIColor.red.cgColor
//                imgView.layer.cornerRadius = imgView.frame.height/2
                imgView.clipsToBounds = true
                viewContacts.addSubview(imgView)

                let constant = CGFloat(index) * (ComponentCollectionViewCell.imageSize - ComponentCollectionViewCell.imageOverlap)
                print("constant:", constant)
                imgView.widthAnchor.constraint(equalToConstant: ComponentCollectionViewCell.imageSize).isActive = true
                imgView.heightAnchor.constraint(equalToConstant: ComponentCollectionViewCell.imageSize).isActive = true
                NSLayoutConstraint(item: imgView, attribute: .leadingMargin, relatedBy: .equal, toItem: imgView.superview, attribute: .leadingMargin, multiplier: 1, constant: constant).isActive = true
                NSLayoutConstraint(item: imgView, attribute: .topMargin, relatedBy: .equal, toItem: imgView.superview, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true

            }
        }
        viewContacts.backgroundColor = .green
        print("bounds:", self.bounds)
    }
    
    static func textHeight(_ attributedText: NSAttributedString, containerWidth: CGFloat) -> CGFloat {
        print("containerWidth:", containerWidth)
        let rect = attributedText.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                               options: [.usesLineFragmentOrigin, .usesFontLeading],
                                               context: nil)
        print("calculatedHeight =", ceil(rect.size.height), "calculatedWidth =", ceil(rect.size.width))

        return ceil(rect.size.height)
    }

    static func availableWidth(_ width: CGFloat, _ data: ComponentViewModelDataType) -> CGFloat {
        var availableWidth = width - insets.left - insets.right
        if data.imagesArray.count > 0 {
            availableWidth -= hSpaceToContacts
            // for each image substract image size
            for (index, _) in data.imagesArray.enumerated() {
                availableWidth -= imageSize
                // starting with the second one, substract overlap
                if index > 0 {
                    availableWidth += imageOverlap
                }
            }
        }
        return availableWidth
    }
    
    static func cellHeight(with data: ComponentViewModelDataType, width: CGFloat) -> CGFloat {
        var cellHeight: CGFloat = insets.top + insets.bottom
        var nsAttributedString = NSAttributedString(string: "")
        if let attrText = data.attributedText {
            nsAttributedString = attrText
        }
        else if let simpleText = data.text {
            let myAttribute = [ NSAttributedString.Key.font: font ]
            nsAttributedString = NSAttributedString(string: simpleText, attributes: myAttribute)
        }

        let availableW = availableWidth(width, data)
        cellHeight += textHeight(nsAttributedString, containerWidth: availableW)
        if data.imagesArray.count > 0 && cellHeight < imageSize {
            cellHeight = imageSize + insets.top + insets.bottom
        }
        return cellHeight
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
}
