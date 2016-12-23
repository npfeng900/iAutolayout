//
//  ViewController.swift
//  iAutolayout
//
//  Created by Niu Panfeng on 23/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    /** ViewController 生命周期*/
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("init(nibName = \(nibNameOrNil), bundle = \(nibBundleOrNil))")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init?(coder = \(aDecoder)")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib()")
    }
    override func viewDidLoad() {
        print("viewDidLoad()  bounds = \(view.bounds.size)")
        super.viewDidLoad()
        updateUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear(animated = \(animated))")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear(animated = \(animated))")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear(animated = \(animated))")
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear(animated = \(animated))")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews() bounds = \(view.bounds.size)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews() bounds = \(view.bounds.size)")
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("viewWillTransitionToSize(size, withTransitionCoordinator)")
    }
    deinit {
        print("deinit")
    }
    /***********************************************/
    
    var secure: Bool = false { didSet{ updateUI() } }
    var loggedInUser: User? { didSet{ updateUI() } }
    
    private func updateUI() {
        passwordLabel.text = secure ? "Secured Password" : "Password"
        passwordField.secureTextEntry = secure
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        newimage = loggedInUser?.image
        //设置imageView.image时，没有设置新的newimage
        //imageView.image = loggedInUser?.image 
        
        
        
    }
    
    @IBAction func toggleSecurity(sender: UIButton) {
        secure = !secure
    }
    @IBAction func login(sender: UIButton) {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
    }
    
    //布局约束
    var newimage: UIImage? {
        get {
            return imageView.image
        }
        set{
            imageView.image = newValue
            if let constrainedView = imageView
            {
                if let newImage = newValue
                {
                    aspectRationConstraint = NSLayoutConstraint(
                        item: constrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                }
                else
                {
                    aspectRationConstraint = nil
                }
            }
        }
    }
    var aspectRationConstraint: NSLayoutConstraint?{
        willSet{
            if let existingConstraint = aspectRationConstraint {
                view.removeConstraint(existingConstraint)
            }
        }
        didSet{
            if let newConstraint = aspectRationConstraint {
                view.addConstraint(newConstraint)
            }
        }
    }
}
/** User的图片属性扩展 */
extension User {
    var image: UIImage? {
        if let image = UIImage(named: login)
        {
            return image
        }
        else
        {
            return UIImage(named: "unkown_user")
        }
    }
}
/** UIImage的图片比例属性扩展 */
extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

