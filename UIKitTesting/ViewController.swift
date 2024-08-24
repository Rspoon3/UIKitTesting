//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import MediaPlayer

// https://stackoverflow.com/questions/60178358/mpvolumeview-thumb-image-not-correctly-drawn-horizontally

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let volumeView = MPVolumeView() // Can change to VolumeView
        volumeView.tintColor = .white
        volumeView.subviews.first(where: { $0 is UIButton })?.removeFromSuperview()

        if let volumeSliderView = volumeView.subviews.first as? UISlider {
            volumeSliderView.minimumValueImage = UIImage(systemName: "speaker")
            volumeSliderView.maximumValueImage = UIImage(systemName: "speaker.wave.3")
        }
        
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(volumeView)
        
        NSLayoutConstraint.activate([
            volumeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            volumeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            volumeView.widthAnchor.constraint(equalToConstant: 300),
            volumeView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

class VolumeView: MPVolumeView {
    override func volumeSliderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds
    }
}
