//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class ViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Books - Stack"
        view.backgroundColor = UIColor.white
        configureScrollView()
        configureStackView()
        loadData()
    }
    
    private func configureScrollView(){
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
    }
    
    private func configureStackView(){
        stackView = UIStackView(frame: scrollView.bounds)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        ])
    }
    
    private func loadData() {
        for (index, section) in Book.sections.enumerated() {
            var config = UIListContentConfiguration.plainHeader()
            config.text = section
            
            var cv = UIListContentView(configuration: config)
            stackView.addArrangedSubview(cv)
            
            for book in Book.booksFor(section: index) {
                config = UIListContentConfiguration.cell()
                config.image = book.authType == .single ? UIImage(systemName: "person.fill") : UIImage(systemName: "person.2.fill")
                config.text = book.title
                config.secondaryText = book.author
                
                cv = UIListContentView(configuration: config)
                stackView.addArrangedSubview(cv)
            }
        }
    }
}
