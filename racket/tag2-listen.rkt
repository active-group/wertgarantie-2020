;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname tag2-listen) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
(define liste1 (cons 5 empty))
(define liste2 (cons 1 (cons -2 empty)))
(define liste3 (cons 5 (cons -7 (cons 2 empty))))
(define liste4 (cons 3 liste3))

(define liste5 (list 1 2 3 4 5 6 7 8 9 10))


;;; Filtere alle positven Zahlen einer Liste
;; Rein: Liste
;; Raus: Liste

(: positives ((list-of integer) -> (list-of integer)))
(check-expect (positives liste1)
              liste1)

(check-expect (positives liste2)
              (list 1))
(check-expect (positives liste3)
              (list 5 2))
(check-expect (positives empty)
              empty)

(define positives
  (lambda (liste)
    (cond
      ((empty? liste) empty)
      ((cons? liste)
       (if (> (first liste) 0)
           (cons (first liste)
                 (positives (rest liste)))
           (positives (rest liste)))))))
       

;; ÜBUNGSAUFGABE
;; Filtere alle geraden Zahlen!
;; Hilfsfunktion "even?"





