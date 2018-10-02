;;
;; Package Gauche-text-kakasi
;;

(define-gauche-package "Gauche-text-kakasi"
  ;; 
  :version "0.2"

  ;; Description of the package.  The first line is used as a short
  ;; summary.
  :description "Kakasi binding\n\
                http://kakasi.namazu.org/index.html.en."

  ;; List of dependencies.
  :require (("Gauche" (>= "0.9.6")))

  ;; List of providing modules
  ;; NB: This will be recognized >= Gauche 0.9.7.
  ;:providing-modules (text.kakasi)

  ;; List name and contact info of authors.
  ;; e.g. ("Eva Lu Ator <eval@example.com>"
  ;;       "Alyssa P. Hacker <lisper@example.com>")
  :authors ("Kimura Fuyuki <fuyuki@hadaly.org>"
            "Shiro Kawai <shiro@acm.org>")

  ;; List name and contact info of package maintainers, if they differ
  ;; from authors.
  ;; e.g. ("Cy D. Fect <c@example.com>")
  :maintainers ("Shiro Kawai <shiro@acm.org>")

  ;; List licenses
  :licenses ("GPL2")

  ;; Homepage URL, if any.
  ; :homepage "http://example.com/Gauche-text-kakasi/"

  ;; Repository URL, e.g. github
  :repository "https://github.com/shirok/Gauche-text-kakasi.git"
  )
