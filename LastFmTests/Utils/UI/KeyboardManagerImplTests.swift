import UIKit

import UIKit

import XCTest
import RxSwift

final class KeyboardManagerImplTests: XCTestCase {

    func testShowKeyboard() {
        let keyboardManager = KeyboardManagerImpl()

        let view = UIView(frame: CGRect(x: 0 , y: 0, width: 414, height: 896))
        let scrollView = UIScrollView(frame: CGRect(x: 0 , y: 144, width: 414, height: 752))

        keyboardManager.updateTarget(view, scrollView: scrollView)

        var userInfo = [String: AnyObject]()
        userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] = NSNumber(integerLiteral: 7)
        userInfo[UIResponder.keyboardFrameEndUserInfoKey] = NSValue(cgRect: CGRect(x: 0.0, y: 595.0, width: 414.0, height: 301.0))

        let notification = Notification(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)

        let newInsets = UIEdgeInsets(top: 0, left: 0, bottom: 301.0, right: 0)
        XCTAssert(scrollView.contentInset == newInsets)
        XCTAssert(scrollView.scrollIndicatorInsets == newInsets)
    }

    func testHideKeyboard() {
        let keyboardManager = KeyboardManagerImpl()

        let scrollView = UIScrollView(frame: .zero)

        let originalInset = scrollView.contentInset
        let originalScrollIndicatorInsets = scrollView.scrollIndicatorInsets

        keyboardManager.updateTarget(UIView(frame: .zero), scrollView: scrollView)

        scrollView.contentInset = UIEdgeInsets(top: 100, left: 10, bottom: 10, right: 10)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 200, left: 10, bottom: 10, right: 10)

        var userInfo = [String: AnyObject]()
        userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] = NSNumber(integerLiteral: 7)

        let notification = Notification(name: UIResponder.keyboardWillHideNotification, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)

        XCTAssert(scrollView.contentInset == originalInset)
        XCTAssert(scrollView.scrollIndicatorInsets == originalScrollIndicatorInsets)
    }
}
