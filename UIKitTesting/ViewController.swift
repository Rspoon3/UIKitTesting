//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
import Combine


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let test = TestVC()
//        test.modalPresentationStyle = .fullScreen
        present(test, animated: true)
    }
}

class TestVC: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let stack = UIStackView()
    private let textView = UITextView()
    private let padding: CGFloat = 20
    private var stackBottomConstraint:NSLayoutConstraint?
    private var charactersRemainingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotificationObservers()
        configureStackView()
        view.backgroundColor = .systemBackground
        title = "Test"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    private func updateConstraints(using info: [AnyHashable: Any]) {
        guard let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        
        let globalPoint = view.convert(view.frame.origin, to: nil).y
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let topOfKeyboard = UIScreen.main.bounds.height - globalPoint - keyboardHeight
        let bottomOfStack = stack.frame.maxY
        let offset = bottomOfStack - topOfKeyboard + (padding * 2)
        
   
        UIView.animate(withDuration: duration){ [weak self] in
            guard let self = self else { return }
            self.stackBottomConstraint?.constant = keyboardHeight == 0 ? -self.padding : -offset
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureNotificationObservers(){
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap(\.userInfo)
            .eraseToAnyPublisher()
            .sink() { [weak self] info in
                self?.updateConstraints(using: info)
            }.store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap(\.userInfo)
            .eraseToAnyPublisher()
            .sink() { [weak self] info in
                self?.updateConstraints(using: info)
            }.store(in: &cancellables)
    }
    
    private func configureStackView(){
        let placeholderLabel = UILabel()
        placeholderLabel.text = "This is the top text that doesn't need to be avoided."
        placeholderLabel.font = .preferredFont(forTextStyle: .caption1)

        textView.translatesAutoresizingMaskIntoConstraints = false
        
        charactersRemainingLabel.text = "This is the bottom text and the keyboard is in the way."
        charactersRemainingLabel.font = .preferredFont(forTextStyle: .caption1)
        
        stack.addArrangedSubview(placeholderLabel)
        stack.addArrangedSubview(textView)
        stack.addArrangedSubview(charactersRemainingLabel)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        stackBottomConstraint = stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        ])
        
        stackBottomConstraint?.isActive = true
    }
}
