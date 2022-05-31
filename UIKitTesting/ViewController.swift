//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit



extension UIScrollView {
    fileprivate var isInteracting: Bool {
        isDragging || isDecelerating
    }
}


final class ContentOffsetSynchronizer : ObservableObject {
    private var observations: [NSKeyValueObservation] = []
    private let registrations = NSHashTable<UIScrollView>.weakObjects()

    private var contentOffset: CGPoint = .zero {
        didSet {
            // Sync all scrollviews with to the new content offset
            for scrollView in registrations.allObjects where scrollView.isInteracting == false {
                scrollView.contentOffset.x = contentOffset.x
            }
        }
    }

    func register(_ scrollView: UIScrollView) {
        scrollView.clipsToBounds = false

        guard registrations.contains(scrollView) == false else {
            return
        }

        registrations.add(scrollView)

        // When a user is interacting with the scrollView, we store its contentOffset
        observations.append(
            scrollView.observe(\.contentOffset, options: [.initial, .new]) { [weak self] scrollView, change in
                guard let newValue = change.newValue, scrollView.isInteracting else {
                    return
                }
                self?.contentOffset = newValue
            }
        )
        
        // If a contentSize changes, we need to re-sync it with the current contentOffset
        observations.append(
            scrollView.observe(\.contentSize, options: [.initial, .new]) { [weak self] scrollView, change in
                guard let contentOffset = self?.contentOffset else {
                    return
                }
                scrollView.contentOffset.x = contentOffset.x
            }
        )
    }
    
    deinit {
        observations.forEach { $0.invalidate() }
    }
}


class ViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var collectionView: UICollectionView! = nil
    let contentOffsetSynchronizer = ContentOffsetSynchronizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Orthogonal Sections"
        configureHierarchy()
        configureDataSource()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let padding: CGFloat = 2
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                  heightDimension: .fractionalHeight(1))
            let leadingItem = NSCollectionLayoutItem(layoutSize: itemSize)
            
            leadingItem.contentInsets = .init(top: 0, leading: padding / 2, bottom: 0, trailing: padding / 2)
            
            let minWidth: Double = 200
            var desiredItems: Double = 4
            let frameWidth = self.view.frame.width
            
            
            while frameWidth / desiredItems < minWidth {
                desiredItems -= 1
            }
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/desiredItems),
                                                   heightDimension: .fractionalHeight(0.25))
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                    subitem: leadingItem,
                                                                    count: 1)

            containerGroup.contentInsets = .init(top: sectionIndex == 0 ? padding : 0, leading:0, bottom: padding, trailing: 0)
            
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .groupPaging
                        
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: ViewController.sectionBackgroundDecorationElementKind)
            section.decorationItems = [sectionBackgroundDecoration]
            
        
            return section
            
        }
        
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: ViewController.sectionBackgroundDecorationElementKind)
        
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        
        DispatchQueue.main.async{
            for subView in self.collectionView.subviews {
                if let scrollview = subView as? UIScrollView {
                    self.contentOffsetSynchronizer.register(scrollview)
                    print("HERE")
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for subView in self.collectionView.subviews {
            if let scrollview = subView as? UIScrollView {
                self.contentOffsetSynchronizer.register(scrollview)
                print("HERE")
            }
        }
    }
    
    var dictText: [IndexPath: String] = [:]
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TableCell, Int> { (cell, indexPath, identifier) in
            let text = "\(indexPath.section), \(indexPath.item)"

            cell.configure(headerText: indexPath.section == 0 ? text : nil, text: self.dictText[indexPath]) { text in
                self.dictText[indexPath] = text
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 6
        for section in 0..<13 {
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


class TableCell: UICollectionViewCell, UITextViewDelegate {
    private let textLabel = UILabel()
    private let textField = UITextField()
    private let textView = UITextView()
    private let divider = UIView()
    private var topConstraint: NSLayoutConstraint!
    private var textViewTextDidChange: ((String)->Void)?
    private let placeholder = "Testing"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(headerText: String?, text: String?, textViewTextDidChange: @escaping (String)->Void) {
        self.textViewTextDidChange = textViewTextDidChange
        
        topConstraint.isActive = false

        if let text = headerText {
            textLabel.text = text
            topConstraint = textView.topAnchor.constraint(equalTo: divider.bottomAnchor)
        } else {
            topConstraint = textView.topAnchor.constraint(equalTo: contentView.topAnchor)
            textLabel.text = nil
        }
        
        topConstraint.isActive = true
        
        if let text = text {
            textView.text = text
            textField.placeholder = nil
        } else {
            textView.text = nil
            textField.placeholder = placeholder
        }
    }
    
    private func addViews() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.backgroundColor = .systemMint
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
        textField.isUserInteractionEnabled = false
        
        contentView.addSubview(textLabel)
        contentView.addSubview(divider)
        contentView.addSubview(textView)
        contentView.addSubview(textField)
        
        topConstraint = textView.topAnchor.constraint(equalTo: divider.bottomAnchor)

        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            divider.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),

            topConstraint,
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: textView.topAnchor, constant: 7),
            textField.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 6),
            textField.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
        ])
    }
    
    
    //MARK: - TextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        textField.placeholder = text.isEmpty ? placeholder : nil
        
        textViewTextDidChange?(text)
    }
}


class SectionBackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}
