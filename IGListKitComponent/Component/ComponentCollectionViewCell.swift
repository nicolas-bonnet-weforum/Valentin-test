//
//  ComponentCollectionViewCell.swift
//  IGListKitComponent
//
//  Created by Nicolas Bonnet on 15.09.22.
//

import UIKit

/// A cell that...
class ComponentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var viewContacts: UIView!
    @IBOutlet weak var constraintWViewContacts: NSLayoutConstraint!
    @IBOutlet weak var constraintHSpaceToContacts: NSLayoutConstraint!
    @IBOutlet var constraintContactsViewBottom: NSLayoutConstraint!
    @IBOutlet var constraintLabelBottom: NSLayoutConstraint!
    @IBOutlet var constraintCentersLabelContacts: NSLayoutConstraint!
    @IBOutlet var constraintContactsViewTop: NSLayoutConstraint!
    
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
        constraintContactsViewBottom.isActive = false
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
            constraintHSpaceToContacts.constant = model.styling.hSpaceToContacts
            constraintWViewContacts.constant = model.styling.imageSize * imgCount - model.styling.imageOverlap * (imgCount - 1)
            for (index, img) in model.imagesArray.enumerated() {
                let imgView = UIImageView(image: img)
                imgView.frame = CGRect(x: 0, y: 0, width: model.styling.imageSize, height: model.styling.imageSize)
                imgView.translatesAutoresizingMaskIntoConstraints = false
                imgView.contentMode = .scaleAspectFill
                imgView.layer.borderWidth = 1
                imgView.layer.masksToBounds = false
                imgView.layer.borderColor = UIColor.white.cgColor
                imgView.layer.cornerRadius = imgView.frame.height/2
                imgView.clipsToBounds = true
                viewContacts.addSubview(imgView)

                let constant = CGFloat(index) * (model.styling.imageSize - model.styling.imageOverlap)
                imgView.widthAnchor.constraint(equalToConstant: model.styling.imageSize).isActive = true
                imgView.heightAnchor.constraint(equalToConstant: model.styling.imageSize).isActive = true
                NSLayoutConstraint(item: imgView, attribute: .leadingMargin, relatedBy: .equal, toItem: imgView.superview, attribute: .leadingMargin, multiplier: 1, constant: constant).isActive = true
                NSLayoutConstraint(item: imgView, attribute: .topMargin, relatedBy: .equal, toItem: imgView.superview, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true

            }
        }

        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true

        let labelHeight = ComponentCollectionViewCell.textHeight(labelText.attributedText!, containerWidth: labelText.bounds.width)
        let numberOfLines = ceil(labelHeight/(labelText.font.pointSize + model.lineSpacing))
        if numberOfLines < 2 {
            constraintContactsViewBottom.isActive = true
            constraintLabelBottom.isActive = false
            constraintCentersLabelContacts.isActive = false
            constraintContactsViewTop.isActive = true
        }
        else if numberOfLines == 2 {
            constraintContactsViewBottom.isActive = false
            constraintLabelBottom.isActive = true
            constraintCentersLabelContacts.isActive = true
            constraintContactsViewTop.isActive = false
        }
        else {
            constraintContactsViewBottom.isActive = false
            constraintLabelBottom.isActive = true
            constraintCentersLabelContacts.isActive = false
            constraintContactsViewTop.isActive = true
        }

    }
    
    static func textHeight(_ attributedText: NSAttributedString, containerWidth: CGFloat) -> CGFloat {
        let rect = attributedText.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                               options: [.usesLineFragmentOrigin, .usesFontLeading],
                                               context: nil)

        return ceil(rect.size.height)
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
}
