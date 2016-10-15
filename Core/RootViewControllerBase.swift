//
//  RootViewControllerBase.swift
//  DemoFlow
//
//  Created by Raptis, Nicholas on 10/13/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class RootViewControllerBase: UIViewController {
    
    var rootContainerView: UIView!
    
    private var _currentStoryboard: UIStoryboard?
    override var storyboard: UIStoryboard {
        if _currentStoryboard == nil {
            _currentStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        }
        return _currentStoryboard!
    }
    
    
    var currentViewController: UIViewController? {
        return _currentViewController
    }
    private var _currentViewController: UIViewController?
    private var _previousViewController: UIViewController?
    
    private var _popoverContainer: UIView?
    private var _popovers = [(container: UIView, vc: UIViewController)]()
    
    private var _frameInsets: CGFloat = 0.0
    
    private var _updateTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        rootContainerView = UIView(frame: CGRect.zero)
        rootContainerView.backgroundColor = UIColor.white
        view.addSubview(rootContainerView)
        constrain(view: rootContainerView, inParentView: view)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let vc = currentViewController {
            vc.viewWillTransition(to: size, with: coordinator)
        }
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        
    }
    
    func setStoryboard(_ storyboard: UIStoryboard?, animated: Bool) {
        _currentStoryboard = storyboard
        if let sb = _currentStoryboard {
            setViewController(sb.instantiateInitialViewController(), animated: animated)
        }
    }
    
    private func constrain(view: UIView, inParentView parentView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraintLeft = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1.0, constant: _frameInsets)
        let constraintRight = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1.0, constant: -_frameInsets)
        let constraintTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: _frameInsets)
        let constraintBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: -_frameInsets)
        parentView.addConstraints([constraintLeft, constraintRight, constraintTop, constraintBottom])
        parentView.setNeedsLayout()
        parentView.setNeedsDisplay()
    }
    
    func setViewController(_ viewController: UIViewController?, animated: Bool) {
        guard _currentViewController != viewController else { return }
        if let vc = viewController {
            _previousViewController = _currentViewController
            _currentViewController = viewController
            
            rootContainerView.addSubview(vc.view)
            constrain(view: vc.view, inParentView: rootContainerView)
            rootContainerView.layoutIfNeeded()
            
            if animated {
                _previousViewController?.view.isUserInteractionEnabled = false
                vc.view.layer.transform = CATransform3DMakeTranslation(0.0, rootContainerView.bounds.height, 0.0)
                UIView.animate(withDuration: 0.4, animations: { [weak weakSelf = self] in
                    
                    if let checkSelf = weakSelf {
                        checkSelf._previousViewController?.view.layer.transform = CATransform3DMakeTranslation(0.0, -checkSelf.rootContainerView.bounds.height, 0.0)
                        checkSelf._currentViewController?.view.layer.transform = CATransform3DIdentity
                    }
                    
                    }, completion: { [weak weakSelf = self] (finished:Bool) in
                        weakSelf?._previousViewController?.view.removeFromSuperview()
                        weakSelf?._previousViewController = nil
                    })
                
            } else {
                if _previousViewController != nil {
                    _previousViewController!.view.removeFromSuperview()
                }
            }
        }
    }
    
    func showPopover(withVC viewController: UIViewController?) {
        if let vc = viewController {
            if _popoverContainer == nil {
                _popoverContainer = UIView(frame: CGRect.zero)
                view.addSubview(_popoverContainer!)
                constrain(view: _popoverContainer!, inParentView: view)
                view.layoutIfNeeded()
            }
            let container = UIView(frame: CGRect.zero)
            _popoverContainer!.addSubview(container)
            constrain(view: container, inParentView: _popoverContainer!)
            container.addSubview(vc.view)
            constrain(view: vc.view, inParentView: container)
            _popoverContainer!.layoutIfNeeded()
            _popovers.append((container, vc))
        }
    }
    
    func killPopover(viewController: UIViewController) {
        var findIndex:Int?
        for i in 0..<_popovers.count {
            let popover = _popovers[i]
            if popover.vc === viewController {
                findIndex = i
            }
        }
        if let index = findIndex {
            let popover = _popovers[index]
            _popovers.remove(at: index)
            
            popover.vc.view.removeFromSuperview()
            popover.container.removeFromSuperview()
            
            if _popovers.count == 0 && _popoverContainer != nil {
                _popoverContainer!.removeFromSuperview()
                _popoverContainer = nil
            }
        }
    }
    
    func killPopover() {
        if _popovers.count > 0 {
            killPopover(viewController: _popovers.last!.vc)
        }
    }
    
    func didBecomeActive() {
        if _updateTimer == nil {
            _updateTimer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            RunLoop.main.add(_updateTimer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    func didBecomeInactive() {
        if _updateTimer != nil {
            _updateTimer!.invalidate()
            _updateTimer = nil
        }
    }
    
}






