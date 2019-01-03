import XCTest
import RxSwift

final class AlbumRepositoryImplTests: XCTestCase {
    private let disposeBag = DisposeBag()

    func testSearchSuccess() {
        let repository = AlbumRepositoryImpl(dataTask: DataTaskSuccess(fileName: "search.json"))

        var success = false
        repository.search("query")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { albums in
                XCTAssert(albums.count == 50)
                success = true
            }).disposed(by: disposeBag)
        XCTAssertTrue(success)
    }

    func testSearchFailure() {
        let repository = AlbumRepositoryImpl(dataTask: DataTaskFailure())

        var success = false
        repository.search("query")
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { error in
                success = true
            }).disposed(by: disposeBag)
        XCTAssertTrue(success)
    }

    func testDetailSuccess() {
        let album = AlbumModel(id: "", artistText: "", albumText: "", image: nil, placeholderImage:"")

        let repository = AlbumRepositoryImpl(dataTask: DataTaskSuccess(fileName: "info.json"))

        var success = false
        repository.info(album)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { albumInfo in
                XCTAssert(albumInfo.album.tracks.track.count == 27)
                success = true
            }).disposed(by: disposeBag)
        XCTAssertTrue(success)
    }

    func testDetailFailure() {
        let album = AlbumModel(id: "", artistText: "", albumText: "", image: nil, placeholderImage:"")

        let repository = AlbumRepositoryImpl(dataTask: DataTaskFailure())

        var success = false
        repository.info(album)
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { error in
                success = true
            }).disposed(by: disposeBag)
        XCTAssertTrue(success)
    }
}
