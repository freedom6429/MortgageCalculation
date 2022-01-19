//
//  MortgageTableViewController.swift
//  MortgageCalculation
//
//  Created by Wen Luo on 2022/1/14.
//

import UIKit

class MortgageTableViewController: UITableViewController {
    
    var mortgageAmount = Double()
    var totalInterest = Double()
    var monthlyRepayment = Double()

    @IBOutlet weak var housePriceTextField: UITextField!
    
    @IBOutlet weak var downPaymentRateTextField: UITextField!
    
    @IBOutlet weak var periodTextField: UITextField!
    
    @IBOutlet weak var gracePeriodTextField: UITextField!
    
    @IBOutlet weak var interestRateTextField: UITextField!
    
    @IBOutlet weak var mortgageAmountLabel: UILabel!
    
    @IBOutlet weak var interestAmountLabel: UILabel!
    
    @IBOutlet weak var monthleRepaymentLabel: UILabel!
    
    @IBOutlet weak var housePriceNoTextLabel: UILabel!
    
    @IBOutlet weak var downRateNoTextLabel: UILabel!
    
    @IBOutlet weak var periodNoTextLabel: UILabel!
    
    @IBOutlet weak var interestRateNoTextLabel: UILabel!
    
    @IBOutlet weak var mortgageAmountTitleLabel: UILabel!
    
    @IBOutlet weak var interestTitleLabel: UILabel!
    
    @IBOutlet weak var monthlyRepaymentTitleLabel: UILabel!
    
    @IBOutlet weak var mortgagmeAmountColorImageView: UIImageView!
    
    @IBOutlet weak var interestColorImageView: UIImageView!
    
    @IBOutlet weak var resultContentView: UIView!
    
    @IBOutlet weak var calcButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    func setGradientBackground() {
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            CGColor(srgbRed: 132/255, green: 250/255, blue: 176/255, alpha: 1),
            CGColor(srgbRed: 143/255, green: 211/255, blue: 244/255, alpha: 1)
        ]
        gradientLayer.frame = tableView.frame
        backgroundView.layer.addSublayer(gradientLayer)
        tableView.backgroundView = backgroundView
    }
    
    func formatizeNumber(_ num: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = .current
        let formattedNum = formatter.string(from: NSNumber(value: num))

        return formattedNum!
    }
    
    func showResultTitle() {
        mortgageAmountTitleLabel.isHidden = false
        interestTitleLabel.isHidden = false
        monthlyRepaymentTitleLabel.isHidden = false
        mortgagmeAmountColorImageView.isHidden = false
        interestColorImageView.isHidden = false
    }
    
    func lockForm() {
        housePriceTextField.isEnabled = false
        downPaymentRateTextField.isEnabled = false
        periodTextField.isEnabled = false
        gracePeriodTextField.isEnabled = false
        interestRateTextField.isEnabled = false
    }
    
    func unlockAndRestForm() {
        housePriceTextField.isEnabled = true
        downPaymentRateTextField.isEnabled = true
        periodTextField.isEnabled = true
        gracePeriodTextField.isEnabled = true
        interestRateTextField.isEnabled = true
        housePriceTextField.text = ""
        downPaymentRateTextField.text = ""
        periodTextField.text = ""
        gracePeriodTextField.text = ""
        interestRateTextField.text = ""
    }
    
    func drawDonut(principalRatio: Double, interestRatio: Double) {
        //如果已經不是第一次算result的sublayer的甜甜圈會有兩層layer
        //畫之前要清掉前面畫的甜甜圈所以要彈出兩層sublayer
        if resultContentView.layer.sublayers!.count == 12 {
            let _ = resultContentView.layer.sublayers?.popLast()
            let _ = resultContentView.layer.sublayers?.popLast()
        }
        //基本數值先設定
        let aDegree = CGFloat.pi / 180
        let lineWidth: CGFloat = 40
        let radius: CGFloat = 80
        var startDegree: CGFloat = 270
        let center = CGPoint(x: lineWidth + radius, y: lineWidth + radius)
        let principalEndDegree = startDegree + 360 * principalRatio
        let principalPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startDegree * aDegree, endAngle: principalEndDegree * aDegree, clockwise: true)
        let principalLayer = CAShapeLayer()
        principalLayer.path = principalPath.cgPath
        let principalColor = UIColor(red: 0, green: 11/255, blue: 73/255, alpha: 1)
        mortgagmeAmountColorImageView.tintColor = principalColor
        principalLayer.strokeColor = principalColor.cgColor
        principalLayer.lineWidth = lineWidth
        principalLayer.fillColor = UIColor.clear.cgColor
        resultContentView.layer.addSublayer(principalLayer)
        //接著畫利息佔比
        startDegree = principalEndDegree
        let interestEndDegree = startDegree + 360 * interestRatio
        let interestPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startDegree * aDegree, endAngle: interestEndDegree * aDegree, clockwise: true)
        let interestLayer = CAShapeLayer()
        interestLayer.path = interestPath.cgPath
        let interestColor = UIColor(red: 252/255, green: 153/255, blue: 24/255, alpha: 1)
        interestColorImageView.tintColor = interestColor
        interestLayer.strokeColor = interestColor.cgColor
        interestLayer.lineWidth = lineWidth
        interestLayer.fillColor = UIColor.clear.cgColor
        resultContentView.layer.addSublayer(interestLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    

    @IBAction func calcMortgageButton(_ sender: UIButton) {
        //按下試算按鈕後就結束編輯收回鍵盤
        view.endEditing(true)
        //檢查必填的欄位有沒有填寫，沒有填寫就要顯示必填label
        if housePriceTextField.text == "" {
            housePriceNoTextLabel.isHidden = false
        }
        if downPaymentRateTextField.text == "" {
            downRateNoTextLabel.isHidden = false
        }
        if periodTextField.text == "" {
            periodNoTextLabel.isHidden = false
        }
        //檢查到最後一個年利率欄位，如果沒有填寫就return結束action不繼續計算
        if interestRateTextField.text == "" {
            interestRateNoTextLabel.isHidden = false
            return
        }
        //如果可以繼續下去表示每個必填欄位都有填寫，先顯示結果的文字標籤和圖例
        showResultTitle()
        //轉換TextField的字串為Double，方便之後計算
        let housePrice = Double(housePriceTextField.text!)!
        let downRate = Double(downPaymentRateTextField.text!)!
        let period = Double(periodTextField.text!)!
        let gracePeriod = Double(gracePeriodTextField.text!) ?? 0.0
        let yearRate = Double(interestRateTextField.text!)! / 100
        //開始計算
        let monthRate = yearRate / 12    //從年利率得出月利率
        let monthlyPeriod = Int(period  * 12)   //從年利率得出月利率
        
        mortgageAmount = (housePrice * 10000) * (1 - (downRate / 100)) //從房價和首付比例算出貸款總額
        mortgageAmountLabel.text =  formatizeNumber(mortgageAmount.rounded() / 10000) + "萬"  //結果label顯示
        
        //開始計算每月平均攤還金額、利息和本金
        var principalLeft = mortgageAmount    //初始化剩餘本金為貸款總額
        if gracePeriod > 0 {
            //計算寬限期每月的應付利息
            let monthlyGraceInterest = principalLeft * monthRate
            totalInterest += (gracePeriod * 12) * monthlyGraceInterest
            //寬限期後還款期限還剩多少月
            let monthPeriodLeft = Int(Double(monthlyPeriod) - gracePeriod * 12)
            //計算寬限期後每月平均攤還率
            let avgRepayRate = ((pow( 1 + monthRate, Double(monthPeriodLeft))) * monthRate) / ((pow(1 + monthRate,  Double(monthPeriodLeft)) - 1))
            //計算寬限期後每月平均還款金額
            monthlyRepayment = mortgageAmount * avgRepayRate
            for _ in 1...monthPeriodLeft {
                let monthlyInterest = principalLeft * monthRate
                totalInterest += monthlyInterest
                principalLeft = principalLeft - (monthlyRepayment - monthlyInterest)
            }
            drawDonut(principalRatio: mortgageAmount / (mortgageAmount + totalInterest), interestRatio: totalInterest / (mortgageAmount + totalInterest))
        } else {
            //計算每月平均攤還率
            let avgRepayRate = ((pow( 1 + monthRate, period * 12)) * monthRate) / ((pow(1 + monthRate, period * 12) - 1))
            //計算每月平均還款金額
            monthlyRepayment = mortgageAmount * avgRepayRate
            for _ in 1...monthlyPeriod {
                let monthlyInterest = principalLeft * monthRate
                totalInterest += monthlyInterest
                principalLeft = principalLeft - (monthlyRepayment - monthlyInterest)
            }
            drawDonut(principalRatio: mortgageAmount / (mortgageAmount + totalInterest), interestRatio: totalInterest / (mortgageAmount + totalInterest))
        }
        //算出總利息和每月平均攤還金額後就能顯示在結果label上
        interestAmountLabel.text = formatizeNumber(totalInterest.rounded())
        monthleRepaymentLabel.text = formatizeNumber(monthlyRepayment.rounded())
        //試算後鎖住TextField不能更動，並且試算按鈕換成重置按鈕
        lockForm()
        sender.isHidden = true
        resetButton.isHidden = false
    }
    
    @IBAction func resetFormButton(_ sender: UIButton) {
        //解鎖並且重設清空表單
        unlockAndRestForm()
        //隱藏清空按鈕並顯示試算按鈕
        sender.isHidden = true
        calcButton.isHidden = false
        //重設貸款總額、利息總額和每月平均攤還金額
        mortgageAmount = 0
        totalInterest = 0
        monthlyRepayment = 0
    }

}
