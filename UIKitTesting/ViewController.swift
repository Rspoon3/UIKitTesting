//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController3: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let anotherView = UIView()
        anotherView.backgroundColor = .systemRed
        anotherView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(anotherView)

        anotherView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        anotherView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        anotherView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        anotherView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        anotherView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {

            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
}


class ViewController2: UIViewController {
    
    let margin: CGFloat = 20
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)))
        return panGesture
    }()
    
    lazy var animator:UIDynamicAnimator = {
        UIDynamicAnimator(referenceView: view)
    }()
    
    var pipView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        view.backgroundColor = .red
        return view
    }()

    lazy var itemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior(items: [pipView])
        // Adjust these values to change the "stickiness" of the view
        itemBehavior.density = 0.01
        itemBehavior.resistance = 25
        itemBehavior.friction = 0
        itemBehavior.allowsRotation = false
        return itemBehavior
    }()
    
    lazy var attachment: UIAttachmentBehavior = {
        let attachment = UIAttachmentBehavior(item: pipView, attachedToAnchor: .zero)
        attachment.length = 0
        return attachment
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .green
        view.addSubview(pipView)
        
        let springField = UIFieldBehavior.springField()
        springField.position = view.center
        springField.region = UIRegion(size: view.bounds.size)
        
        animator.addBehavior(springField)
        springField.addItem(pipView)
        
        animator.addBehavior(itemBehavior)
        pipView.addGestureRecognizer(panGesture)
    }
    

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        itemBehavior.action
            let location = sender.location(in: view)
            let velocity = sender.velocity(in: view)
            switch sender.state
            {
            case .began:
                attachment.anchorPoint = location
                animator.addBehavior(attachment)
            case .changed:
                attachment.anchorPoint = location
            case .cancelled, .ended, .failed, .possible:
                itemBehavior.addLinearVelocity(velocity, for: pipView)
                animator.removeBehavior(attachment)
            }
        }
}


class ViewController: UIViewController {
    private var animator: UIDynamicAnimator!
    private var snapping: UISnapBehavior!
    let pipView = UIView(frame: CGRect(x: 0, y: 0, width: 343, height: 56))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        pipView.backgroundColor = .systemRed
        pipView.layer.cornerRadius = 12
        pipView.layer.masksToBounds = true
        
        view.addSubview(pipView)
        pipView.center = view.center
        
        animator = UIDynamicAnimator (referenceView: view)
        snapping = UISnapBehavior(item: pipView, snapTo: view.center)
        snapping.damping = 1
        
        animator.addBehavior(snapping)
        
        let panGesture = UIPanGestureRecognizer (target: self, action: #selector(pannedView))
        pipView.addGestureRecognizer(panGesture)
        pipView.isUserInteractionEnabled = true
    }
    
    var count: CGFloat = 0

    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    @objc func pannedView(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animator.removeBehavior(snapping)
        case .changed:
            count += 4
            let translation = recognizer.translation(in: view)
            let newCenter = CGPoint(
                x: pipView.center.x,//pipView.center.x + translation.x / count,
                y: pipView.center.y + translation.y / count
            )
            let distance = abs(CGPointDistance(from: view.center, to: newCenter))
            print(recognizer.location(in: view).y - view.center.y)
            let scale = 1 - distance * 0.008
            
            pipView.center = newCenter
            pipView.transform = .init(
                scaleX: scale,
                y: scale
            )
            
            recognizer.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed, .possible:
            count = 0
            animator.addBehavior(snapping)
                        
            UIView.animate(withDuration: 0.1) {
                self.pipView.transform = .init(scaleX: 1, y: 1)
            }
        @unknown default:
            count = 0
            pipView.transform = .init(scaleX: 1, y: 1)
            animator.addBehavior(snapping)
        }
    }
}
