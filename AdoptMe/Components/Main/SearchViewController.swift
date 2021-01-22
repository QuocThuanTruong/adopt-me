//
//  SearchViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/3/21.
//

import UIKit
import MaterialComponents
import CollectionViewWaterfallLayout
import Nuke

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: MDCOutlinedTextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var recentPetCollectionView: UICollectionView!
    
    let recentPetDelegate = RecentPetDelegate()
    var searchKeyHistory = [String]()
    var pets = [Pet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchData()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.initView()
            
            self.searchKeyHistory = Core.shared.getKeySearchHistory()
            
            self.historyTableView.reloadData()
            
            self.recentPetDelegate.pets = self.pets;
            
            self.recentPetCollectionView.reloadData()
        })
    }
    
    func fetchData() {
        db.collection("pets")
            .order(by: "posted_date", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.pets = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
                  return try? QueryDocumentSnapshot.data(as: Pet.self)
                }
                
                self.pets = self.pets.filter { pet in
                    return pet.is_active == 1
                }
                
                let n =  self.pets.count
                if (n >= 3) {
                    self.pets = Array(self.pets[0..<3])
                } else {
                    self.pets = Array(self.pets[0..<n])
                }
                
            }
    }
    
    func initView() {
        searchTextField.text = Core.shared.getKeyName()
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
        
        recentPetDelegate.context = self
        
        recentPetCollectionView.collectionViewLayout = layout
        
        recentPetCollectionView.delegate = recentPetDelegate
        recentPetCollectionView.dataSource = recentPetDelegate
    }
    
    @IBAction func searchAct(_ sender: Any) {
        let key = searchTextField.text ?? ""
        
        Core.shared.setKeyName(key)
        
        if (key != "") {
            Core.shared.addKeySearchToHistory(key: key)
        }
        
        self.dismiss(animated: true, completion: nil)
        
        print("searching...")
    }
    
    @IBAction func backAct(_ sender: Any) {
        Core.shared.setKeyName("")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func act_ClearAll(_ sender: Any) {
        Core.shared.clearSearchHistory()
        searchKeyHistory = Core.shared.getKeySearchHistory()
        
        historyTableView.reloadData()
    }
    
    @IBAction func act_ClearKey(_ sender: Any) {
        let button = sender as! UIButton
        
        Core.shared.clearKey(index: button.tag)
        
        searchKeyHistory = Core.shared.getKeySearchHistory()
        
        historyTableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchKeyHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        
        let index = indexPath.row
        
        cell.historyLabel.text = searchKeyHistory[index]
        cell.clearKeyButton.tag = index
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        
        searchTextField.text = searchKeyHistory[index]
        searchAct((Any).self)
    }
    
}
