//
//  UIViewController + Extension.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

enum AlertType: String, CaseIterable {
    case Ok
    case Cancel
}

extension UIViewController {
    
    @objc func tapGesture(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    //TODO: - Cordinate
    func push(_ destination: UIViewController) {
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sheet(_ vc: UIViewController) {
        let nv = UINavigationController(rootViewController: vc)
        self.present(nv, animated: true)
    }
    
    func errorPresent(_ type: NetworkError.CustomError) {
        let vc = ErrorViewController(type.errorDescription ?? "")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    func setRootView(_ rootVC: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        window.rootViewController = rootVC
    }
    
    func setNavigation(_ title: String = "",_ backTitle: String = "",_ color: UIColor = .point, apperanceColor: UIColor = .white) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        self.navigationItem.title = title
        let back = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        self.navigationItem.backBarButtonItem = back
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = apperanceColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowColor = nil
        
        navigationBar.tintColor = color
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func customAlert(_ title: String = "",_ message: String = "",_ action: [AlertType] = [.Ok],_ method: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for type in action {
            switch type {
            case .Ok:
                let action = UIAlertAction(title: type.rawValue, style: .default) { _ in
                    method()
                }
                alertVC.addAction(action)
            case .Cancel:
                let action = UIAlertAction(title: type.rawValue, style: .destructive )
                alertVC.addAction(action)
            }
        }
        
        self.present(alertVC, animated: true)
    }
    
}
