//
//  ComponentSectionController.swift
//  IGListKitComponent
//
//  Created by Nicolas Bonnet on 15.09.22.
//

import IGListKit

class ComponentSectionController: ListSectionController {
    private var model: ComponentViewModel?

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        return CGSize(width: collectionContext.containerSize.width, height: 150)
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
        precondition(object is ComponentViewModel)
        model = (object as! ComponentViewModel)
    }
}
