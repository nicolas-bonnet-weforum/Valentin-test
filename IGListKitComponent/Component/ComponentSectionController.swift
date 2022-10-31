//
//  ComponentSectionController.swift
//  IGListKitComponent
//
//  Created by Nicolas Bonnet on 15.09.22.
//

import IGListKit

class ComponentSectionController: ListSectionController {
    private var model: ComponentViewModelDataType?
    
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        minimumLineSpacing = 100
        minimumInteritemSpacing = 4

    }
    
    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        return CGSize(width: collectionContext.containerSize.width, height: 55)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext!.dequeueReusableCell(withNibName: "ComponentCollectionViewCell", bundle: Bundle(for: self.classForCoder), for: self, at: index) as? ComponentCollectionViewCell else { fatalError() }
        if let model = model {
            cell.configureWith(model)
        }
        return cell
    }

    override func didSelectItem(at index: Int) {
        collectionContext?.deselectItem(at: index, sectionController: self, animated: false)
    }

    override func didHighlightItem(at index: Int) {
        let cell = collectionContext?.cellForItem(at: index, sectionController: self)
        cell?.isHighlighted = false
    }

    override func didUpdate(to object: Any) {
        precondition(object as? ComponentViewModelDataType != nil )
        model = (object as! ComponentViewModelDataType)
    }
}
