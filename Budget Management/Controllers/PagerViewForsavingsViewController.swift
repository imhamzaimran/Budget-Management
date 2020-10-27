//
//  PagerViewForsavingsViewController.swift
//  Budget Management
//
//  Created by Intern on 26/10/2020.
//

import UIKit
import XLPagerTabStrip
import SideMenu

class PagerViewForsavingsViewController: ButtonBarPagerTabStripViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem = UITabBarItem(title: "Savings", image: UIImage(named: Constants.Images.savingsTab), tag: 3)
    }
    
    override func viewDidLoad() {
        
        setUpPagaingView()
        super.viewDidLoad()
        
        setupSideMenu()
        updateMenus()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.savings) as! SavingsViewController
        child1.childNumber = "RUNNING"
        
        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.goalAchieved) as! GoalAchievedViewController
        child2.childNumber = "ACHIEVED"
        
        return [child1, child2]
    }
}

// MARK:- Side Menu Setup

extension PagerViewForsavingsViewController {

    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        //        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.sideMenuNavigationController) as? SideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: SideMenuManager.PresentDirection.left)
    }
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        //          return modes[presentationStyleSegmentedControl.selectedSegmentIndex]
        return .menuSlideIn
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.menuStartAlpha = CGFloat(0.5)
        presentationStyle.menuScaleFactor = CGFloat(1.0)
        presentationStyle.presentingEndAlpha = CGFloat(0.5)
        presentationStyle.presentingScaleFactor = CGFloat(1.0)
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * CGFloat(0.75)
        
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[0]
        settings.statusBarEndAlpha = 0
        
        return settings
    }
}

//MARK:- XLPagerStripTab extension

extension PagerViewForsavingsViewController {
    
}