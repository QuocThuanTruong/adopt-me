//
//  RecentPetDelegate.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/4/21.
//

import Foundation
import UIKit
import CollectionViewWaterfallLayout

class RecentPetDelegate : NSObject, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPetCollectionViewCell", for: indexPath) as! RecentPetCollectionViewCell
        
        cell.recentPetButton.setImage(UIImage(named: "test_avt"), for: .normal)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
