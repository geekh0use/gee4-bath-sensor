# gee4-bath-sensor

## 使い方
実行するとデーモンになってバックグラウンドで動き続けます。

カレントディレクトリに`pid.log`というファイルが出力されて、そこにプロセスIDが書いてあります。

エラーログが`furo.log`に出力されます

```
sudo ruby furo.rb start
```

止めるときは
```
sudo ruby furo.rb stop
```
