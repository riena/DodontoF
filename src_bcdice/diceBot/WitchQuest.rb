#--*-coding:utf-8-*--

class WitchQuest < DiceBot
  
  def prefixs
    ['WQ\d+', 'SET\d+']
  end
  
  def gameName
    'ウィッチクエスト'
  end
  
  def gameType
    "WitchQuest"
  end
  
  def getHelpMessage
    return <<MESSAGETEXT
・チャレンジ(成功判定)(WQn)
　n回2d6ダイスを振って判定を行います。
　例）WQ3
・SET（ストラクチャーカードの遭遇表(SETn)
　ストラクチャーカードの番号(n)の遭遇表結果を得ます。
　例）SET1　SET48
MESSAGETEXT
  end
  
  def changeText(string)
    string
  end
  
  
  def rollDiceCommand(command)
    case command
    when /WQ(\d+)/
      number = $1.to_i
      return challenge(number)
    when /SET(\d+)/
      number = $1.to_i
      return getStructureEncounter(number)
    end
    
    return nil
  end
  
  def challenge(number)
    success = 0
    results = []
    
    number.times do
      value1, = roll(1, 6)
      value2, = roll(1, 6)
      
      if( value1 == value2 )
        success += 1
      end
      
      results << "#{value1},#{value2}"
    end
    
    successText = "(#{results.join(' / ')}) ＞ " + getSuccessText(success)
    return successText
  end
  
  def getSuccessText(success)
    table = [[0, "失敗"],
             [1, "１レベル成功(成功)"],
             [2, "２レベル成功(大成功)"],
             [3, "３レベル成功(奇跡的大成功)"],
             [4, "４レベル成功(歴史的大成功)"],
             [5, "５レベル成功(伝説的大成功)"],
             [6, "６レベル成功(神話的大成功)"],
            ]
    
    if( success >= table.last.first )
      return table.last.last
    end
    
    return get_table_by_number(success, table)
  end
  
  def getStructureEncounter(number)
    debug("getStructureEncounter number", number)
    
    tables = [[1, %w{船から降りてきた 魚を売っている 仕事で忙しそうな 異国から来た おもしろおかしい 汗水流している}],
              [2, %w{おかしな格好をした 歌を歌っている ステキな笑顔をした 日なたぼっこをしている 悩んでいる 旅をしている}],
              [3, %w{待ちぼうけをしている 壁に登っている タバコを吸っている 踊りを踊っている 幸せそうな 向こうから走ってくる}],
              [4, %w{見張りをしている しゃべれない 見張りをしている 一輪車に乗った 元気いっぱいの 真面目な}],
              [5, %w{ウソつきな 買い物をしている ギターを弾いている あなたのほうをじっと見ている ポップコーンを売っている 屋台を出している}],
              [6, %w{子供を探している 時計を直している 物乞いをしている 気象実験をしている 飛び降りようとしている 時間をきにしている}],
              [7, %w{目の見えない 金持ちそうな 一人歩きをしたことがない ふられてしまった 待ち合わせをしている 道に迷った}],
              [8, %w{お祈りをしている スケッチをしている 勉強熱心な 記念碑を壊そうとしている 大きな声で文句をいっている 記念撮影している}],
              [9, %w{隠れている はしごに登っている 鐘を鳴らしている 共通語の通じない 記憶を失った あなたのほうにバタッと倒れた}],
              [10, %w{暇そうな 笑ったことがない ぶくぶくと太った 後継者を探している 王様におつかえしている 愛国心旺盛な}],
              [11, %w{閉じ込められた 悲しそうな 怒っている 降りれなくなっている もの憂げな 飛ぼうとしている}],
              [12, %w{釣りをしている 泳いでいる 川に物を落としてしまった 砂金を掘っている 川にゴミを捨てている カエルに化かされてしまった}],
              [13, %w{世間話をしている 結婚を薦めたがる いやらしい話の好きな 選択をしている 水を汲んでいる 井戸に落ちてしまった}],
              [14, %w{人におごりたがる 踊り子をしている 賭けをしている 泣き上戸な 飲み比べをしている 自慢話をしている}],
              [15, %w{素朴そうな 田舎者の あなたをだまそうとしている ケンカをしている 泊まるお金のない あなたに依頼をしにきた}],
              [16, %w{悪い占いの結果しか言わない あなたに嫉妬している 魅惑的な おしつけがましい いいかげんな占いしかしない 変わった占いをしている}],
              [17, %w{かくれんぼをしている あまやどりをしている (ここにはだれもいません) 家の掃除をしている 取り壊しをしようとしている 昔ここに住んでいた}],
              [18, %w{畑を耕している 畑を荒らしている 畑泥棒の 収穫している 日焼けして真っ黒な 嫁いできた(婿にきた)}],
              [19, %w{粉をひいている 馬に乗って風車に突進している 風が吹かなくて困っている 寝ている 筋骨りゅうりゅうな 遊んでいる}],
              [20, %w{パーティーをしている 酔っ払っている 酒を仕込んでいる 即売会をしている 笑っている 太った}],
              [21, %w{ひとりたたずむ 花から生まれた 花が大好きな 花粉症の 花を買いにきた ラグビーをやって花をあらしてる}],
              [22, %w{几帳面な 眼鏡をかけた なまいきな なわとびをしている 困っている ませている}],
              [23, %w{本を読んでいる 世間話をしたがる 派手な格好をした 勉強熱心な うるさい 魔女のことについて調べている}],
              [24, %w{神父さんに相談をしている 結婚式を挙げている 物静かな 片足の無い 熱い視線を送ってくる 挑発してくる}],
              [25, %w{頑固な 刀の切れ味をためしたがる いいかげんな性格の スグに弟子にしたがる 見せの前でウロウロしている 道を尋ねている}],
              [26, %w{不機嫌な 客の意見を聞かない 物を売らない 不幸な気前のいい 発明家の}],
              [27, %w{恋人にプレゼントを探している 香り中毒になった 客に手伝わせる おまじないの好きな 人好きのする いじめっこな}],
              [28, %w{騒がしい お菓子を食べて涙を流している 笑いの止まらない 甘い物に目がない 別れ話をしている あなたをお茶に誘う}],
              [29, %w{フランスパンを盗んで走る しらけた顔をした 店番をする あなたをバイトで使いたがる 変なパンしか作らない 朝が苦手な}],
              [30, %w{偏屈な 威勢のいい ケンカっぱやい 野次馬根性の強い 肉が食べれない 心優しく気前がいい}],
              [31, %w{夫婦ケンカをしている 猫に魚を盗られた 助けを求めている 魚の種類がわからない 『おいしい』としかいわない あやしい}],
              [32, %w{ヤンキー風の 自分がかっこいいと思っている 力自慢の 元は王様だといいはる 魔女のファンだという 子沢山の}],
              [33, %w{わがままな かっこいい 独り言を言っている 変わった料理しかださない 目茶苦茶辛い料理を食べている デートをしている}],
              [34, %w{仮病を使っている 不治の病を持った ”おめでた”の フケた顔した 髪の毛を染めた (健康でも)病名をいいたがる}],
              [35, %w{実験をしたがる 精力をつけたがっている 惚れ薬を探している 薬づけになっている この町まで薬を売りに来た 睡眠薬で自殺をしようとしている}],
              [36, %w{服まで質に入れた 値段にケチをつけている 疲れている 子供を質に入れようとしている 涙もろい 人間不信な}],
              [37, %w{着飾った おねだりしている 退屈そうな 見栄っぱりな 高いものを薦める 宝石など買うつもりのない}],
              [38, %w{だだをこねている ぬいぐるみを抱いている あなたを侵略者と考えている あなたの”おしり”にさわる 幸せのおもちゃを売っている あなたを自分の子と間違えている}],
              [39, %w{人の話を聞かない 気分屋な カリアゲしかできない うわさ話の好きな 自動販売機を開発したという おせっかいな}],
              [40, %w{お風呂あがりの こきつかわれている シェイプアップしている 人から追われている 人の体をじろじろと見る この町を案内してほしいという}],
              [41, %w{サングラスをかけた みんな自分のファンと思っている あなたを役者と勘違いしている あなたはスターになれるという 手品をしている 『いそがしい』をいい続けている}],
              [42, %w{ギャンブルをしている 競技に出場している 全財産を賭けている 勇敢な 参加者を募っている 情けない競技(闘技)をしてる}],
              [43, %w{ダンスを踊っている ブレイクダンスをして場違いな 子供を背中におんぶしている あなたと踊りたがる 踊ったことのない 食べることに夢中な}],
              [44, %w{２階からお金をばらまいている 窓の奥で涙をながしている 窓から忍びこもう ピアノを弾いている ここに住んでいる 家に招待したがる}],
              [45, %w{馬にブラシをかけている 気性の激しい 騎手を探している 馬と話ができる 馬の生まれ変わりという 馬を安楽死させようか迷っている}],
              [46, %w{いたずら好きな ライバル意識の強い 魔法の下手な 魔法を信じない 自分を神と思っている 魔法を使って人を化かしたがる}],
              [47, %w{傷だらけな 両手に宝物を持った かわいい 地図を見ながら出てきている 剣を持った ダンジョンの主といわれる}],
              [48, %w{墓参りをしている 耳の遠い 死んでしまった 葬式をしている きもだめしをしている 墓守をしている}],
             ]
    
    table = get_table_by_number(number, tables, nil)
    return nil if( table.nil? )
    text, index = get_table_by_1d6( table )
    
    person = getPersonTable1()
    
    return "SET#{number} ＞ #{index}:#{text}#{person}"
  end
  
  def getPersonTable1()
    gotoNextTable = lambda{ "表２へ" + getPersonTable2() }
    
    table = [[11, "おじさん"],
             [12, "おばさん"],
             [13, "おじいさん"],
             [14, "おばあさん"],
             [15, "男の子"],
             [16, "女の子"],
             
             [22, "美少女"],
             [23, "美少年"],
             [24, "青年"],
             [25, "少年"],
             [26, "男女(カップル)"],
             
             [33, "新婚さん"],
             [34, "お兄さん"],
             [35, "お姉さん"],
             [36, "店主(お店の人)"],
             
             [44, "王様"],
             [45, "衛兵"],
             [46, "魔女"],
             
             [55, "お姫様"],
             [56, gotoNextTable],
             
             [66, gotoNextTable],
            ]
    
    getPersonTable(table)
  end
  
  def getPersonTable2()
    gotoNextTable = lambda{ "表３へ" + getPersonTable3() }
    
    table = [[11, "魔法使い"],
             [12, "観光客"],
             [13, "先生"],
             [14, "探偵"],
             [15, "刷"],
             [16, "お嬢様"],
             
             [22, "お嬢様"],
             [23, "紳士"],
             [24, "ご婦人"],
             [25, "女王様"],
             [26, "職人さん"],
             
             [33, "女子高生"],
             [34, "学生"],
             [35, "剣闘士"],
             [36, "鳥"],
             
             [44, "猫"],
             [45, "犬"],
             [46, "カエル"],
             
             [55, "蛇"],
             [56, gotoNextTable],
             
             [66, gotoNextTable],
            ]
    
    getPersonTable(table)
  end
  
  def getPersonTable3()
    gotoNextTable = lambda{ "表４へ" + getPersonTable4() }
    
    table = [[11, "貴族"],
             [12, "いるか"],
             [13, "だいこん"],
             [14, "じゃがいも"],
             [15, "にんじん"],
             [16, "ドラゴン"],
             
             [22, "ゾンビ"],
             [23, "幽霊"],
             [24, "うさぎ"],
             [25, "天使"],
             [26, "悪魔"],
             
             [33, "赤ちゃん"],
             [34, "馬"],
             [35, "石"],
             [36, "お母さん"],
             
             [44, "妖精"],
             [45, "守護霊"],
             [46, "猫神様"],
             
             [55, "ロボット"],
             [56, "恐ろしい人"],
             
             [66, gotoNextTable],
            ]
    
    getPersonTable(table)
  end
  
  def getPersonTable4()
    table = [[11, "魔女エディス"],
             [12, "魔女レーデルラン"],
             [13, "魔女キリル"],
             [14, "大魔女”ロロ”様"],
             [15, "エディスのお母さん”エリー”"],
             [16, "猫トンガリ"],
             
             [22, "猫ヒューベ"],
             [23, "猫ゆうのす"],
             [24, "猫集会の集団の一団"],
             [25, "岩"],
             [26, "PCの母"],
             
             [33, "PCの父"],
             [34, "PCの兄"],
             [35, "PCの姉"],
             [36, "PCの弟"],
             
             [44, "PCの妹"],
             [45, "PCの遠い親戚"],
             [46, "PCの死んだはずの両親"],
             
             [55, "初恋の人"],
             [56, "分かれた女(男)、不倫中の相手、または独身PCの場合、二股をかけている二人の両方"],
             
             [66, "宇宙人"],
            ]
    
    getPersonTable(table)
  end
  
  def getPersonTable(table)
    isSwap = true
    number = bcdice.getD66(isSwap)
    debug("getPersonTable number", number)
    
    " ＞ #{number}:" + get_table_by_number(number, table)
  end
  
  
  #以下のメソッドはテーブルの参照用に便利
  #get_table_by_2d6(table)
  #get_table_by_1d6(table)
  #get_table_by_nD6(table, 1)
  #get_table_by_nD6(table, count)
  #get_table_by_1d3(table)
  #get_table_by_number(index, table)
  
  
  #ダイス目が知りたくなったら getDiceList を呼び出すこと(DiceBot.rbにて定義)
end
