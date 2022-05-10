;;;
;;; Gauche-kakasi
;;;
;;; Copyright (C) 2003  Shiro Kawai (shiro@acm.org)
;;;
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either versions 2, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with KAKASI, see the file COPYING.  If not, write to the Free
;;; Software Foundation Inc., 59 Temple Place - Suite 330, Boston, MA
;;; 02111-1307, USA.

(define-module text.kakasi
  (use gauche.charconv)
  (use srfi-1)
  (use srfi-11)
  (use srfi-13)
  (export kakasi-getopt-argv kakasi-do kakasi-close-kanwadict
          kakasi-begin kakasi-end kakasi-cleanup kakasi-convert
          with-kakasi
          kakasi-wakati kakasi-wakati-hiragana kakasi-wakati-roman
          )
  )
(select-module text.kakasi)

(inline-stub
 (.include <libkakasi.h>)
 (define-cproc kakasi-getopt-argv (args) ::<int>
   (let* ([argc::int (Scm_Length args)])
     (when (<= argc 1)
       (Scm_Error "a list of at least two element is required, but got: %S"
                  args))
     (return (kakasi_getopt_argv argc (Scm_ListToCStringArray args TRUE NULL)))
     ))

 (define-cproc kakasi-do (str::<string>)
   (let* ([r::char* (kakasi_do (cast char* (Scm_GetString str)))]
          [sr (SCM_MAKE_STR_COPYING r)])
     (kakasi_free r)
     (return sr)))

 (define-cproc kakasi-close-kanwadict () ::<fixnum>
   kakasi_close_kanwadict)
 )

;;--------------------------------------------------------
;; High-level API
;;

;; Issue: kakasi needs to be re-initialized every time new
;; option is issued.  Before re-initialization, the default
;; dictionary (kanwadict) should be closed.  This gets tricky
;; if you want a safe _and_ efficient API.

;; This intermediate API provides safe API by nested kakasi-begin/end
;; calls, with achieving efficiency by delaying finalization and
;; re-initialization until needed.

(define *current-options* #f)
(define *requested-options* #f)
(define *requested-option-stack* '())

;; internal finalization
(define (open-kakasi)
  (and *requested-options*
       (let1 r (kakasi-getopt-argv (cons "gauche-kakasi" *requested-options*))
         (and (zero? r)
              (begin (set! *current-options* *requested-options*)
                     #t)))))

(define (close-kakasi)
  (when *current-options*
    (kakasi-close-kanwadict)
    (set! *current-options* #f)))

;; Encoding stuff.
(define-values (iconvert oconvert convopt)
  (case (gauche-character-encoding)
    [(euc-jp) (values identity identity '("-ieuc" "-oeuc"))]
    [(sjis)   (values identity identity '("-isjis" "-osjis"))]
    [(utf-8)  (values (cut ces-convert <> "utf8" "euc_jp")
                      (cut ces-convert <> "euc_jp" "utf8")
                      '("-ieuc" "-oeuc"))]
    [(none)   (values identity identity '())]))

;; option -> args
(define (convert-args args)
  (let loop ([args args]
             [r '()])
    (cond [(null? args) (append convopt (reverse r))]
          [(keyword? (car args))
           (loop (cdr args) (cons #`"-,(keyword->string (car args))" r))]
          [else
           (loop (cdr args) (cons (x->string (car args)) r))])))

;; see if two option sets are the same
(define (options=? opt1 opt2)
  (define (opts&dicts opt) (span (cut string-prefix? "-" <>) opt))
  (and opt1
       opt2
       (let-values ([(opts1 dicts1) (opts&dicts opt1)]
                    [(opts2 dicts2) (opts&dicts opt2)])
         (and (lset= equal? opts1 opts2)
              (equal? dicts1 dicts2)))))

(define (kakasi-begin . opts)
  (when *requested-options*
    (push! *requested-option-stack* *requested-options*))
  (set! *requested-options* (convert-args opts)))

(define (kakasi-convert string)
  (unless *requested-options*
    (error "kakasi-convert is called outside kakasi-begin/end region"))
  (unless (options=? *current-options* *requested-options*)
    (close-kakasi)
    (or (open-kakasi)
        (error "kakasi-getopt-argv failed")))
  (oconvert (kakasi-do (iconvert string))))

(define (kakasi-end . opts)
  (if (pair? *requested-option-stack*)
      (set! *requested-options* (pop! *requested-option-stack*))
      (set! *requested-options* #f)))

(define (kakasi-cleanup)
  (close-kakasi))

(define-syntax with-kakasi
  (syntax-rules ()
    [(_ opts . body)
     (dynamic-wind
      (^[] (kakasi-begin . opts))
      (^[] . body)
      (^[] (kakasi-end)))]
    ))

;;--------------------------------------------------------
;; Utility
;;

;; Wakachi-gaki
(define (kakasi-wakati str)
  (with-kakasi (:w) (string-tokenize (kakasi-convert str))))

(define (kakasi-wakati-hiragana str)
  (with-kakasi (:s :JH :KH :kH) (string-tokenize (kakasi-convert str))))

(define (kakasi-wakati-roman str)
  (with-kakasi (:s :Ja :Ka :Ha :Ea :ka) (string-tokenize (kakasi-convert str))))

(provide "text/kakasi")
