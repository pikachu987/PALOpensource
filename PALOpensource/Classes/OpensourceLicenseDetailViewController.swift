//Copyright (c) 2021 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit
import SafariServices

open class OpensourceLicenseDetailViewController: UIViewController {
    private var _opensource: Opensource
    
    open var opensource: Opensource {
        return self._opensource
    }
    
    open var foregroundFont: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    open var foregroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: { (collection) -> UIColor in
                return collection.userInterfaceStyle == .light ? .black : .white
            })
        } else {
            return UIColor.black
        }
    }

    open var linkUnderlineColor: UIColor {
        return UIColor(red: 6/255, green: 69/255, blue: 173/255, alpha: 1)
    }
    
    open var linkForegroundColor: UIColor {
        return UIColor(red: 6/255, green: 69/255, blue: 173/255, alpha: 1)
    }

    public let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    public init(_ opensource: Opensource) {
        self._opensource = opensource
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.textView)
        let leadingConstraint = NSLayoutConstraint(item: self.view ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self.textView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.view ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self.textView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self.view ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self.textView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.view ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self.textView, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        self.textView.delegate = self
        self.textView.isEditable = false
        
        let attributedString = NSMutableAttributedString(string: self.opensource.license ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: self.foregroundColor,
            NSAttributedString.Key.font: self.foregroundFont
        ])
        do {
            let text = attributedString.string
            let mentionExpression = try NSRegularExpression(pattern: "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", options: .allowCommentsAndWhitespace)
            let matches = mentionExpression.matches(in: text, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, text.count))
            for match in matches {
                let range = match.range
                let rangeValue = text.index(text.startIndex, offsetBy: range.location)..<text.index(text.startIndex, offsetBy: range.location+range.length)
                let matchString =  String(text[rangeValue])
                
                attributedString.addAttributes([
                    NSAttributedString.Key.link: matchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "",
                    NSAttributedString.Key.underlineColor: self.linkUnderlineColor,
                    NSAttributedString.Key.foregroundColor: self.linkForegroundColor,
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                    ], range: range)
            }
        } catch { }
        
        self.textView.attributedText = attributedString
        self.textView.layoutIfNeeded()
        self.textView.setContentOffset(CGPoint(x: 0, y: -self.textView.contentInset.top), animated: false)
    }
}

// MARK: OpensourceLicenseDetailViewController: UITextViewDelegate
extension OpensourceLicenseDetailViewController: UITextViewDelegate{
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let viewController = SFSafariViewController(url: URL)
        self.present(viewController, animated: true, completion: nil)
        return false
    }
}
