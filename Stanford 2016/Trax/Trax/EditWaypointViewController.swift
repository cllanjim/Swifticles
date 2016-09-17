//
//  EditWaypointViewController.swift
//  Trax
//
//  Created by Raptis, Nicholas on 9/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class EditWaypointViewController: UIViewController, UITextFieldDelegate {

    var waypointToEdit: EditableWaypoint? { didSet { updateUI() } }
    
    @IBOutlet weak var nameTextField: UITextField! { didSet { nameTextField.delegate = self } }
    @IBOutlet weak var infoTextField: UITextField! { didSet { infoTextField.delegate = self } }
    
    private func updateUI() {
        nameTextField?.text = waypointToEdit?.name
        infoTextField?.text = waypointToEdit?.info
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listenToTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopListeningToTextFields()
    }
    
    private var ntfObserver: NSObjectProtocol?
    private var itfObserver: NSObjectProtocol?
    
    private func listenToTextFields() {
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        center.addObserver(forName: .UITextFieldTextDidChange, object: nameTextField, queue: queue) {
            notification in
            print("Change text = \(self.nameTextField.text)")
            
            if let wayPoint = self.waypointToEdit {
                wayPoint.name = self.nameTextField.text
            }
        }
        
        center.addObserver(forName: .UITextFieldTextDidChange, object: infoTextField, queue: queue) {
            notification in
            print("Change text = \(self.infoTextField.text)")
            
            if let wayPoint = self.waypointToEdit {
                wayPoint.info = self.infoTextField.text
            }
        }
    }
    
    private func stopListeningToTextFields() {
        if let observer = ntfObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = itfObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true) {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
