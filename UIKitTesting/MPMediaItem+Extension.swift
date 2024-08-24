//
//  MPMediaItem+Extension.swift
//  UIKitTesting
//
//  Created by Ricky on 8/24/24.
//

import Foundation
import MediaPlayer

extension MPMediaItem: Identifiable {
    func getArtwork(for size: CGSize) async -> UIImage? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async { [weak self] in
                guard
                    let self,
                    let artwork,
                    let uiImage = artwork.image(at: size)
                else {
                    continuation.resume(returning: nil)
                    return
                }
                                
                continuation.resume(returning: uiImage)
            }
        }
    }
}
