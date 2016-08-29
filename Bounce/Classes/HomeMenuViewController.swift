//
//  HomeMenuViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class HomeMenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var buttonCreate: RRButton!
    @IBOutlet weak var buttonLoad: RRButton!
    @IBOutlet weak var buttonContinue: RRButton!
    @IBOutlet weak var buttonUpgrade: RRButton!
    @IBOutlet weak var cloudTest: RRButton!
    @IBOutlet weak var glTest: RRButton!
    
    var loadPath:String? = "test_ipad_info.plist"
    
    var importImage: UIImage?
    
    override func viewWillAppear(animated: Bool) {
        
        gApp.navigationController.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        //self.clickImport(RRButton())
    }
    
    
    func showImagePicker(sender:UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: {})
    }
    
    //func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
    //func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool)
    //func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask
    //func navigationControllerPreferredInterfaceOrientationForPresentation(navigationController: UINavigationController) -> UIInterfaceOrientation
    //func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    //func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    internal func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        for (key, obj) in info {
            print("key = \(key)")
            print("obj = \(obj)")
        }
        
        let pickerImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
        print("cond-1 \(pickerImage?.size.width)x\(pickerImage?.size.height)")
        
        guard let image = pickerImage where image.size.width > 32.0 && image.size.height > 32.0 else {
            print("FAIL-SAUCE!!!")
            self.dismissViewControllerAnimated(true) { }
            return
        }
        
        importImage = image
        
        self.dismissViewControllerAnimated(true) { [weak weakSelf = self] in
            weakSelf?.performSegueWithIdentifier("import_image", sender: nil)
        }
        
    }
    
    internal func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true) { //[weak ws = self] in
            print("Finished Dismissing Image Picker")
        }
    }
    
    @IBAction func testPush(sender: UIButton) {
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "import_image" {
            if let image = importImage {
                if let importer = segue.destinationViewController as? ImageImportViewController {
                    importer.setUp(importImage: image, screenSize: self.view.bounds.size)
                    importImage = nil
                }
            }
        }
        if segue.identifier == "test_bounce" {
            if let bounce = segue.destinationViewController as? BounceViewController {
                bounce.loadScene(filePath: loadPath)
            }
        }
    }
    
    @IBAction func clickCreate(sender: UIButton) {
        showImagePicker(sender)
    }
    
    @IBAction func clickLoad(sender: AnyObject) {
        loadPath = "test_ipad_portrait_info.json"
        performSegueWithIdentifier("test_bounce", sender: nil)
    }
    
    @IBAction func clickUpgrade(sender: AnyObject) {
        loadPath = "test_ipad_landscape_info.json"
        performSegueWithIdentifier("test_bounce", sender: nil)
    }
    
    @IBAction func clickImport(sender: RRButton) {
        importImage = UIImage(named: "test_card.jpg")
        self.performSegueWithIdentifier("import_image", sender: nil)
    }
    
    
    
    
    @IBAction func clickTest1(sender: RRButton) {
        loadPath = "test_iphone5_landscape_info.json"
        performSegueWithIdentifier("test_bounce", sender: nil)
    }
    
    @IBAction func clickTest2(sender: RRButton) {
        loadPath = "test_iphone5_portrait_info.json"
        performSegueWithIdentifier("test_bounce", sender: nil)
    }
    
    @IBAction func clickTest3(sender: RRButton) {
        loadPath = "test_iphone6_portrait_info.json"
        performSegueWithIdentifier("test_bounce", sender: nil)
    }
    
    @IBAction func clickTest4(sender: RRButton) {
        loadPath = "test_iphone6_landscape_info.json"
        performSegueWithIdentifier("test_bounce", sender: nil)
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
