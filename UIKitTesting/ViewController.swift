//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    let player = MPMusicPlayerController.applicationMusicPlayer

    @MainActor
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: 300, height: 300)
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        Task {
            await MPMediaLibrary.requestAuthorization()
            
            let myPlaylistsQuery = MPMediaQuery.playlists()
            
            
            guard
                let playlist = myPlaylistsQuery.collections?.filter({ !$0.items.isEmpty }),
                let firstItem = playlist.first?.items.first
            else {
                print("Error")
                return
            }
            
            guard let image = firstItem.artwork?.image(at: size) else {
                print("Error 2")
                return
            }
            
            imageView.image = image
            print("Image size: ", image.size) // printing 1425
        }
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: size.width),
            imageView.heightAnchor.constraint(equalToConstant: size.height),
        ])
    }
}
