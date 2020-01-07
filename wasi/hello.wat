(module
 ;; WASIの fd_write を使って標準出力に文字列を出力する
 (import "wasi_unstable" "fd_write" (func $__wasi_fd_write (param i32 i32 i32 i32) (result i32)))
 ;; メイン処理の関数
 (func $_start
  ;; データをスタックに積んでいく
  i32.const 1 ;; どこに出力するか。標準出力はfd=1なので1を指定
  i32.const 0 ;; 文字列情報の構造体のポインタ。今回は0の位置に設置している
  i32.const 1 ;; 文字列のセット数。今回は1つなので1
  i32.const 8 ;; 返り値の格納先。今回は文字列情報の後ろに入れる。
  call $__wasi_fd_write ;; 上の4つの値を引数にして fd_write を実行
  drop ;; 返り値がスタックされているので消しておく
 )
 ;; 利用するメモリの確保
 (memory 1)
 (export "memory" (memory 0))
 ;; メモリにデータを書き込んでおく
 ;; 今回は[文字列情報][返り値の格納場所][文字列]という順番で格納されている
 ;; [文字列情報]は文字列の開始位置とそのサイズを4バイトずつ並べる。
 ;;             今回文字列は 8 + 4 の後にあるので12→0xCでサイズが13→0xDなのでそれが格納されている。
 ;; [返り値の格納場所] 4バイト必要。とりあえず0を詰めておく。
 ;; [文字列]は上にも書いたが 8 + 4 の位置から開始して13バイト分のデータがある
 (data (i32.const 0) "\0c\00\00\00\0d\00\00\00\00\00\00\00Hello, world!")
 (export "_start" (func $_start))
)