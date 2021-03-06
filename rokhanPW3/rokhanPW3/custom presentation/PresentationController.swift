import UIKit

/// Класс для окна настройки будильника.
/// Помогает производить кастомный презент экрана.
class PresentationController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
        var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    @objc func dismiss(){
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
        override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.blurEffectView.isUserInteractionEnabled = true
            self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        }
        override var frameOfPresentedViewInContainerView: CGRect{
            return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - 500), size: CGSize(width: self.containerView!.frame.width, height: 500))
        }
        override func dismissalTransitionWillBegin() {
            self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (UIViewControllerTransitionCoordinatorContext) in
                self?.blurEffectView.alpha = 0
            }, completion: { [weak self] (UIViewControllerTransitionCoordinatorContext) in
                self?.blurEffectView.removeFromSuperview()
            })
        }
        override func presentationTransitionWillBegin() {
            self.blurEffectView.alpha = 0
            self.containerView?.addSubview(blurEffectView)
            self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (UIViewControllerTransitionCoordinatorContext) in
                self?.blurEffectView.alpha = 1
            }, completion: { (UIViewControllerTransitionCoordinatorContext) in

            })
        }
        override func containerViewWillLayoutSubviews() {
            super.containerViewWillLayoutSubviews()
            presentedView!.layer.masksToBounds = true
            presentedView!.layer.cornerRadius = 10
        }
        override func containerViewDidLayoutSubviews() {
            super.containerViewDidLayoutSubviews()
            self.presentedView?.frame = frameOfPresentedViewInContainerView
            blurEffectView.frame = containerView!.bounds
        }
}
