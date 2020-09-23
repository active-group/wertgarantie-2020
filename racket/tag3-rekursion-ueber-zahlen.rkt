;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname tag3-rekursion-ueber-zahlen) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
;;; Eine natürliche ist eins der folgenden
;; - 0
;; - der Nachfolger einer natürlichen Zahl (n + 1)
;; (Peano-Definition)

;; Fakultätsfunktion
;; gegeben Zahl n: Multiplizere n * (n-1) *(n-2) * ...* 1
;;   falls n = 0. (factorial 0) = 1
;; Beispiel     5               5 * 4 * 3 * 2 * 1

(: factorial (natural -> natural))
(check-expect (factorial 5)
              120)
(check-expect (factorial 3)
              6)
(check-expect (factorial 0)
              1)

(define factorial
  (lambda (n)
    (cond
      ((= n 0) 1)
      ((> n 0)
       (* n
          (factorial (- n 1)))))))


;;; ÜBUNG
;; Berechne die Gausssumme einer gegebenen Zahl n
;; Gaussumme von 10 ist 1 + 2 + 3 ... + 10












