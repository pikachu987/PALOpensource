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

public protocol OpensourceLicenseDelegate: class {
    func opensourceLicense(_ viewController: OpensourceLicenseViewController)
    func opensourceLicenseTitle(_ viewController: OpensourceLicenseViewController)
    func opensourceLicenseTableView(_ viewController: OpensourceLicenseViewController, tableView: UITableView, cellForRowAt: UITableViewCell)
    func opensourceLicenseDetail(_ viewController: OpensourceLicenseDetailViewController)
    func opensourceLicenseDetailTitle(_ viewController: OpensourceLicenseDetailViewController, opensource: Opensource)
}

public extension OpensourceLicenseDelegate {
    func opensourceLicense(_ viewController: OpensourceLicenseViewController) {
        
    }

    func opensourceLicenseTitle(_ viewController: OpensourceLicenseViewController) {
        viewController.title = "Opensource"
    }
    
    func opensourceLicenseTableView(_ viewController: OpensourceLicenseViewController, tableView: UITableView, cellForRowAt: UITableViewCell) {
        
    }
    
    func opensourceLicenseDetail(_ viewController: OpensourceLicenseDetailViewController) {
        
    }

    func opensourceLicenseDetailTitle(_ viewController: OpensourceLicenseDetailViewController, opensource: Opensource) {
        viewController.title = opensource.name
    }
}

open class OpensourceLicenseViewController: UIViewController {
    private(set) public var opensources = [Opensource]()
    
    public var delegate: OpensourceLicenseDelegate?
    
    public let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    public init(plistPath: String?) {
        super.init(nibName: nil, bundle: nil)
        
        guard let plistPath = plistPath,
            let array = NSArray(contentsOfFile: plistPath) else { return }
        
        let opensources = array.compactMap { element -> Opensource? in
            let value = element as? [String: String]
            return Opensource(name: value?["name"], license: value?["license"], urlPath: value?["urlPath"])
        }
        
        self.opensources = opensources
    }

    public var backBarButtonItem: UIBarButtonItem?
    
    public init(opensources: [Opensource]) {
        super.init(nibName: nil, bundle: nil)
        
        self.opensources = opensources
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
        let leadingConstraint = NSLayoutConstraint(item: self.view ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self.tableView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.view ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self.tableView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self.view ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self.tableView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.view ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self.tableView, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if self.backBarButtonItem == nil && self.navigationController?.viewControllers.first == self {
            self.backBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.backTap(_:)))
        }
        self.delegate?.opensourceLicenseTitle(self)
        if self.delegate == nil {
            self.title = "Opensource"
        }
        self.delegate?.opensourceLicense(self)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.leftBarButtonItem = self.backBarButtonItem
    }

    @objc open func backTap(_ sender: UIBarButtonItem) {
        if self.navigationController?.viewControllers.first == self {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    open func showDetailViewController(_ opensource: Opensource) {
        let viewController = OpensourceLicenseDetailViewController(opensource)
        self.delegate?.opensourceLicenseDetailTitle(viewController, opensource: opensource)
        if self.delegate == nil {
            viewController.title = opensource.name
        }
        self.delegate?.opensourceLicenseDetail(viewController)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: OpensourceLicenseViewController: UITableViewDelegate
extension OpensourceLicenseViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let opensource = self.opensources[indexPath.row]
        if let urlPath = opensource.urlPath, urlPath != "", let url = URL(string: urlPath) {
            let viewController = SFSafariViewController(url: url)
            self.present(viewController, animated: true, completion: nil)
        } else {
            self.showDetailViewController(opensource)
        }
    }
}

// MARK: OpensourceLicenseViewController: UITableViewDataSource
extension OpensourceLicenseViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.opensources.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let item = self.opensources[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.name
        self.delegate?.opensourceLicenseTableView(self, tableView: tableView, cellForRowAt: cell)
        return cell
    }
}
