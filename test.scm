;;
;; test Gauche-text-kakasi
;;

(use gauche.test)
(add-load-path ".")

(test-start "Gauche-text-kakasi")
(use text.kakasi)
(test-module 'text.kakasi)

(test-end)
