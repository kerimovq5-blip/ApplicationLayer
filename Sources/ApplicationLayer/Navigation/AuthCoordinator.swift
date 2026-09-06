import UIKit
import SilentMoonDomain
import SilentMoonNetwork
import PresentationLayer

@MainActor
final class AuthCoordinator: Coordinator {

    var navigationController: UINavigationController
    var onFlowFinished: (() -> Void)?

    let repository: SilentMoonRepository

    init(
        navigationController: UINavigationController,
        repository: SilentMoonRepository
    ) {
        self.navigationController = navigationController
        self.repository = repository
    }
}

extension AuthCoordinator: StartNavigation {
    func start() {
        let viewModel = StartViewModel()
        viewModel.navigation = self
        let controller = StartViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }

    func showSignUp() {
        let viewModel = SignUpViewModel(usecases: AuthUseCasesImpl(repository: repository))
        viewModel.navigation = self
        viewModel.onRegisterSucceeded = { [weak self] email, name in
            self?.showOtpVerification(email: email, name: name)
        }
        let controller = SignUpViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }

    func showLogIn() {
        showLogin()
    }
}

extension AuthCoordinator: LoginNavigation {
    func finishAuth() {
        onFlowFinished?()
    }
}

extension AuthCoordinator: SingUpNavigation {
    func showLogin() {
        let viewModel = LoginViewModel(usecases: LogInUseCaseImpl(repository: repository))
        viewModel.navigation = self
        viewModel.onEmailNotVerified = { [weak self] email in
            self?.showOtpVerification(email: email)
        }
        let controller = LogInViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }

    func getStarted(name: String) {
        let viewModel = GetStartedViewModel()
        viewModel.navigation = self
        let controller = GetStartedController(viewModel: viewModel)
        controller.userName = name
        navigationController.pushViewController(controller, animated: true)
    }
}

extension AuthCoordinator: OtpNavigation {
    func showOtpVerification(email: String) {
        showOtpVerification(email: email, name: "")
    }

    func showOtpVerification(email: String, name: String = "") {
        let viewModel = OtpViewModel(usecases: AuthUseCasesImpl(repository: repository))
        viewModel.navigation = self
        let controller = OtpViewController(viewModel: viewModel)
        controller.email = email
        controller.userName = name
        navigationController.pushViewController(controller, animated: true)
    }
}

extension AuthCoordinator: GetStartedNavigation {
    func showChooseTopic() {
        showTopics()
    }
}

extension AuthCoordinator: ChooseTopicNavigation {
    
}

extension AuthCoordinator: ContentNavigating {

    func showTopics() {
        let viewModel = ChooseTopicViewModel(
            usecases: TopicsUseCasesImpl(repository: repository)
        )
        viewModel.navigation = self
        let controller = ChooseTopicViewController(viewModel: viewModel)
        
        navigationController.pushViewController(
            controller,
            animated: true
        )
    }

    func showReminder() {
        let stateModel = ReminderViewModels(
            usecases: ReminderUseCasesImpl(repository: repository)
        )
        let controller = ReminderViewController(stateModel: stateModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showMorning() {
        let controller = CoursesDetailViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func backToMain() {
        navigationController.popToRootViewController(animated: true)
    }

    func showMusicPage(item: String) {
        let controller = MusicPageController()
        controller.titleLabel = item
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showMusicPage2(item: String) {
        let controller = MusicSleepPageController()
        controller.titleLabel = item
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showMusicList() {
        let controller = MusicListViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showSearchPage() {
        let viewModel = SearchViewModel(usecases: SearchUseCaseImpl(repository: repository))
        let controller = SearchPageController(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func playOptionPage() {
        let controller = PlayOptionViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func dismissMusicPage() {
        navigationController.popViewController(animated: true)
    }

    func showSleepyStory() {
        let controller = SleepyStoryController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
