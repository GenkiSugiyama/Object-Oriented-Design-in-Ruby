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

・初期化の際の引数にハッシュを使う

initializeメソッドで受け取る引数をハッシュ、キーワードで受け取れるようにする

・明示的にデフォルト値を設定する

initializeメソッドでfetchメソッドを使い、呼び出し元に値がない場合はデフォルト値を入れるように設定する

initializeメソッドからデフォルト値を隔離し、独立したラッパーメソッド内に隔離する

　デフォルト値がより複雑な場合ラッパーメソッドを作成した方が良い（デフォルト値が単純な数字や文字列であればfetchのようでいい）
