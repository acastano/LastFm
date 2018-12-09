import UIKit

final class KeyboardManagerImpl: KeyboardManager {
    private var view: UIView?
    private var scrollView: UIScrollView?
    private var scrollViewInsets: UIEdgeInsets?

    deinit {
        removeListeners()
    }

    func updateTarget(_ view: UIView?, scrollView: UIScrollView?) {
        removeListeners()
        self.view = view
        self.scrollView = scrollView
        self.scrollViewInsets = scrollView?.contentInset
        addListeners()
    }

    private func addListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeListeners() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as? [String: AnyObject]

        guard let animationCurve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]?.int32Value,
            let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey]?.cgRectValue,
            let view = view,
            let scrollView = scrollView,
            let scrollViewInsets = scrollViewInsets else { return }

        let convertedFrame = view.convert(keyboardFrame, from: nil)
        let options = UIView.AnimationOptions(rawValue: UInt(animationCurve))

        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0

        UIView.animate(withDuration: animationDuration, delay: 0, options: options, animations: {
            var insets = scrollViewInsets
            insets.bottom += convertedFrame.height
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
        }) { _ in
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo as? [String: AnyObject],
            let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]?.int32Value,
            let scrollView = scrollView,
            let scrollViewInsets = scrollViewInsets else { return }

        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(animationCurve))

        UIView.animate(withDuration: animationDuration, delay: 0, options: options, animations: {
            scrollView.contentInset = scrollViewInsets
            scrollView.scrollIndicatorInsets = scrollViewInsets
        }) { _ in
        }
    }
}
