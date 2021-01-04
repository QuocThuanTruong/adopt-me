//
//  IntroductionViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/5/20.
//

import UIKit
import LZViewPager

class IntroductionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var viewPager: LZViewPager!
    @IBOutlet weak var pageControl: UIPageControl!
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initViewPager()
    }
    
    func initViewPager() {
        viewPager.hostController = self
        
        let landingPage1VC = self.storyboard?.instantiateViewController(withIdentifier: "LandingPage1VC") as! LandingPage1VC
        let landingPage2VC = self.storyboard?.instantiateViewController(withIdentifier: "LandingPage2VC") as! LandingPage2VC
        let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        
        landingPage1VC.delegate = self
        landingPage2VC.delegate = self
    
        viewControllers = [landingPage1VC, landingPage2VC, welcomeVC]
        
        viewPager.reload()
    }
    
    @IBAction func changePageAct(_ sender: Any) {
        print(pageControl.currentPage)
        viewPager.select(index: pageControl.currentPage)
    }
}

extension IntroductionViewController: IntroductionDelegate {
    func skipIntroduce() {
        let destPage = viewControllers.count - 1
        viewPager.select(index: destPage)
        pageControl.currentPage = destPage
    }
    
    func nextIntroduce() {
        pageControl.currentPage += 1
        viewPager.select(index: pageControl.currentPage)
    }
}

extension IntroductionViewController: LZViewPagerDelegate, LZViewPagerDataSource {
    func numberOfItems() -> Int {
        return viewControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let dummyButton = UIButton()
        
        return dummyButton
    }
    
    func shouldShowIndicator() -> Bool {
        return false
    }
    
    func heightForHeader() -> CGFloat {
        return 0
    }
    
    func didTransition(to index: Int) {
        pageControl.currentPage = viewPager.currentIndex!
    }
}

