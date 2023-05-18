//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

@MainActor
class ViewController: UIViewController {
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "0"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let task = Task {
            await start()
        }
        
        //        Task {
        //            try await Task.sleep(for: .seconds(1))
        //            task.cancel()
        //        }
    }
    
    private func start() async {
        for await value in CADisplayLinkCounter.count(
            from: 0,
            to: 100,
            duration: 3,
            method: .easeOutBounce
        ) {
            label.text = value.formatted(.number.precision(.fractionLength(0)))
            print(value)
        }
    }
}
