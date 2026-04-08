import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IBOutlet
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    // MARK: - Private properties
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol?
    private var presenter: MovieQuizPresenter?
    
    // MARK: - IBAction
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let presenter, !presenter.isAnswerProcessing else { return }
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let presenter, !presenter.isAnswerProcessing else { return }
        presenter.yesButtonClicked()
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = UIImage(data: step.imageData) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    func show(quiz result: QuizResultsViewModel) {
        guard let presenter = presenter else { return }
        let message = presenter.makeResultMessage()
        
        let alert = AlertModel(title: result.title,
                               message: message,
                               buttonText: result.buttonText) { [weak self] in
            guard let self = self, let presenter = self.presenter else { return }
            presenter.isAnswerProcessing = false
            presenter.restartGame()        }
        alertPresenter.show(in: self, model: alert)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self, let presenter = self.presenter else { return }
            presenter.restartWithMockData()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        statisticService = StatisticService()
        
        activityIndicator.hidesWhenStopped = true
    }
}
