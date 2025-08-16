//
//  MainTabBarController.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 14/08/2025.
//


import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBarAppearance()
        setupTabs()
        self.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let inset: CGFloat = 10
        var frame = tabBar.frame
        
        if frame.origin.x == 0 {
            frame.origin.x += inset
            frame.size.width -= inset * 2
            frame.origin.y -= inset
            frame.size.height += inset
            tabBar.frame = frame
        }
        
        tabBar.layer.cornerRadius = 18
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.12
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowPath = UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: 18).cgPath
    }
    
    private func makeSelectionIndicator(color: UIColor, size: CGSize, cornerRadius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            color.setFill()
            path.fill()
        }.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    }
    
    // MARK: - Set up Tab Bar Appearance
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        appearance.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.7)
        
        let normal = appearance.stackedLayoutAppearance.normal
        normal.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 11, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        let selected = appearance.stackedLayoutAppearance.selected
        selected.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold),
            .foregroundColor: UIColor.systemRed
        ]
        
        let indicatorSize = CGSize(width: 36, height: 3)
        appearance.selectionIndicatorTintColor = .systemRed
        appearance.selectionIndicatorImage = makeSelectionIndicator(
            color: .red,
            size: indicatorSize,
            cornerRadius: indicatorSize.height / 2
        )
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .secondaryLabel
        
        tabBar.isTranslucent = true
    }
    
    
    // MARK: - Set up Tabs
    private func setupTabs() {
        
        let home = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let downloads = DownloadsViewController(nibName: "DownloadsViewController", bundle: nil)
        
        let navHome = UINavigationController(rootViewController: home)
      
        let navDownloads = UINavigationController(rootViewController: downloads)
        
        navHome.tabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))
        
        
        navDownloads.tabBarItem = UITabBarItem(title: "Downloads",
                                               image: UIImage(systemName: "arrow.down.circle"),
                                               selectedImage: UIImage(systemName: "arrow.down.circle.fill"))
        
        
        
        
        viewControllers = [navHome, navDownloads]
    }
    private func animateContentFade() {
        guard let v = selectedViewController?.view else { return }
        v.alpha = 0.0
        UIView.animate(withDuration: 0.22, delay: 0, options: .curveEaseOut) {
            v.alpha = 1.0
        }
    }
    
    private func safeTabBarButton(at index: Int) -> UIView? {
        let buttons = tabBar.subviews
            .filter { String(describing: type(of: $0)) == "UITabBarButton" }
            .sorted { $0.frame.minX < $1.frame.minX }
        return buttons.indices.contains(index) ? buttons[index] : nil
    }
    private func animateBounce(on tabBarButton: UIView) {
        let anim = CASpringAnimation(keyPath: "transform.scale")
        anim.fromValue = 0.85
        anim.toValue = 1.0
        anim.stiffness = 220
        anim.mass = 1
        anim.damping = 14
        anim.initialVelocity = 0.5
        anim.duration = anim.settlingDuration
        tabBarButton.layer.add(anim, forKey: "bounce")
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

// MARK: - UI TabBar Controller Delegate
extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if let vcs = tabBarController.viewControllers,
           let idx = vcs.firstIndex(of: viewController),
           let btn = safeTabBarButton(at: idx) {
            animateBounce(on: btn)
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        animateContentFade()
    }
}
