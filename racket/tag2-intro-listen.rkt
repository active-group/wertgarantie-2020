;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname tag2-intro-listen) (read-case-sensitive #f) (teachpacks ((lib "image.rkt" "teachpack" "deinprogramm" "sdp"))) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ((lib "image.rkt" "teachpack" "deinprogramm" "sdp")))))
;; Eine Liste von Zahlen ist eines der folgenden
;; - leere Liste
;; - nicht-leere Liste

(define list-of-integer
  (signature (mixed empty-list cons-of-integer)))

;; Eine leere Liste ist... nix?

(define-record empty-list
  make-empty-list
  empty?)

(define empty (make-empty-list))

;; Eine nicht-leere Liste besteht aus
;; - Einer Zahl (Kopf der Liste)
;; - Einer weiteren Liste der restlichen Zahlen

(define-record cons-of-integer
  cons
  cons?
  (first integer)
  (rest list-of-integer))


(define liste1 (cons 5 empty))
(define liste2 (cons 1 (cons 2 empty)))


