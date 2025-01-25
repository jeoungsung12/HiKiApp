//
//  UIViewController + Extension.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit

enum AlertType: String, CaseIterable {
    case ok = "확인"
    case cancel = "실패"
}

extension UIViewController {
    
    func push(_ destination: UIViewController) {
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigation(_ title: String = "",_ backTitle: String = "",_ color: UIColor = .point) {
        self.navigationItem.title = title
        let back = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func tapGesture(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    func customAlert(_ title: String = "",_ message: String = "",_ action: [AlertType] = [.ok],_ method: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for type in action {
            switch type {
            case .ok:
                let action = UIAlertAction(title: type.rawValue, style: .default) { _ in
                    method()
                }
                alertVC.addAction(action)
            case .cancel:
                let action = UIAlertAction(title: type.rawValue, style: .destructive )
                alertVC.addAction(action)
            }
        }
        
        self.present(alertVC, animated: true)
    }
    
}
