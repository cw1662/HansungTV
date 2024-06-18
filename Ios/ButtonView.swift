import Foundation
import UIKit

class ButtonView: UIView {
    let tvButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "re.png")?.scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30)) // Adjust the target size as needed
        button.setImage(image, for: .normal) // Set scaled image here
        button.configuration = UIButton.Configuration.bordered()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        self.addSubview(tvButton)
        
        tvButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage? {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledWidth = size.width * scaleFactor
        let scaledHeight = size.height * scaleFactor
        
        let scaledSize = CGSize(width: scaledWidth, height: scaledHeight)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }
}
