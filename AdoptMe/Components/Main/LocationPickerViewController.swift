//
//  LocationPickerViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/19/21.
//

import UIKit
import CoreLocation
import MapKit
import MaterialComponents

final class LocationPickerViewController: UIViewController {

    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private var isPickable = true
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()

    init(coordinates: CLLocationCoordinate2D?) {
        self.coordinates = coordinates
        self.isPickable = coordinates == nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
                    
        if isPickable {
           
            map.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(didTapMap(_:)))
            gesture.numberOfTouchesRequired = 1
            gesture.numberOfTapsRequired = 1
            map.addGestureRecognizer(gesture)
        }
        else {
            // just showing location
            guard let coordinates = self.coordinates else {
                return
            }
            
            // drop a pin on that location
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            map.addAnnotation(pin)
        }
        view.addSubview(map)
        
        if isPickable {
            let doneButton = MDCButton()
            let cancelButton = UIButton()
            
            doneButton.setTitle("DONE", for: .normal)
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.setTitleFont(UIFont(name: "Helvetica Neue", size: 17.0), for: .normal)
            doneButton.layer.cornerRadius = 5.0
            doneButton.backgroundColor = UIColor(named: "AppRedColor")
            doneButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
            
            cancelButton.setTitle("CANCEL", for: .normal)
            cancelButton.setTitleColor(UIColor(named: "AppRedColor"), for: .normal)
            cancelButton.backgroundColor = .white
            cancelButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 17.0)
            cancelButton.layer.cornerRadius = 5.0
            cancelButton.layer.borderWidth = 1
            cancelButton.layer.borderColor = UIColor(named: "AppRedColor")?.cgColor
            cancelButton.addTarget(self, action: #selector(dissmissAct(_:)), for: .touchUpInside)
        
            doneButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(doneButton)
            self.view.addSubview(cancelButton)
            
            let cancelBtnWC = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal,
                                               toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)
            let cancelBtnHC = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal,
                                               toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
            let cancelBtnX = NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: -20)
            let cancelBtnY = NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -36)
            
            let doneBtnWC = NSLayoutConstraint(item: doneButton, attribute: .width, relatedBy: .equal,
                                               toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160)
            let doneBtnHC = NSLayoutConstraint(item: doneButton, attribute: .height, relatedBy: .equal,
                                               toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
            let doneBtnX = NSLayoutConstraint(item: doneButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 20)
            let doneBtnY = NSLayoutConstraint(item: doneButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -36)
        
            NSLayoutConstraint.activate([cancelBtnX, cancelBtnY, cancelBtnWC, cancelBtnHC, doneBtnX, doneBtnY, doneBtnWC, doneBtnHC])
        } else {
            let backButton = UIButton()
            
            backButton.setImage(UIImage(named: "back-black-arrow"), for: .normal)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.addTarget(self, action: #selector(dissmissAct(_:)), for: .touchUpInside)
            self.view.addSubview(backButton)
            
            let wC = NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 40)
            
            let hC = NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
            
            let xC = NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 8)
            
            let yC = NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 8)
            
            NSLayoutConstraint.activate([wC, hC, xC, yC])
        }
    }
    
    @objc func dissmissAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func sendButtonTapped() {
        guard let coordinates = coordinates else {
            return
        }
        self.dismiss(animated: true, completion: nil)
        completion?(coordinates)
    }

    @objc func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates

        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }

        // drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }

}

