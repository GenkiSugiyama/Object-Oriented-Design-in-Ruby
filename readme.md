# オブジェクト事項設計実践ガイド
## 単一責任のクラスを設計する
変更が簡単なコード（TRUEなコード）を書くために、それぞれのクラスが明確に定義された**単一の責任を持つ**ように徹底する

### TRUEなコードとは
- **見通しがいい（Transparent）**：
  変更するコードにおいても、そのコードに依存する別の場所のコードにおいても**変更がもたらす影響が明白である**
- **合理的（Reasonable）**：
  どんな変更であっても、**かかるコストは変更がもたらす利益にふさわしい**
- **利用性が高い（Usable）**：
  新しい環境、予期していなかった環境でも**再利用できる**
- **模範的（Exemplary）**：
  コードに変更を加える人が、上記の品質を自然と保つようなコードになっている

### クラスが単一責任か見極める方法
- **クラスの持つメソッドに対して問いただす**
  クラスにとってその質問に違和感がなければそのクラスの責任範囲は適切である
- **クラスを1文で説明してみる**
　「または〜」や「それと」が必要であればそのクラスは複数の責任を持っている

この時点でGearクラスは複数の責任を持っていることがわかる
**But**今すぐ設計を見直しコードを変更する必要はない

→現時点でGearクラスは将来的にアプリの1部品となることは明らかではあるが他のコードとどのような依存関係を持つかまでは**まだわからない**

→→現在のGearクラスは「見通しが良い」「合理的」という2の性質を持っている（依存関係がなく、変更が加わっても周りへの影響がないため）

そのため情報量が少ない現時点で改修を行うよりも、他のコードが生まれより多くの情報を持ったタイミングで再構成を考えた方が不透明な現時点で改修を行うよりもコストが低い可能性が高い→新しい依存関係をもてば、優れた設計の決定を下すために必要な情報を与えてくれる

何もしないことによる将来的なコストが現在と変わらない場合は**決定（改修）を延期しよう**

ただ、どんな変更が加わるかがわからなくても、そのクラスが**簡単に変更を受け入れられる**ようにコードを構成することは可能である

### 変更を歓迎するコードを書くためのテクニック
- **データではなく振る舞いに依存する**：データとして参照するのではなく振る舞いとして参照する。データを参照してしまうと変更があった際に全ての箇所でデータの修正を行わなければいけないが、振る舞いを参照すれば、その振る舞いを再定義するだけで済む！

- **データ構造を隠蔽する**：よくわからん

- **あらゆる箇所を単一責任にする**：特に繰り返し処理は「各要素に対して実行する処理」と「繰り返しの処理」の2つの責任を持っているので、繰り返しを分離することがよくある

### 単一責任のメソッドがもたらす恩恵
- **隠蔽されていた性質を明らかにする**：1メソッド＝1責任にすればそれぞれのメソッドが単一の目的を果たすようになり、結果的に**そのクラス全体が行うことが明確になる**

- **コメントをする必要がない**：コメントが必要な処理を別のメソッドに抽出すればそのメソッド名がコメントの目的を果たす

- **再利用を促進する**：小さなメソッドであれば、他のプログラマーはコードの複製ではなく、メソッドを再利用するようになるし、同様に小さな再利用可能なメソッドを作るようになり、アプリケーション全体で健康的なコードの書き方を促進する

- **他のクラスへの移動が簡単**：小さなメソッドであれば他のクラスへの流用（移動）が簡単。**設計の改善に対する障壁を下げてくれる**

### 単一責任のクラスを作ること

単一責任のクラスはその役割をアプリケーションの他の部分から隔離する。

その隔離によって悪影響を及ぼすことのない変更と重複のない再利用が可能となる。


## 依存関係を管理する

オブジェクトが以下の4つのことを知っている時、オブジェクトは依存関係にある

- **他のクラスの名前**：メソッド内で他のクラスの名前を使っている時など（GearはWheelというクラスが存在していることを予想している）

- **self以外のどこかに送ろうとするメッセージの名前**：「他のクラス.メソッド名」のように他のクラスがそのメソッド名に応答することを知っている時（GearはWheelインスタンスがdiameterに応答することを予想している）

- **メッセージが要求する引数**：他のクラスのインスタンス作成に必要な引数を知っている時（GearはWheel.newにrimとtireが必要なことを知っている）

- **↑の引数の順番**：メッセージが要求する引数の受け取る順番を知っている時（GearはWheel.newの最初の引数がrimで2番目がtireである必要があることを知っている）

上記の変更は依存元の変更によってそのクラスに依存しているクラスの変更が強制される可能性を高めてしまう

→クラス間の共同作業は必要不可欠のため一定の依存関係は避けられないので、その依存関係を管理し、**それぞれのクラスが持つ依存関係を最低限にする**ことが必要

### 疎結合なコードを書く
**依存オブジェクトの注入**

あるクラス内で他のクラス名そのものを参照している箇所は強い結合を生み出すことになってしまう。

依存先のクラス名が変更したら参照しているクラス内の依存先クラス名も変更しないといけないなど柔軟な変更が難しくなってしまう

そのような事態を防ぐためにクラス内で別のクラスを直接参照するのではなく、別の場所で作成された依存先クラスのオブジェクトをメソッドの引数などで「**外部から注入する**」ことで結合の切り離しを行うことができる

**インスタンス変数の作成を分離する**

もしアプリケーションの制約が厳しく依存オブジェクトの注入が難しい場合は、依存先クラスのインスタンス作成をクラス内で分離すべき

1. そのクラスのinitializeメソッドで依存先クラスのインスタンスも作成する
2. 依存先クラスインスタンス作成用のメソッドを準備する

**外部メッセージを隔離する**

あるメソッド内でself以外に送るメッセージ（外部のクラスが持つメソッド）を扱う場合は、外部メッセージの変更によってそのメソッドが壊れてしまう可能性をはらんでいる。

外部メッセージ自体の変更の可能性が高い場合は外部メソッド呼び出し用の専用のメソッドを作りカプセル化するべし

**引数の順番への依存を取り除く**

- 初期化の際の引数にハッシュを使う

  initializeメソッドで受け取る引数をハッシュ、キーワードで受け取れるようにする

- 明示的にデフォルト値を設定する

  1. initializeメソッドでfetchメソッドを使い、呼び出し元に値がない場合はデフォルト値を入れるように設定する

  2. initializeメソッドからデフォルト値を隔離し、独立したラッパーメソッド内に隔離する:

      デフォルト値がより複雑な場合ラッパーメソッドを作成した方が良い（デフォルト値が単純な数字や文字列であればfetchのようでいい）

- 複数のパラメーターを用いた初期化を隔離する

  呼び出すクラスが外部フレームワークの一部などで、自身ではそのクラスの修正が難しい場合は、自身のアプリケーション内で外部インターフェースへの依存を集約するためのメソッドを作成する

### 依存方向の管理

**依存方向の選択**

→**より抽象的なコードへの依存を意識する**

- 変更の起きやすさを理解する

  具象と中傷を認識する直接具体的なクラスオブジェクトに依存していると、依存先のクラスの変更があった場合に変更が必要になるかもしれない（具象クラスは抽象クラスより変更となる可能性が高い）

  「依存オブジェクトの注入」に抽象的なインスタンスの参照となる

- 大量に依存されたクラスを避ける

  多くの依存関係を持つクラスは影響が大きい

- 問題となる依存関係を見つける

  **（他のクラスに）依存されている数**と**要件が変わる可能性の高さ**で問題となる依存関係を見つける

  A：　「依存されている数が**多い**」×「要件が変わる可能性が**低い**」

  →抽象領域（抽象クラスやインターフェースなど）：変更は起こりにくいが、依存関係は多い（変更があると多くに影響を及ぼす）。抽象クラスはこの領域に納まるが、コードがこの領域にあるからといって抽象クラスであるとは限らない。常に領域Dに属しているかもしれないという意識を持っておく

  ただし、この領域だからといってそのコードが抽象的だとは限らない。依存関係を多く持つコードであれば常に注意しておくこと

  B：「依存されている数が**少ない**」×「要件が変わる可能性が**低い**」

  →中立領域：設計段階で最も考慮する必要がないコード。将来の変更の影響に対して自身が他のクラスに影響を及ぼす可能性がわずか

  C：「依存されている数が**少ない**」×「要件が変わる可能性が**高い**」

  →中立領域：より具象的なコードなため変更は多いが、依存するクラスはわずかなので問題ではない

  D：「依存されている数が**多い**」×「要件が変わる可能性が**高い**」

  →危険領域：ある変更がそのアプリの多くの部分に影響を及ぼしてしまう危険なコード

## 柔軟なインターフェースを作る

### インターフェースを定義する

#### クラスはレストランの厨房のようなもの

レストランでは顧客がメニューを注文すれば厨房でどのように調理が行われているかを感知することなく注文してきた料理が提供される

→オブジェクト指向のクラス設計も同様で、メニューと同意の **パブリックインターフェース（外部利用可能なメソッド）** を用意し、厨房内の調理と同意の他の内部実装に関わるものは公開せず、そのクラス内のプライベートなメソッド にするべき

**パブリックインターフェースの特徴**

- クラスの主要な責任を明らかにする
- 外部から実行されることが想定される
- 気まぐれに変更されない
- 他者がそこに依存しても安全
- テストで完全に文書化されている

**プライベートインターフェースの特徴**

上記以外のメソッドは全てプライベートインターフェースに含まれる

- 実装の詳細に関わる
- 他のオブジェクトから送られてくることは想定されていない
- どんな理由でも変更され得る
- 他者がそこに依存するのは危険
- テストでは言及さえされないこともある

### パブリックインターフェースを見つける

#### 見当をつける

**ドメインオブジェクトを見つける**

→アプリケーションにおける「データ」と「振る舞い」の両方を兼ね備えたオブジェクト

文脈の中で名詞として出てくる、クラスのアイデアとなるオブジェクト（ヒト・モノがよく該当する）

ドメインオブジェクトに注目するだけでなく、ドメインオブジェクト間で交わされるメッセージにも注目する

#### 設計の第一段階としては要件を満たすために必要なオブジェクトとそのオブジェクト同士のメッセージの両方に見当をつけることが重要

→コードを書かなくても設計を検討し、相互理解を深める完結で低コストな方法とは？↓

#### シーケンス図を使う

ユースケースを参考に、必要なクラスとそのクラス間で交わされるメッセージを図式化していく

図式化によりクラスとクラス間のメッセージがあらわになることで、クラス間のメッセージ（パブリックインターフェース）に対し「このメッセージの受け手は、これに応える責任をおうべきなのだろうか」とメッセージに基づいた設計の考え方を実現することができる

「このメッセージを送る必要があるけれど、誰が応答すべきなんだろう」という疑問を持ちながらシーケンス図を書いていく **メッセージを送るためにオブジェクトが存在する**

#### 「どのように」を伝えるメッセージではなく、「何をして欲しい」と頼むメッセージを交わす
メッセージの送り手が、受け手に対し「どのように振る舞って欲しいか」を伝えるメッセージと作ってしまうと
送り手が受け手の詳細を知っていることになり、受け手に変更が加わるとその分送り手も変更せざるを得ない可能性を含んでしまう。

このように「どのように」を伝えるのではなく、シンプルに **『「何を」頼む』メッセージを送るように心がける**

そうすると、振る舞い方はメッセージの受け手に責任が渡されるので、送り手は受け手の変更にかかわらず常に正しい挙動を得ることができる

例）自転車が必要なTripクラスが旅行出発前にMechanicクラスに対し、自身の旅行に必要な自転車の整備を依頼するためのメッセージ

NG）「タイヤに空気を入れて」「ブレーキを確認して」「チェーンを整備して」など細かく整備方法を指示する

→Mechanicに対し「どのように」を伝えてしまっているので、Mechanic側で新しい整備ルール（メソッド）が追加されるとTripからMechanicに送るメッセージを追加しなければならない

OK)「自転車を準備して」のみ

→シンプルに「何を」頼んでいるので、振る舞い方はMechanic内のプライベートな処理となり、細かくルールが変わってもTripに影響が及ぶ恐れはない

また、このように「何を」伝えるメソッドをパブリックインターフェースにすることで、パブリックインターフェースのサイズが小さくなり、他から依存されるメソッドがわずかとなって他のクラスに変更を矯正する可能性を下げることができる

## ダックタイピングでコストを削減する

あるオブジェクトの型（type）に関連したインターフェースを作るのではなく、特定のクラスに関連しない複数のクラスをまたぐインターフェースを作る方法が**ダックタイピング**


**ダックタイピングで設計しない場合↓**

ある特定の型を持つクラスのインスタンスを引数にとるメソッドを書いてしまうと、何らかの変更が入り想定のクラス以外にも引数にとることが必要となった場合に大きく変更しなければいけない恐れがある

また、このときにとる対応は、引数にとる異なるクラスが応答するメッセージを調べ、メソッド内でcase文を用いてクラスによって処理を切り替えることになりより多くのクラスへの依存を生み出してしまう。

### ダックを見つけるために

**「パブリックインターフェースは単一の目的を果たすためにあるので、その引数も単一の目的を共に達成するために渡されることを認識すること」**

あるクラスのインターフェースの引数に使用されるオブジェクトはそのクラスの目的を達成するために必要な振る舞いを行うだけであってオブジェクトがどのような型・クラスなのかは関係ない

上記はどのインターフェース、その引数も同じ理由のために存在しており、その引数の背後にあるクラスは目的達成には関係しない

あるクラスはその目的を達成するために他のクラスに求めるただ1つの振る舞いを見つけ、その振る舞いに応答してもらうためのメッセージを作り、メッセージ受け取り先のクラスはそのメッセージに応答するように振舞う

### ダックを信頼するコードを書く

ダックを実装するうえで難しいのは、ダックを発見し、そのインターフェースを抽象化すること

#### 隠れたダックを認識する

以下のコーディングパターンはダックに置き換えることができる

- クラスで分岐するcase文
  
  ドメインオブジェクト（ユースケースに出てくる名詞など）のクラス名に基づいて分岐しているcase文

  このパターンを発見した際には「分岐を使っているメソッドがその引数それぞれに求めている共通・単一の目的は何だろう」と問いかける（サンプルコードのTripクラスのprepareメソッドの単一の目的は「旅行を準備すること」）

  上記の問いの答えから共通に送るべきメッセージが見つかり根底にあるダックタイプを定義することができる
- kind_of?とis_a?
  
  case文と同様に引数のクラスを確認するメソッド。

  上記のcase文をif文に書き直しただけなので同じテクニックで改善する
- responds_to?（メソッド名）

  オブジェクトのクラスではなく、オブジェクトが持つメソッドを確認するモノ

  クラスを明示的に指定しているわけではないが結局特定のクラスを想定している

#### ダックタイプを文書化する

設計している上でダックタイプとパブリックインターフェースは具体的なものとして存在するが、コード上では具体的にクラスを定義しているわけではなく抽象的なもの

→ダックタイプを作るときにはそのパブリックインターフェースの文書化（とテスト）を行う

#### 賢くダックを選ぶ

case文やkind_of?を使用しているメソッドを見つけたからといって全部をダックタイピングで変更すべきではない

言語の基本クラス（RubyのIntegerやHashなど）に依存するコードであれば、基本クラスへの変更はあまり考えられないのでそのままでも良いケースとなる

自分の定義したクラスをまたぐダックタイプを実装するのと、基本クラスを変更してダックタイプを実装するのは全く違うものになる（後者はダックタイプを導入する方がリスクが高まる）ので注意が必要

## 継承によって振る舞いを獲得する

### クラスによる継承を理解する

・type, style, categoryといった変数には要注意！

→メソッドに応答するクラスの型を判別・分類するために使用することが多い。この目的のためにメソッド内で使用されていると、そのメソッドは変更の影響を受ける可能性が高い

今回のBicycleクラスのように、ある程度相違はあるが関連している型をいくつか内包しているという問題を解決するのが**継承**

### 抽象的なスーパークラス（親クラス）を作る

スーパクラスは共通する振る舞いを持つ具体的なクラスの共通点のみを抜き出して作成する

共通点のみを抜き出すとそのスーパークラスは単一はでインスタンスとしての振る舞いはできないクラスとなる→抽象概念として定義する

そのような抽象的なスーパークラスを作った上で、スーパークラスの振る舞い＋独自の振る舞いを持つ、インスタンスが作られることを期待される具体的なクラスを定義する

### 抽象的な振る舞いを具体クラスから抽象クラスへ昇格する

継承すべき部分を見つけた場合はのリファクタリング方法は、

1. 一度全てのメソッドを具体クラスに降格させる

2. その上で共通の振る舞いを持つ他のクラスにも使用されるような抽象的な振る舞いを、スーパークラスへ昇格させる

上記のような手法をとるのは、反対に抽象クラスから具体クラスへ降格のみ行おうとすると、抽象クラスに具体的なメソッドを残してしまう危険性があるため。

抽象的なスーパークラスを作るためのベストは方法は**具体的なサブクラスからコードを昇格させる**こと

### テンプレートメソッドを実装する

設計に携わっていない開発者がそのスーパークラスを継承するサブクラスを作成する際に、コードを見ただけでは一見把握できないような要件をサブクラスに課している場合がある

（例：サブクラスで実装する必要があるテンプレートメソッドがある（スーパークラスのコードを読んだだけではそれはわからない））

→どのクラスもクラス内で送信するメッセージの全てに、**必ず実装も用意するようにする**

### スーパークラスとサブクラス間の結合度を管理する

#### 結合度を理解する

サブクラス内でスーパークラスへsuperを送信する→スーパークラスも同様のメソッドを持っているということをサブクラスが知っていることになる→他のクラスの情報を持っているということは依存に繋がり変更の危険性を孕んでしまう

あくまでサブクラスの役割は、スーパークラスに特化を与えるのみにすべきで、そのスーパークラスとどのように関わるかは知らない方がいい

#### フックメッセージを使ってサブクラスを疎結合にする

superを使ってサブクラス側でスーパークラスとの関わり合いを作るのではなく、スーパークラス側でフックメッセージを使って、サブクラスの依存度を小さくする

## モジュールでロールの振る舞いを共有する

### 継承可能なコードを書く

1. 継承を使えないかと疑う余地のあるコードを見つけた場合の対処法

- **クラスによる継承**：オブジェクトのクラスは共通しているが、style・type・categoryのような変数をキーにしてどんなメッセージを受け手に渡すかを判別しているパターンのコードのリファクタリング、変数にしている値をサブクラスとして作成&共通のコードを保有するスーパークラスを作成
- **ダックタイプ**：メッセージの受け手のクラスを判別して送るメッセージを判別しているコードのリファクタリング、インターフェースだけ共有することもあるし（5章の「prepare_trip」、prepare_tripの中身はメッセージを受け取るクラスごとに異なっていた）、振る舞いまで共有することもある（7章）。その場合は共通のコードはモジュールとして作成しそれぞれのクラスやオブジェクトでインクルードする。

2. 抽象に固執する

      抽象スーパークラス内のコードを使わないサブクラスがあってはならない。一部のサブクラスでしか使わないようなコードはスーパークラス内で定義してはいけない。

      サブクラスはスーパークラスと常に置換可能（スーパークラス内のメソッドを全てオーバーライドし、サブクラスのオブジェクトで使用可能な状態）であるべき

      「システムが正常であるためには、派生型は、上位型と置換可能でなければならない」という **リスコフの置換原則（LSP）** に従う

3. テンプレートメソッドパターンを使う
      
      継承可能なコードを書くための最も基本的なコーディング手法がテンプレートメソッドパターンの使用

      テンプレートメソッドは具象クラスが抽象クラスをオーバーライドして変化する場所を表すので、何が変化するもので何が変化しないものなのかを強制的に決めざるを得なくなる

4. 前もって疎結合にする

      サブクラス側でsuperを使ってスーパークラスを呼び出すようなコードを書くのを避ける

      代わりにスーパクラス側でフックメッセージを作り、サブクラスでオーバーライドする

5. 階層構造は浅くする

      階層を深くしてしまうと中間層のクラスが軽視され、その分中間層クラスで変更が会った際にエラーが起きやすくなってしまう