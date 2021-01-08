//
//  SearchViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/3/21.
//

import UIKit
import MaterialComponents
import CollectionViewWaterfallLayout

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: MDCOutlinedTextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var recentPetCollectionView: UICollectionView!
    
    let recentPetDelegate = RecentPetDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        historyTableView.reloadData()
    }
    
    func initView() {
        searchTextField.setOutlineColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        searchTextField.setOutlineColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0), for: .editing)
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.trailingViewMode = .always
        searchTextField.trailingView = UIImageView(image: UIImage(named: "ic-blue-search"))
        
        let layout = CollectionViewWaterfallLayout()
        
        layout.columnCount = 3
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        layout.minimumColumnSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        recentPetCollectionView.collectionViewLayout = layout
        
        recentPetCollectionView.delegate = recentPetDelegate
        recentPetCollectionView.dataSource = recentPetDelegate
        
    }
    
    @IBAction func searchAct(_ sender: Any) {
        print("searching...")
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        
        cell.historyLabel.text = "abcbcb"
        
        return cell
    }
    
}

