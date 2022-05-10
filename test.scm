;; -*- coding: utf-8 -*-
;;
;; test Gauche-text-kakasi
;;

(use gauche.test)
(add-load-path ".")

(test-start "Gauche-text-kakasi")
(use text.kakasi)
(test-module 'text.kakasi)

(test* "with-kakasi :JH" "けっかをもじれつでかえします。"
       (with-kakasi (:JH)
         (kakasi-convert "結果を文字列で返します。")))

(test* "with-kakasi :w" "結果 を 文字列 で 返し ます 。"
       (with-kakasi (:w)
         (kakasi-convert "結果を文字列で返します。")))

(test* "kakasi-wakati" '("呼び出し" "側" "が" "呼ぶ" "必要" "はありません" "。")
       (kakasi-wakati "呼び出し側が呼ぶ必要はありません。"))

(test* "kakasi-wakati-hiragana"
       '("よびだし" "がわ" "が" "よぶ" "ひつよう" "はありません" "。")
       (kakasi-wakati-hiragana "呼び出し側が呼ぶ必要はありません。"))

(test* "kakasi-wakati-roman"
       '("yobidashi" "gawa" "ga" "yobu" "hitsuyou" "haarimasen" ".")
       (kakasi-wakati-roman "呼び出し側が呼ぶ必要はありません。"))

(test-end)
