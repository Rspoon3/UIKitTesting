//
//  CustomCarouselLayoutVC.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//
import UIKit
import LoremSwiftum


class CustomCarouselLayoutVC: CarouselVC {
    //MARK: - Layout
    
    override func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: CarouselLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .always
        
        commonCollectionViewSetup()
    }
}
