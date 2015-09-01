//
//  CourseCommentViewController.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/1.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class CourseCommentViewController: UIViewController {
    
    let dummyData = ["在近簡藥來再如得根變、但倒我果了住是效第車好，銀明都本接道神總開國上因不果他北進人先是臺線馬。是冷去玩，長獲張性父，服件查口。邊推入廣信體家之可自四？小時電們能？就家要人能不然學員個！大於了十。但一學驗大著據的入一企洲天說死也團狀些此會時地。我好而體指分。者東實子工西時件，好更代竟那，國自聲的樣技腳單衣記冷如性得無用行強助們地考師微操去坐是身早媽照之！上他打中，興調部給長人縣！元這麼國操力體主況數竟品決始有水資，學了子之就聽營方樂本斷說下陽那功，樂心即電北方環識歌支人時北到信是是關府服值；漸成非新作雖開行里自天。環不仍；體各利見決因的……家走為，事有我雖接只。個作主參氣錢能出動飛甚上原的出生英當我寫當己而，清設上？多是轉點；在此遊對世家術音引示明明岸位合會於燈明理用進心到故媽、無整好復有只他中是如……建但天竟論中。爸腦天教新安活比辦究你，花方決為明大府的：是麼何謝呢重先全進。", "在近簡藥來再如得根變、但倒我果了住是效第車好，銀明都本接道神總開國上因不果他北進人先是臺線馬。", "停個要國實未有為形裡心，兩了自積器議標細合卻！對觀香關來……見日益先。也影美後民上有在。望叫生良視清不不意念子大。然考我，不校草可長另量？來合了費該不城自後小為同關白生學關十不等送照分通美平的岸合成面地場上個市時的此注！決前？", "加最慢來生我無生大然，題紀文野此以這經候位，小精說，省出麼，為態為有行過大站西老同個唱！是香出設音在現與他創解特。要效密分歡；我力經接，列又書，的來安公點去發不遠安衣大朋臺，還做後體王度的心她白正怕處訴指上，親當少我再！出非待身一實房受時銀，能天視結都停統為多達年病不之見，二身備類到；顧益沒。候同力區明備市實廣話戰為特當長國成力存、知不用讀，都的放效次！用委種。算觀麗分兩化不列拉仍、轉或義放當那而金出，光出保至然有。可教大美量果隨注，子一孩作：師是病城師，樣是開但際場樹然自有多資。是動情散他學職不節隊家人務力動面國富反標，始光總球給大面了據不極就藝界日有重旅又走驚和助全列名、入基樂住檢觀報名的器理、情在賽然下所。約感。到邊新準女工，一領班清出日石們麼加親願則華牛公父後再民導資它作。題得新難了有花舉體考著不在自收庭聽野下幾面我們。況無聲對三業要始場的成理法縣是假時管己務長安你法有戰戰觀回為到就用受打業刻賽色裡銀業過……民起了已……院方定大備對們到小克查；家成灣生來變部怎部地系：足點的線人歷，須人期界面質斷告完時園單才不上灣多公當足而登觀的草。"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // configure tableview
        self.tableView.estimatedRowHeight = 144
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    
    private struct Storyboard {
        static let CourseCommentCellIdentifier = "CourseCommentCell"
    }
}

extension CourseCommentViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CourseCommentCellIdentifier, forIndexPath: indexPath) as! CourseCommentCell
        cell.commentContentLabel.text = dummyData[indexPath.row%dummyData.count]
        
        return cell
    }
}