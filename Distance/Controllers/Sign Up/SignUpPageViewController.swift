//
//  SignUpPageViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Firebase

class SignUpPageViewController: UIPageViewController {
    
    var newUser = User()
    var currentIndex = Int()
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newViewControllers(id: "name"),
            self.newViewControllers(id: "email"),
            self.newViewControllers(id: "phone"),
            self.newViewControllers(id: "password")
        ]
    }()
    
    private func newViewControllers(id: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signup\(id)")
    }
    
    lazy var progressView: UIProgressView = {
        var progressView = UIProgressView()
        progressView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 5)
        progressView.progressTintColor = UIColor.FlatColor.teal
        progressView.trackTintColor = UIColor.clear
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        progressView.setProgress(0.05, animated: true)
        return progressView
    }()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        dataSource = self
        if let nameViewController = orderedViewControllers.first as? NameViewController,
            let emailViewController = orderedViewControllers[1] as? EmailViewController,
            let phoneViewController = orderedViewControllers[2] as? PhoneNumberViewController,
            let passwordViewController = orderedViewControllers.last as? PasswordViewController {
            
            nameViewController.signupPageVC = self
            emailViewController.signupPageVC = self
            phoneViewController.signupPageVC = self
            passwordViewController.signupPageVC = self
            
            setViewControllers([nameViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        findScrollView(false)
        self.navigationController?.setTransparent(navigationController: self.navigationController!)
        self.navigationController?.navigationBar.addSubview(progressView)
        self.view.backgroundColor = UIColor.white
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        if currentIndex != 0 {
            self.previousPage()
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func nextPage() {
        guard let currentViewController = self.orderedViewControllers[currentIndex] as? UIViewController else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        print(nextViewController)
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        progressView.setProgress(calculateProgress(), animated: true)
    }
    
    func previousPage() {
        guard let currentViewController = self.orderedViewControllers[currentIndex] as? UIViewController else
        { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        print(previousViewController)
        setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
        progressView.setProgress(calculateProgress(), animated: true)
    }
    
    private func calculateProgress() -> Float {
        var progress: Float = 0.0
        if currentIndex == 0 {
            progress = Float(0.05)
        } else if currentIndex == 1 {
            progress = Float(0.33)
        } else if currentIndex == 2 {
            progress = Float(0.66)
        } else {
            progress = Float(0.95)
        }
        return progress
    }
    
    func findScrollView(_ enabled : Bool) {
        for view in self.view.subviews {
            if view is UIScrollView {
                let scrollView = view as! UIScrollView
                scrollView.isScrollEnabled = enabled
            } else {
                print("UIScrollView does not exist on this View")
            }
        }
    }
    
    func completeSignUp() {
        Auth.auth().createUser(withEmail: newUser.email!, password: newUser.password!) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            self.registerUserIntoDatabase(uid)
        }
    }
    
    func registerUserIntoDatabase(_ uid: String) {
        let values = ["name": "\(newUser.name!)", "phone": newUser.phone!, "email": newUser.email!]
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            //phone verification will do later.
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension SignUpPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        self.currentIndex = previousIndex
        print(previousIndex)
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        self.currentIndex = nextIndex
        print(nextIndex)
        
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}
