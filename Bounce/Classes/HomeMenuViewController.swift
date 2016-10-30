//
//  HomeMenuViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
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
    
    
    var tiltOffsetMax: CGFloat = 40.0
    var tiltOffset = CGPoint.zero
    var tiltResetAnimation = false
    var tiltResetTime: Int = 30
    var tiltResetTimer: Int = 0
    var tiltResetStartOffset = CGPoint.zero
    var tiltResetEndOffset = CGPoint.zero
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ApplicationController.shared.navigationController?.setNavigationBarHidden(true, animated: true)
        
        AppDelegate.root.addUpdateObject(self)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.root.removeUpdateObject(self)
    }
    
    override func viewDidLoad() {
        //self.clickImport(HMButton())
    }
    
    
    func showImagePicker(_ sender:UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        AppDelegate.root.present(imagePicker, animated: true, completion: {})
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tiltResetAnimation = true
        tiltResetTimer = 0
        tiltResetStartOffset = tiltOffset
        tiltResetEndOffset = CGPoint.zero
    }
    
    func update() {
        
        if tiltResetAnimation {
            
            tiltResetTimer += 1
            if tiltResetTimer >= tiltResetTime {
                
                tiltResetAnimation = false
                tiltOffset = tiltResetEndOffset
                
            } else {
                let percent = CGFloat(tiltResetTimer) / CGFloat(tiltResetTime)
                tiltOffset.x = tiltResetStartOffset.x + (tiltResetEndOffset.x - tiltResetStartOffset.x) * percent
                tiltOffset.y = tiltResetStartOffset.y + (tiltResetEndOffset.y - tiltResetStartOffset.y) * percent
            }
            
            
            
        } else {
            let dir = ApplicationController.shared.gyroDir
            if fabs(dir.x) > 0.1 || fabs(dir.y) > 0.1 {
                tiltOffset.x = (tiltOffset.x + dir.x * 1.21) * 0.985
                tiltOffset.y = (tiltOffset.y + dir.y * 1.21) * 0.985
            }
        }
        
        if tiltOffset.x > tiltOffsetMax { tiltOffset.x = tiltOffsetMax }
        if tiltOffset.x < -tiltOffsetMax { tiltOffset.x = -tiltOffsetMax }
        if tiltOffset.y > tiltOffsetMax { tiltOffset.y = tiltOffsetMax }
        if tiltOffset.y < -tiltOffsetMax { tiltOffset.y = -tiltOffsetMax }
        
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: tiltOffset.x, y: tiltOffset.y)
        imageViewBackground.transform = t
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        let result = UIInterfaceOrientationMask.all
        return result
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
        guard let image = pickerImage , image.size.width > 32.0 && image.size.height > 32.0 else {
            self.dismiss(animated: true) { }
            return
        }
        importImage = image
        AppDelegate.root.dismiss(animated: true) { [weak weakSelf = self] in
            weakSelf?.performSegue(withIdentifier: "import_image", sender: nil)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        AppDelegate.root.dismiss(animated: true) { //[weak ws = self] in
            print("Finished Dismissing Image Picker")
        }
    }
    
    @IBAction func testPush(_ sender: UIButton) {
        
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
        ApplicationController.shared.preloadScene(withFile: loadPath!)
        
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    @IBAction func clickUpgrade(_ sender: AnyObject) {
        loadPath = "test_ipad_landscape_info.json"
        ApplicationController.shared.preloadScene(withFile: loadPath!)
        
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    @IBAction func clickImport(_ sender: HMButton) {
        importImage = UIImage(named: "test_card.jpg")
        self.performSegue(withIdentifier: "import_image", sender: nil)
    }
    
    @IBAction func clickContinueRecent(_ sender: HMButton) {
        loadPath = "recent_scene.json"
        ApplicationController.shared.preloadScene(withFile: loadPath!)
        
        performSegue(withIdentifier: "test_bounce", sender: nil)
    }
    
    
    //
    
    
    
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
