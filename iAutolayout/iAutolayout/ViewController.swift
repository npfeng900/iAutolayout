//
//  ViewController.swift
//  iAutolayout
//
//  Created by Niu Panfeng on 23/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /*
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
    }*/
    /***********************************************/
    // MARK: - Internationailization
    private struct LocalizedString {
        struct AlertLoginError {
            static let Title = NSLocalizedString("Login Error",
                comment: "Title of alert when user types in an incorrect user name or password")
            static let Message = NSLocalizedString("Invalid user name or password",
                comment: " Message in an alert when the user types in an incorrect user name or password")
            static let DismissButton = NSLocalizedString("Try Again",
                comment: "The only button available in an alert presented when the user types in an incorrect user name or password")
        }
        static let PasswordText = NSLocalizedString("Password",
            comment: "Prompt for the user's password when no secure")
        static let SecuredPasswordText = NSLocalizedString("Secured Password",
            comment: "Prompt for the user's obscured password")
    }
    
    // MARK: - Outlet
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var lastLoginInfoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!

    // MARK: -
    var secure: Bool = false { didSet{ updateUI() } }
    var loggedInUser: User? { didSet{ updateUI() } }
    
    @IBAction func toggleSecurity(sender: UIButton) {
        secure = !secure
    }
    @IBAction func login(sender: UIButton) {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
        if loggedInUser == nil {
            let alert = UIAlertController(title: LocalizedString.AlertLoginError.Title,
                message: LocalizedString.AlertLoginError.Message,
                preferredStyle: .Alert)
            let action = UIAlertAction(title: LocalizedString.AlertLoginError.DismissButton,
                style: .Default,
                handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    // MARK: -
    private func updateUI() {
        passwordLabel.text = secure ? LocalizedString.SecuredPasswordText : LocalizedString.PasswordText
        passwordField.secureTextEntry = secure
        newImage = loggedInUser?.image
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        if let lastLoginTime = loggedInUser?.lastLoginTime {
            // time
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            let time = dateFormatter.stringFromDate(lastLoginTime)
            // days
            let numberFormatter = NSNumberFormatter()
            numberFormatter.maximumFractionDigits = 1
            let daysAgo = numberFormatter.stringFromNumber( -lastLoginTime.timeIntervalSinceNow/(60*60*24) )!
            
            let lastLoginInfoString = NSLocalizedString("Last Login %@ days ago at %@", comment: "Report the number of days ago and time that the user last logged in")
            lastLoginInfoLabel.text = String.localizedStringWithFormat(lastLoginInfoString, daysAgo, time)
        } else {
            lastLoginInfoLabel.text = ""
        }
    }
    

    // MARK: - newImage
    //newImage(属性观测器会自动生成约束)
    var newImage: UIImage? {
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
    // 比例约束（属性观测器会自动添加删除约束）
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
// MARK: - extension
/** User的扩展属性image */
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
/** UIImage的图片比例 */
extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

