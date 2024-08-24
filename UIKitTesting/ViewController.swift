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
            
            let size = CGSize(width: 300, height: 300)
            
            guard let image = await firstItem.getArtwork(for: size) else {
                print("Error 2")
                return
            }
            
            imageView.image = image
            print("Image size: ", image.size)
        }
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}
