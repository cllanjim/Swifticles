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
    
    var importImage: UIImage?
    
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
    
    /*
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
     picker.mediaTypes = @[(NSString *)kUTTypeImage];
     picker.allowsEditing = NO;
     picker.delegate = self;
     picker.modalPresentationStyle = UIModalPresentationPopover;
     
     UIPopoverPresentationController *popPC = picker.popoverPresentationController;
     popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
     popPC.barButtonItem = button;
     */
    
    override func viewDidLoad() {
        
        //self.performSegueWithIdentifier("bounce", sender: nil)
        
        self.clickImport(RRButton())
    }
    
    @IBAction func testPush(sender: UIButton) {
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("viewWillTransitionToSize")
        print("coord \(coordinator)")
        print("size \(size.width)x\(size.height)")
        print("~~~~~~~")
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
    }
    
    @IBAction func clickCreate(sender: UIButton) {
        
        showImagePicker(sender)
        
        //self.performSegueWithIdentifier("bounce", sender: nil)
        
        
    }
    
    @IBAction func clickLoad(sender: AnyObject) {
        
        performSegueWithIdentifier("bounce", sender: nil)
        
    }
    
    @IBAction func clickUpgrade(sender: AnyObject) {
        
        performSegueWithIdentifier("bounce", sender: nil)
    }
    
    @IBAction func clickImport(sender: RRButton) {
        importImage = UIImage(named: "test_image.jpg")
        self.performSegueWithIdentifier("import_image", sender: nil)
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
