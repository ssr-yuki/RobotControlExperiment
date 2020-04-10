# RobotControlExperiment

ver 1.1.0 <br>
<br>
ロボット技術研究会の制御体験会用シミュレーションのリポジトリです。<br>
初めての人は，[wiki](https://github.com/YukiOrigane/RobotControlExperiment/wiki)へどうぞ！
## アップデート情報
- システムレベルの変更機能が実装されました。
  - システムレベルとは，システムに加わる外乱や誤差を変更できるようにするものです。
  - システムレベルが高いほど，色々な誤差や外乱が入る感じにしようと思っています。
  - 実装済みのシステムレベルは次の通りです
    - システムレベル0 : なんにもない
    - システムレベル1 : 慣性の実装（標準）
    - システムレベル2 : 慣性に加え，制御出力に偏った外乱
  - システムレベルの変更は，変数system_levelに記述し，現在のところ，robot.mでいじることを想定しています。
  - システムレベルについては，list_system_config.mに記述されています。
    - system_configという連想配列を直接いじることも可能です。
  - システムの変更は，いままで上手くいっていた制御が使い物にならなくなることもあるので（なるべく避けますが）十分注意して行ってください。

## 基本の使い方
- simulation.mを実行する


