//
//  ComponentViewModelDataType.swift
//  IGListKitComponent
//
//  Created by Valentin Diaconeasa on 28.10.2022.
//

import Foundation
import UIKit

public protocol ComponentViewModelDataType {
    var text: String? { get set }
    var attributedText: NSAttributedString? { get set }
    var imagesArray: [UIImage] { get set }
}
