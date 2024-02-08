import UIKit

class AccountSummaryViewController: UIViewController{
    
    // Request Model
    var profile : Profile?
    var accounts : [Account] = []
    
    // ViewModels
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "Hamit", date: Date())
    
    var accountCellViewModel: [AccountSummaryCell.ViewModel] = []
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    let refreshController = UIRefreshControl()
    
    var profileManager : ProfileManagable = ProfileManager()
    var accountManager: AccountManagable = AccountManager()
    
    lazy var errorAlert : UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }()
    
    var isLoaded = false
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryViewController{

    func setup(){
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshController()
        setupSkeletons()
        fetchData()
    }
    
    private func setupTableView(){
        tableView.backgroundColor = primaryColor
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupTableHeaderView(){
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
    }
    
    private func setupNavigationBar(){
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    private func setupRefreshController(){
        refreshController.tintColor = appColor
        refreshController.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    private func setupSkeletons(){
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        
        configureTableCells(with: accounts)
    }
}

extension AccountSummaryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !accountCellViewModel.isEmpty else{
            return UITableViewCell()
        }
        let account = accountCellViewModel[indexPath.row]
        
        if isLoaded{
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
            cell.configure(with: account)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModel.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: Networking
extension AccountSummaryViewController{
    private func fetchData(){
        
        let group = DispatchGroup()
        
        // Testing - random number selection
        let userId = String(Int.random(in: 1..<4))
        
        fetchProfile(group: group, userId: userId)
        fetchAccount(group: group, userId: userId)
        
         group.notify(queue: .main){
            self.reloadView()
        }
    }
    
    private func fetchProfile(group: DispatchGroup, userId: String){
        group.enter()
        profileManager.fetchProfile(forUserId: userId) { result in
            switch result{
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
    }
    
    private func fetchAccount(group: DispatchGroup, userId: String){
        group.enter()
        accountManager.fetchAccounts(forUserId: userId) { result in
            switch result{
            case .success(let accounts):
                self.accounts = accounts
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
    }
    
    private func reloadView(){
        self.tableView.refreshControl?.endRefreshing()
        
        guard let profile = self.profile else {return}
        
        self.isLoaded = true
        self.configureTableHeaderView(with: profile)
        self.configureTableCells(with: self.accounts)
        self.tableView.reloadData()
    }
    
    private func configureTableHeaderView(with profile: Profile){
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "Hamit", date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func configureTableCells(with account: [Account]){
        accountCellViewModel = account.map{
            AccountSummaryCell.ViewModel(accountType: $0.type, accountName: $0.name, balance: $0.amount)
        }
    }
    
    private func displayError(_ error: NetworkError){
        let titleAndMessage = titleAndMessage(for: error)
        
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessage(for error: NetworkError) -> (String, String){
        let title: String
        let message: String
        
        switch error{
            case .serverError:
            title = "Server Error"
            message = "Ensure you are connected to the internet. Please try again."
        case .decodingError:
            title = "Decoding Error"
            message = "We could not process your request. Please try again."
        }
        
        return (title, message)
    }
    
    private func showErrorAlert(title: String, message: String){
        errorAlert.title = title
        errorAlert.message = message
        
        present(errorAlert, animated: true, completion: nil)
    }
}

// MARK: Actions
extension AccountSummaryViewController{
    @objc func logoutTapped(sender: UIButton){
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func refreshContent(){
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    private func reset(){
        profile = nil
        accounts = []
        isLoaded = false
    }
}

// MARK: Unit Testing
extension AccountSummaryViewController{
    func titleAndMessageForTesting(for error: NetworkError) -> (String, String){
        return titleAndMessage(for: error)
    }
    
    func forceFetchProfile(){
        fetchProfile(group: DispatchGroup(), userId: "1")
    }
}

