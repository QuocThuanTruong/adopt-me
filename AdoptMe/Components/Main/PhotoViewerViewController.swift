//
//  PhotoViewerViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/20/21.
//

import UIKit
import Nuke

final class PhotoViewerViewController: UIViewController {

    private let url: URL

    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        Nuke.loadImage(with: url, into: imageView)
        
        setupBackButton()
    }
    
    @objc func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupBackButton() {
        let backButton = UIButton()
        
        backButton.setImage(UIImage(named: "back-white-arrow"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backAct(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let wC = NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 40)
        
        let hC = NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
        
        let xC = NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 8)
        
        let yC = NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 8)
        
        NSLayoutConstraint.activate([wC, hC, xC, yC])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }


}
