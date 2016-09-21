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
    @IBOutlet weak var buttonCreate: HMButton!
    @IBOutlet weak var buttonLoad: HMButton!
    @IBOutlet weak var buttonContinue: HMButton!
    @IBOutlet weak var buttonUpgrade: HMButton!
    @IBOutlet weak var cloudTest: HMButton!
    @IBOutlet weak var glTest: HMButton!
    
    var loadPath:String? = "test_ipad_info.plist"
    
    var importImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        
        gApp.navigationController.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        //self.clickImport(HMButton())
    }
    
    
    func showImagePicker(_ sender:UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: {})
    }
    
    //func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
    //func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool)
    //func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask
    //func navigationControllerPreferredInterfaceOrientationForPresentation(navigationController: UINavigationController) -> UIInterfaceOrientation
    //func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    //func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        for (key, obj) in info {
            print("key = \(key)")
            print("obj = \(obj)")
        }
        
        let pickerImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
        print("cond-1 \(pickerImage?.size.width)x\(pickerImage?.size.height)")
        
        guard let image = pickerImage , image.size.width > 32.0 && image.size.height > 32.0 else {
            print("FAIL-SAUCE!!!")
            self.dismiss(animated: true) { }
            return
        }
        
        importImage = image
        
        self.dismiss(animated: true) { [weak weakSelf = self] in
            weakSelf?.performSegue(withIdentifier: "import_image", sender: nil)
        }
        
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) { //[weak ws = self] in
            print("Finished Dismissing Image Picker")
        }
    }
    
    @IBAction func testPush(_ sender: UIButton) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "import_image" {
            if let image = importImage {
                if let importer = segue.destination as? ImageImportViewController {
                    importer.setUp(importImage: image, screenSize: self.view.bounds.size)
                    importImage = nil
                }
            }
        }
        if segue.identifier == "test_bounce" {
            if let bounce = segue.destination as? BounceViewController {
                bounce.loadScene(filePath: loadPath)
            }
        }
    }
    
    @IBAction func clickCreate(_ sender: UIButton) {
        showImagePicker(sender)
    }
    
    @IBAction func clickLoad(_ sender: AnyObject) {
        loadPath = "test_ipad_portrait_info.json"
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    @IBAction func clickUpgrade(_ sender: AnyObject) {
        loadPath = "test_ipad_landscape_info.json"
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    @IBAction func clickImport(_ sender: HMButton) {
        importImage = UIImage(named: "test_card.jpg")
        self.performSegue(withIdentifier: "import_image", sender: nil)
    }
    
    
    
    
    @IBAction func clickTest1(_ sender: HMButton) {
        loadPath = "test_iphone5_landscape_info.json"
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    @IBAction func clickTest2(_ sender: HMButton) {
        loadPath = "test_iphone5_portrait_info.json"
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    @IBAction func clickTest3(_ sender: HMButton) {
        loadPath = "test_iphone6_portrait_info.json"
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    @IBAction func clickTest4(_ sender: HMButton) {
        loadPath = "test_iphone6_landscape_info.json"
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
