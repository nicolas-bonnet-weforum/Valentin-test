//
//  ViewController.swift
//  IGListKitComponent
//
//  Created by Nicolas Bonnet on 15.09.22.
//

import UIKit
import IGListKit

class ComponentCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

class ViewController: UIViewController {
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    public lazy var collectionView: UICollectionView = {
        let layout = ComponentCollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 1, height: 1)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
//        collectionView.contentInsetAdjustmentBehavior = .always
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        collectionView.frame = view.bounds

        print("VCBounds:", self.view.bounds)

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
        var model: ComponentViewModel
        
//        data.append(ComponentViewModel(attributedText: NSAttributedString("Attributed text comes here: This is **Bold text** and this is _italic_")))

        let attributedString = NSMutableAttributedString(string: "This should be a very long attributed string that needs wrapping. This should be a very long attributed string that needs wrapping. This should be a very long attributed string that needs wrapping")
//        attributedString.addAttribute(.font, value: UIFont.systemFont (ofSize: 12), range: NSRange(location: 0, length: 5))
//        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 6, length: 6))
//        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 12, length: 5))
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location: 0, length: 4))
        attributedString.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 12), range: NSRange(location: 5, length: 6))
        attributedString.addAttribute(.font, value: UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .black), range: NSRange(location: 17, length: 7))
        model = ComponentViewModel(attributedText: attributedString)
        model.lineSpacing = 20
        data.append(model)
        var imgArr = [UIImage]()
        if let img = UIImage(named: "CuteCat1") {
            imgArr.append(img)
        }
        
        model = ComponentViewModel(attributedText: attributedString, imagesArray: imgArr)
        model.lineSpacing = 20
        data.append(model)
        
        let attributedString2 = NSMutableAttributedString(string: "This should be a shorter attributed string")
        attributedString2.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location: 0, length: 4))
        attributedString2.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 12), range: NSRange(location: 5, length: 6))
        attributedString2.addAttribute(.font, value: UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .black), range: NSRange(location: 17, length: 7))
        if let img2 = UIImage(named: "CuteCat2") {
            imgArr.append(img2)
        }
        model = ComponentViewModel(attributedText: attributedString2, imagesArray: imgArr)
        model.lineSpacing = 20
        data.append(model)
        

        if let img3 = UIImage(named: "CuteCat3") {
            imgArr.append(img3)
        }
        
        data.append(ComponentViewModel(text: "Simple text", imagesArray: imgArr))

        let attributedString3 = NSMutableAttributedString(string: "This should be a medium leghts attributed string on two lines")
        attributedString3.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location: 0, length: 4))
        attributedString3.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 12), range: NSRange(location: 5, length: 6))
        attributedString3.addAttribute(.font, value: UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .black), range: NSRange(location: 17, length: 7))
        
        model = ComponentViewModel(attributedText: attributedString3, imagesArray: imgArr)
        model.lineSpacing = 20
        data.append(model)

        
        imgArr.removeFirst()
        imgArr.removeFirst()
        data.append(ComponentViewModel(text: "Simple text long, simple text long, simple text long, simple text long, simple text long", imagesArray: imgArr))

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


