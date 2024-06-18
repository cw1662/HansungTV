import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white  // 배경색을 흰색으로 설정 (로고나 이미지로 대체 가능)
        
        // 로고나 이미지를 화면에 추가하려면 다음과 같이 설정할 수 있습니다.
        // let logoImageView = UIImageView(image: UIImage(named: "YourLogo"))
        // view.addSubview(logoImageView)
        // logoImageView.center = view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 5초 후에 메인 화면으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.navigateToMainViewController()
        }
    }
    
    private func navigateToMainViewController() {
        let mainViewController = ViewController()  // 메인 뷰 컨트롤러 인스턴스 생성
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = true  // 선택사항: 스플래시 화면에서 네비게이션 바 숨기기
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
}
