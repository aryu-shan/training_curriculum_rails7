class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
     get_week
     @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

   def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例) 今日が2月1日の場合・・・ Date.today.day => 1日

     @week_days = [] #1週間分の予定を格納するための空のリストを作成

    plans = Plan.where(date: @todays_date..@todays_date + 6) #今日から1週間分の予定を取得
    #Plan.where=指定した期間内の予定をデータベースから取得。今日~6日後までの予定を取得して、plansに保存。
    #「..」は「～」の役割。今日～6日後のこと

    7.times do |x| #1週間分の日にちと予定を取得してリストに追加。ｘ＝0から6までの数値を代入
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
        #現在の日にち（@todays_date + x）と一致する日付を持つ予定を today_plans 配列し追加。
        #plan.plan は予定の内容。
      end
            
      wday_num = (@todays_date + x).wday# wdayメソッドを用いて取得した数値
      if wday_num >= 7 #「wday_numが7以上の場合」という条件式
        wday_num = wday_num -7
      end

      days = {month: (@todays_date + x).month, date:(@todays_date+x).day, plans: today_plans, wday: wdays[wday_num]}
       # daysハッシュに月、日、今日の予定(today_plans配列)、および曜日(wday)を格納
      @week_days.push(days)  # 今日から1週間分の情報を@week_daysリストに追加
    end
  end
end
