//
//  ViewController.swift
//  IGListKitComponent
//
//  Created by Nicolas Bonnet on 15.09.22.
//

import UIKit
import IGListKit

class ViewController: UIViewController {
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activate(constraints)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    /// The override allows the view to update when the scene size changes.
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] (_) in
            self?.adapter.performUpdates(animated: true)
        }
    }
    
    /// The override allows the view to update when the prefered content size changes (font size and weight).
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.adapter.reloadData()
    }
}

extension ViewController: ListAdapterDataSource {
    open func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data: [ListDiffable] = []
        data.append(ComponentViewModel(text: ""))
        data.append(ComponentViewModel(text: ""))
        data.append(ComponentViewModel(text: ""))
        data.append(ComponentViewModel(text: ""))
        return data
    }

    open func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is ComponentViewModel: return ComponentSectionController()
        default: return ListSectionController()
        }
    }

    open func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}


