;;
;; test Gauche-kakasi
;;

(use gauche.test)
(add-load-path ".")

(test-start "Gauche-kakasi")
(use text.kakasi)
(test-module 'text.kakasi)

(test-end)
