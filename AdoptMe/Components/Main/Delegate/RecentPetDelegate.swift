//
//  RecentPetDelegate.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/4/21.
//

import Foundation
import UIKit
import CollectionViewWaterfallLayout
import Nuke

class RecentPetDelegate : NSObject, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    var pets = [Pet]()
    var context: UIViewController!
    
    func fetchData() {
        db.collection("pets")
            .order(by: "posted_date", descending: true)
            .limit(to: 3)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.pets = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
                  return try? QueryDocumentSnapshot.data(as: Pet.self)
                }
            }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       
       
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPetCollectionViewCell", for: indexPath) as! RecentPetCollectionViewCell
        
        let index = indexPath.row
        let pet = pets[index]
        
        guard let urlStr = URL(string: pet.avatar) else {
            return cell
        }
        
        let urlReq = URLRequest(url: urlStr)
        
        Nuke.loadImage(with: urlReq, into: cell.recentPetImageView)
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let dest = storyboard.instantiateViewController(withIdentifier: "PetDetailViewController") as! PetDetailViewController
        
        let index = indexPath.row
        let pet = pets[index]
        print("selected recent: \(index)")
        
        dest.modalPresentationStyle = .fullScreen
        dest.pet = pet
        
        context.present(dest, animated: true, completion: nil)
        
        
    }
}

