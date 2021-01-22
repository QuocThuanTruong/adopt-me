//
//  HomeViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/8/20.
//

import UIKit
import Firebase
import MaterialComponents
import BottomPopUpView
import CollectionViewWaterfallLayout
import RangeSeekSlider
import Nuke

class HomeViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var searchTextField: MDCOutlinedTextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var notificationOutlets: UIButton!
    
    var bottomPopUpView: BottomPopUpView!
    var sortPickerView: UIPickerView!
    var genderPickerView: UIPickerView!
    
    let sortPickerViewDelegate = SortPickerViewDelegate()
    let genderPickerViewDelegate = GenderPickerViewDelegate()
    
    var ageRangeSlider: RangeSeekSlider!
    
    var pets = [Pet]()
    var dogs = [Pet]()
    var cats = [Pet]()
    var others = [Pet]()
    var sourcePets = [Pet]()
    
    var db = Firestore.firestore()
    
    var keyName : String = ""
    var isFav = false;
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var dogsButton: UIButton!
    @IBOutlet weak var catsButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    
    @IBOutlet weak var allUIView: HalfRoundedUIView!
    @IBOutlet weak var dogsUIView: HalfRoundedUIView!
    @IBOutlet weak var catsUIView: HalfRoundedUIView!
    @IBOutlet weak var othersUIView: HalfRoundedUIView!
    
    @IBOutlet weak var allIconButton: UIButton!
    @IBOutlet weak var dogsIconButton: UIButton!
    @IBOutlet weak var catsIconButton: UIButton!
    @IBOutlet weak var othersIconButton: UIButton!
    
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var dogsLabel: UILabel!
    @IBOutlet weak var catsLabel: UILabel!
    @IBOutlet weak var othersLabel: UILabel!
    
    @IBOutlet weak var listPetCollectionView: UICollectionView!
    
    var tabHeaderUIView : [HalfRoundedUIView] = []
    var tabButtons: [UIButton] = []
    var tabIconButtons: [UIButton] = []
    var tabLabels: [UILabel] = []
    let tabIconNormalImages: [String] = ["ic-white-all-pet", "ic-white-dog", "ic-white-cat", "ic-white-others"]
    let tabIconSelectedImages: [String] = ["ic-blue-all-pet", "ic-blue-dog", "ic-blue-cat", "ic-blue-others"]
    
    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
           
        for _ in 0...(sourcePets.count + 100) {
            let random = Int(arc4random_uniform((UInt32(100))))
               
            cellSizes.append(CGSize(width: 157, height: 157 + random))
        }
           
           return cellSizes
    }()
    
    //for test
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Nuke.ImageCache.shared.costLimit = 0
        Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
        
        fetchData()
        
        initView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        searchTextField.text = Core.shared.getKeyName()
        
        reloadPage()
    }
    
    func fetchData() {
        //All
        db.collection("pets").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            

            self.pets = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
              return try? QueryDocumentSnapshot.data(as: Pet.self)
            }
            
            self.sourcePets = self.pets
            self.listPetCollectionView.reloadData()
        }
        
        //Dog
        db.collection("pets").whereField("type", isEqualTo: 1).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.dogs = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
              return try? QueryDocumentSnapshot.data(as: Pet.self)
            }
        }
        
        //Cat
        db.collection("pets").whereField("type", isEqualTo: 2).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.cats = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
              return try? QueryDocumentSnapshot.data(as: Pet.self)
            }
        }
        
        //Others
        db.collection("pets").whereField("type", isEqualTo: 3).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.others = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
              return try? QueryDocumentSnapshot.data(as: Pet.self)
            }
        }
    }
    
    
    func initView() {
        tabHeaderUIView = [allUIView, dogsUIView, catsUIView, othersUIView]
        tabButtons = [allButton, dogsButton, catsButton, othersButton]
        tabIconButtons = [allIconButton, dogsIconButton, catsIconButton, othersIconButton]
        tabLabels = [allLabel, dogsLabel, catsLabel, othersLabel]
        
        for i in 0..<tabHeaderUIView.count {
            tabHeaderUIView[i].halfCornerRadius = 8.0
            tabHeaderUIView[i].backgroundColor = UIColor(named: "AppPrimaryColor")
        }
        
        searchTextField.setOutlineColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        searchTextField.setOutlineColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0), for: .editing)
        searchTextField.leadingViewMode = .always
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.leadingView = UIImageView(image: UIImage(named: "ic-blue-search"))
       
        //set selected tab
        setTabSelected(0)
        
        //init collection view
        let layout = CollectionViewWaterfallLayout()
        
        layout.columnCount = 2
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        layout.minimumColumnSpacing = 18
        layout.minimumInteritemSpacing = 18
        
        listPetCollectionView.collectionViewLayout = layout
        listPetCollectionView.tag = 0
        
        sortPickerView = UIPickerView()
        sortPickerView.dataSource = sortPickerViewDelegate
        sortPickerView.delegate = sortPickerViewDelegate
        
        genderPickerView = UIPickerView()
        genderPickerView.dataSource = genderPickerViewDelegate
        genderPickerView.delegate = genderPickerViewDelegate
        
        ageRangeSlider = RangeSeekSlider()
        ageRangeSlider.delegate = self
        ageRangeSlider.lineHeight = 1.5
        ageRangeSlider.tintColor = .gray
        ageRangeSlider.colorBetweenHandles = UIColor(named: "AccentColor")
        ageRangeSlider.handleColor = UIColor(named: "AccentColor")
        ageRangeSlider.minLabelFont = UIFont(name: "Helvetica Neue Medium", size: 14.0)!
        ageRangeSlider.minLabelColor = UIColor(named: "AccentColor")
        ageRangeSlider.maxLabelFont = UIFont(name: "Helvetica Neue Medium", size: 14.0)!
        ageRangeSlider.maxLabelColor = UIColor(named: "AccentColor")
        ageRangeSlider.minValue = 1
        ageRangeSlider.maxValue = 15
        
    }
    
    func setTabSelected(_ index: Int) {
        for i in 0..<tabHeaderUIView.count {
            tabHeaderUIView[i].halfCornerRadius = 8.0
            tabHeaderUIView[i].backgroundColor = UIColor(named: "AppPrimaryColor")
            
            tabIconButtons[i].setImage(UIImage(named: tabIconNormalImages[i]), for: .normal)
            tabLabels[i].textColor = .white
        }
        
        tabHeaderUIView[index].backgroundColor = .white
        tabIconButtons[index].setImage(UIImage(named: tabIconSelectedImages[index]), for: .normal)
        tabLabels[index].textColor = UIColor(named: "AppSecondaryColor")

    }
    
    @objc func addToFavorite(_ sender: Any) {
        let favButton = sender as? UIButton
        
        let pet = sourcePets[favButton!.tag]
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var favorites = data?["favorites"] as! [String]
                
                let index = favorites.firstIndex(of: pet.pet_id)
                
                if index != nil {
                    favButton?.setImage(UIImage(named: "ic-sm-white-fav"), for: .normal)
                    
                    favorites.remove(at: index!)

                } else {
                    favButton?.setImage(UIImage(named: "ic-sm-red-fav"), for: .normal)
                    
                    favorites.append(pet.pet_id)
                }
                
                db.collection("users").document(Core.shared.getCurrentUserID()).updateData(["favorites" : favorites])
                
                if (self.isFav) {
                    self.reloadPage()
                }

                } else {
                    print("Document does not exist")
                }
        }
    }
    
    @IBAction func filterAct(_ sender: Any) {
        bottomPopUpView = BottomPopUpView(wrapperContentHeight: 538)
        
        let title = UILabel()
        let sortLabel = UILabel()
        let genderLabel = UILabel()
        let ageLabel = UILabel()
        let doneButton = MDCButton()
        let cancelButton = UIButton()
        
        title.text = "Search filter"
        title.font = UIFont(name: "Helvetica Neue Medium", size: 20.0)
        title.textColor = UIColor(named: "AppTextColor")
        
        
        sortLabel.text = "Sort by:"
        sortLabel.font = UIFont(name: "Helvetica Neue Regular", size: 17.0)
        sortLabel.textColor = UIColor(named: "AppTextColor")
        
        genderLabel.text = "Gender:"
        genderLabel.font = UIFont(name: "Helvetica Neue Regular", size: 17.0)
        genderLabel.textColor = UIColor(named: "AppTextColor")
        
        ageLabel.text = "Age:"
        ageLabel.font = UIFont(name: "Helvetica Neue Regular", size: 17.0)
        ageLabel.textColor = UIColor(named: "AppTextColor")
        
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitleFont(UIFont(name: "Helvetica Neue", size: 17.0), for: .normal)
        doneButton.layer.cornerRadius = 5.0
        doneButton.backgroundColor = UIColor(named: "AppRedColor")
        doneButton.addTarget(self, action: #selector(filterDoneAct(_:)), for: .touchUpInside)
        
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "AppRedColor"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 17.0)
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "AppRedColor")?.cgColor
        cancelButton.addTarget(self, action: #selector(dissmissFilterViewAct(_:)), for: .touchUpInside)
        
        sortPickerView.backgroundColor = .white
        genderPickerView.backgroundColor = .white
        
        sortPickerView.translatesAutoresizingMaskIntoConstraints = false
        genderPickerView.translatesAutoresizingMaskIntoConstraints = false
        ageRangeSlider.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints  = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomPopUpView.shouldDismissOnDrag = true
        bottomPopUpView.view.addSubview(sortPickerView)
        bottomPopUpView.view.addSubview(genderPickerView)
        bottomPopUpView.view.addSubview(ageRangeSlider)
        bottomPopUpView.view.addSubview(title)
        bottomPopUpView.view.addSubview(sortLabel)
        bottomPopUpView.view.addSubview(genderLabel)
        bottomPopUpView.view.addSubview(ageLabel)
        bottomPopUpView.view.addSubview(doneButton)
        bottomPopUpView.view.addSubview(cancelButton)
           
        let cancelBtnWC = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)
        let cancelBtnHC = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let cancelBtnX = NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: -20)
        let cancelBtnY = NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .bottom, multiplier: 1, constant: -36)
        
        let doneBtnWC = NSLayoutConstraint(item: doneButton, attribute: .width, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)
        let doneBtnHC = NSLayoutConstraint(item: doneButton, attribute: .height, relatedBy: .equal,
                                           toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let doneBtnX = NSLayoutConstraint(item: doneButton, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: 20)
        let doneBtnY = NSLayoutConstraint(item: doneButton, attribute: .bottom, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .bottom, multiplier: 1, constant: -36)
        
        //sort picker
        let sortPickerHC = NSLayoutConstraint(item: sortPickerView!, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)

        let sortPickerXL = NSLayoutConstraint(item: sortPickerView!, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .leading, multiplier: 1, constant: 18)
        
        let sortPickerXT = NSLayoutConstraint(item: sortPickerView!, attribute: .trailing, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .trailing, multiplier: 1, constant: -18)
        
        let sortPickerY = NSLayoutConstraint(item: sortPickerView!, attribute: .bottom, relatedBy: .equal, toItem: genderLabel, attribute: .top, multiplier: 1, constant: -8)
        
        let sortLabelX = NSLayoutConstraint(item: sortLabel, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .leading, multiplier: 1, constant: 20)
        
        let sortLabelY = NSLayoutConstraint(item: sortLabel, attribute: .bottom, relatedBy: .equal, toItem: sortPickerView!, attribute: .top, multiplier: 1, constant: 14)
        
        //gender picker
        let genderPickerHC = NSLayoutConstraint(item: genderPickerView!, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)

        let genderPickerXL = NSLayoutConstraint(item: genderPickerView!, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .leading, multiplier: 1, constant: 18)
        
        let genderPickerXT = NSLayoutConstraint(item: genderPickerView!, attribute: .trailing, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .trailing, multiplier: 1, constant: -18)
        
        let genderPickerY = NSLayoutConstraint(item: genderPickerView!, attribute: .bottom, relatedBy: .equal, toItem: ageLabel, attribute: .top, multiplier: 1, constant: -6)
        
        let genderLabelX = NSLayoutConstraint(item: genderLabel, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .leading, multiplier: 1, constant: 20)
        
        let genderLabelY = NSLayoutConstraint(item: genderLabel, attribute: .bottom, relatedBy: .equal, toItem: genderPickerView!, attribute: .top, multiplier: 1, constant: 14)
        
        //age range slider
        let ageSliderHC = NSLayoutConstraint(item: ageRangeSlider!, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80)

        let ageSliderXL = NSLayoutConstraint(item: ageRangeSlider!, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .leading, multiplier: 1, constant: 18)
        
        let ageSliderXT = NSLayoutConstraint(item: ageRangeSlider!, attribute: .trailing, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .trailing, multiplier: 1, constant: -18)
        
        let ageSliderY = NSLayoutConstraint(item: ageRangeSlider!, attribute: .bottom, relatedBy: .equal, toItem: cancelButton, attribute: .top, multiplier: 1, constant: -22)
        
        let ageLabelX = NSLayoutConstraint(item: ageLabel, attribute: .leading, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .leading, multiplier: 1, constant: 22)
        
        let ageLabelY = NSLayoutConstraint(item: ageLabel, attribute: .bottom, relatedBy: .equal, toItem: ageRangeSlider!, attribute: .top, multiplier: 1, constant: 12)
        
        
        //modal title
        let titleX = NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: bottomPopUpView.view, attribute: .centerX, multiplier: 1, constant: 0)
        let titleY = NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: sortLabel, attribute: .top, multiplier: 1, constant: -22)

        NSLayoutConstraint.activate([cancelBtnWC, cancelBtnHC, cancelBtnX, cancelBtnY, doneBtnWC, doneBtnHC, doneBtnX, doneBtnY, titleX, titleY, sortPickerHC, sortPickerXL, sortPickerXT, sortPickerY, sortLabelX, sortLabelY, genderPickerHC, genderPickerY, genderPickerXL, genderPickerXT, genderLabelX, genderLabelY, ageSliderHC, ageSliderXL, ageSliderXT, ageSliderY, ageLabelX, ageLabelY])
        
        self.present(bottomPopUpView, animated: true, completion: nil)
    }
    
    @objc func dissmissFilterViewAct(_ sender: Any) {
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @objc func filterDoneAct(_ sender: Any) {
        reloadPage()
        
        bottomPopUpView.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewNotificationAct(_ sender: Any) {
        
    }
    
    @IBAction func searchAct(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        dest.modalPresentationStyle = .fullScreen
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func viewAllPetAct(_ sender: Any) {
        setTabSelected(0)
        
        listPetCollectionView.tag = 0;
        
        reloadPage()
    }
    
    @IBAction func viewDogsAct(_ sender: Any) {
        setTabSelected(1)
        
        listPetCollectionView.tag = 1;
        print("1")
        
        reloadPage()
    }
    
    @IBAction func viewCatsAct(_ sender: Any) {
        setTabSelected(2)
        
        listPetCollectionView.tag = 2;
        print("2")
        reloadPage()
    }
    
    @IBAction func viewOthersAct(_ sender: Any) {
        setTabSelected(3)
        
        listPetCollectionView.tag = 3;
        print("3")
        reloadPage()
    }
    
    func reloadPage() {
        let keyName = searchTextField.text ?? ""
        
        let sortSelected = sortPickerView.selectedRow(inComponent: 0)
        let genderSelected = genderPickerView.selectedRow(inComponent: 0)
        let minAgeSelected : Int = Int(floor(ageRangeSlider.selectedMinValue))
        let maxAgeSelected : Int = Int(floor(ageRangeSlider.selectedMaxValue))
        
        var sortBy  = (by: "posted_date", descending: true)
        switch sortSelected {
        case 0:
            sortBy.by = "posted_date"
            sortBy.descending = true
            break;
        case 1:
            sortBy.by = "posted_date"
            sortBy.descending = false
            break;
        case 2:
            sortBy.by = "name"
            sortBy.descending = true
            break;
        case 3:
            sortBy.by = "name"
            sortBy.descending = false
            break;
        default:
            break;
        }
        
        switch listPetCollectionView.tag {
        case 0:
            db.collection("pets")
                .order(by: sortBy.by, descending: sortBy.descending)
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        
                        self.sourcePets = [Pet]()
                        self.listPetCollectionView.reloadData()
                        return
                    }
                    
                    self.sourcePets = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
                      return try? QueryDocumentSnapshot.data(as: Pet.self)
                    }
                    
                    self.sourcePets = self.sourcePets.filter { pet in
                        return pet.is_active == 1
                    }

                    self.sourcePets = self.sourcePets.filter { pet in
                        return pet.age >= minAgeSelected && pet.age <= maxAgeSelected
                    }
                    
                    if (genderSelected != 0) {
                        let genderFilter = genderSelected == 1
                        
                        self.sourcePets = self.sourcePets.filter { pet in
                            return pet.gender == genderFilter
                        }
                        
                    }
                    
                    if (keyName != "") {
                        self.sourcePets = self.sourcePets.filter { pet in
                            return pet.name
                                .uppercased()
                                .folding(options: .diacriticInsensitive, locale: Locale.current)
                                .contains(keyName
                                            .uppercased()
                                            .folding(options: .diacriticInsensitive, locale: Locale.current)
                                )
                        }
                    }
                    
                    if (self.isFav) {
                        self.db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { (document, error) in
                            if let document = document, document.exists {
                                let data = document.data()
                                let favorites = data?["favorites"] as! [String]
                                
                                self.sourcePets = self.sourcePets.filter { pet in
                                    return favorites.firstIndex(of: pet.pet_id) != nil
                                }

                                self.listPetCollectionView.reloadData()
                            } else {
                                print("Document does not exist")
                            }
                        }
                    } else {
                        self.listPetCollectionView.reloadData()
                    }
                }
            break;
        default:
            db.collection("pets")
                .order(by: sortBy.by, descending: sortBy.descending)
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        
                        self.listPetCollectionView.reloadData()
                        return
                    }
                    
                    
                    self.sourcePets = documents.compactMap { (QueryDocumentSnapshot) -> Pet? in
                      return try? QueryDocumentSnapshot.data(as: Pet.self)
                    }
                    
                    self.sourcePets = self.sourcePets.filter { pet in
                        return pet.is_active == 1
                    }
                    
                    self.sourcePets = self.sourcePets.filter { pet in
                        return pet.type == self.listPetCollectionView.tag
                    }
                    
                    self.sourcePets = self.sourcePets.filter { pet in
                        return pet.age >= minAgeSelected && pet.age <= maxAgeSelected
                    }
                    
                    if (genderSelected != 0) {
                        let genderFilter = genderSelected == 1
                        
                        self.sourcePets = self.sourcePets.filter { pet in
                            return pet.gender == genderFilter
                        }
                    }
                    
                    if (keyName != "") {
                        self.sourcePets = self.sourcePets.filter { pet in
                            return pet.name
                                .uppercased()
                                .folding(options: .diacriticInsensitive, locale: Locale.current)
                                .contains(keyName
                                            .uppercased()
                                            .folding(options: .diacriticInsensitive, locale: Locale.current)
                                )
                        }
                    }
                    
                    if (self.isFav) {
                        self.db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { (document, error) in
                            if let document = document, document.exists {
                                let data = document.data()
                                let favorites = data?["favorites"] as! [String]
                                
                                self.sourcePets = self.sourcePets.filter { pet in
                                    return favorites.firstIndex(of: pet.pet_id) != nil
                                }

                                self.listPetCollectionView.reloadData()
                            } else {
                                print("Document does not exist")
                            }
                        }
                    } else {
                        self.listPetCollectionView.reloadData()
                    }
                    
                    
                }
        }
    }
    
    @IBAction func logout_act(_ sender: Any) {
        let token = Core.shared.getToken()
        Core.shared.setToken("")
        
        let userCollection = Firestore.firestore().collection("users")

        userCollection.whereField("token", isEqualTo: token).limit(to: 1)
            .getDocuments{(querySnapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    if querySnapshot!.documents.count == 1 {
                        let data = querySnapshot?.documents[0].data()
                        
                        userCollection.document(data?["UID"] as! String).updateData(["token": ""])
                    }
                }
            }
    }
    
}

extension HomeViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        
    }
}

extension HomeViewController: UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourcePets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath) as! PetCollectionViewCell
            
        let index = indexPath.row
        let pet = sourcePets[index]
        
        cell.addFavButton.layer.cornerRadius = cell.addFavButton.frame.height / 2
        cell.addFavButton.tag = indexPath.row
        
        db.collection("users").document(Core.shared.getCurrentUserID()).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let favorites = data?["favorites"] as! [String]
                
                let index = favorites.firstIndex(of: pet.pet_id)
                
                if index != nil {
                    cell.addFavButton.setImage(UIImage(named: "ic-sm-red-fav"), for: .normal)

                } else {
                    cell.addFavButton.setImage(UIImage(named: "ic-sm-white-fav"), for: .normal)
    
                }

                } else {
                    print("Document does not exist")
                }
        }
        
        cell.petNameLabel.text = pet.name
        
        let today = Date()
        
        let diffComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: pet.posted_date, to: today)
        let year = diffComponents.year ?? 0
        let month = diffComponents.month ?? 0
        let day = diffComponents.day ?? 0
        let hours = diffComponents.hour ?? 0
        let minutes = diffComponents.minute ?? 0
        
        if (year > 0 || month > 0) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            
            cell.postedDateLabel.text = "Posted: \(dateFormatterPrint.string(from: pet.posted_date))"
        } else if (day > 0) {
            if (day == 1) {
                cell.postedDateLabel.text = "Posted: 1 day ago"
            } else {
                cell.postedDateLabel.text = "Posted: \(day) days ago"
            }
            
        } else if (hours > 0) {
            if (hours == 1) {
                cell.postedDateLabel.text = "Posted: 1 hour ago"
            } else {
                cell.postedDateLabel.text = "Posted: \(hours) hours ago"
            }
        } else {
            if (minutes == 0) {
                cell.postedDateLabel.text = "Posted: now"
            }
            else if (minutes == 1) {
                cell.postedDateLabel.text = "Posted: 1 minute ago"
            } else {
                cell.postedDateLabel.text = "Posted: \(minutes) minutes ago"
            }
        }
    
        
        
        cell.petAvatarImage.layer.cornerRadius = 16
        cell.petAvatarImage.clipsToBounds = true
        
        cell.addFavButton.addTarget(self, action: #selector(addToFavorite(_:)), for: .touchUpInside)
        
        guard let urlStr = URL(string: pet.avatar) else {
            return cell
        }
        
        let urlReq = URLRequest(url: urlStr)
        Nuke.loadImage(with: urlReq, into: cell.petAvatarImage)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dest = self.storyboard?.instantiateViewController(withIdentifier: "PetDetailViewController") as! PetDetailViewController
        
        let index = indexPath.row
        let pet = sourcePets[index]
        
        dest.modalPresentationStyle = .fullScreen
        dest.pet = pet
        
        self.present(dest, animated: true, completion: nil)
    }
}
