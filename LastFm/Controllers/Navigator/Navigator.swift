import UIKit

final class Navigator {
    private let repository: AlbumRepository
    private let navigationController: UINavigationController?

    init(navigationController: UINavigationController?, repository: AlbumRepository) {
        self.repository = repository
        self.navigationController = navigationController
    }

    func toAlbumDetails(_ album: AlbumViewModel) {
        guard  let navigationController = navigationController,
            let controller = AlbumInfoViewController.controller(repository: repository, album: album) else { return }
        navigationController.pushViewController(controller, animated: true)
    }
}
