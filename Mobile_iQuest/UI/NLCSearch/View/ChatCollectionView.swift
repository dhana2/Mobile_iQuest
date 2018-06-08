//
//  ChatCollectionView.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 16/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation
import UIKit

class ChatCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    func scrollToBottom(animated: Bool = false) {
        let collectionViewContentHeight = collectionViewLayout.collectionViewContentSize.height
        performBatchUpdates(nil) { _ in
            let cgrect = CGRect(x: 0.0, y: collectionViewContentHeight - 1.0, width: 1.0, height: 1.0)
            self.scrollRectToVisible(cgrect, animated: animated)
        }
    }
}
