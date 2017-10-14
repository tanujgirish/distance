//
//  SignUpPageViewController.swift
//  Distance
//
//  Created by Tanuj Girish on 9/27/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import Alamofire

class SignUpPageViewController: UIPageViewController {
    
    var newUser = User()
    var currentIndex = Int()
    var customer = STPCustomer()
    
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newViewControllers(id: "name"),
            self.newViewControllers(id: "email"),
            self.newViewControllers(id: "password"),
            self.newViewControllers(id: "phone")
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
            let passwordViewController = orderedViewControllers[2] as? PasswordViewController,
            let phoneViewController = orderedViewControllers.last as? PhoneNumberViewController {
            
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
        Auth.auth().createUser(withEmail: "\(newUser.phone!)@distance.com", password: newUser.password!) { (user, error) in
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
            self.createCustomer(uid)
        }
    }
    
    func createCustomer(_ uid: String) {
        let url = "https://us-central1-distance-c3c4a.cloudfunctions.net/CreateNewStripeCustomer"
        let parameters: [String: Any] = ["uid": uid, "email": newUser.email!]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            switch response.response?.statusCode {
            case 200?:
                if let stripeId = String(data: response.data!, encoding: .utf8) as? String {
                    self.saveStripeCustomerId(stripeCustomerId: stripeId, uid: uid)
                }
            case 400?:
                print(response.data)
            default:
                print(response.data)
            }
        }
    }
    
    func saveStripeCustomerId(stripeCustomerId: String, uid: String) {
        let ref = Database.database().reference().child("users").child(uid)
        let values = ["stripeCustomerId": stripeCustomerId]
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.presentPhoneVerificationVC()
            }
        }
    }
    
    
    
    private func presentPhoneVerificationVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "phoneverificationvc") as! PhoneVerificationViewController
        vc.phoneNumber = self.newUser.phone!
        self.navigationController?.pushViewController(vc, animated: true)
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
