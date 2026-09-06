//
//  AppCoordinator.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.
//

import UIKit
import SilentMoonNetwork
import SilentMoonDomain

public final class AppCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    private let diContainer: AppDiContainer
    
    public init(window: UIWindow, diContainer: AppDiContainer) {
        self.window = window
        self.diContainer = diContainer
    }

    public func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showBootstrapLoading()
    }

    private func showBootstrapLoading() {
        let loadingViewModel = LoadingViewModel { [weak self] in
            guard let self, self.diContainer.tokenStore.isLoggedIn else {
                return .success(())
            }
            return await self.diContainer.repository.refreshToken().map { _ in () }
        }

        loadingViewModel.onError = { [weak self] _ in
            self?.diContainer.tokenStore.clear()
            self?.showAuthFlow()
            return true
        }

        let loadingController = LoadingViewController(viewModel: loadingViewModel)
        loadingController.onFinished = { [weak self] in
            guard let self else { return }
            if self.diContainer.tokenStore.isLoggedIn {
                self.showMainTabBarFlow()
            } else {
                self.showAuthFlow()
            }
        }
        navigationController.setViewControllers([loadingController], animated: false)
    }

    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            repository: diContainer.repository
        )
        authCoordinator.onFlowFinished = { [weak self] in
            self?.showMainTabBarFlow()
        }
        childCoordinators = [authCoordinator]
        authCoordinator.start()
    }

    private func showMainTabBarFlow() {
        childCoordinators.removeAll()

        let tabBarController = UITabBarController()
        let tabBarCoordinator = MainTabBarCoordinator(
            tabBarController: tabBarController,
            repository: diContainer.repository
        )
        tabBarCoordinator.onLogout = { [weak self] in
            self?.logout()
        }
        childCoordinators = [tabBarCoordinator]
        tabBarCoordinator.start()

        setRoot(tabBarController)
    }

    private func logout() {
        diContainer.tokenStore.clear()
        childCoordinators.removeAll()
        navigationController.setViewControllers([], animated: false)
        setRoot(navigationController)
        showAuthFlow()
    }

    private func setRoot(_ viewController: UIViewController) {
        window.rootViewController = viewController
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
