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
;; Rein: Liste
;; Raus: Liste

(: evens ((list-of integer) -> (list-of integer)))
(check-expect (evens liste3)
              (list 2))
(check-expect (evens liste5)
              (list 2 4 6 8 10))
(check-expect (evens empty) empty)

(define evens
  (lambda (liste)
    (cond
      ((empty? liste) empty)
      ((cons? liste)
       (if (even? (first liste))
           (cons (first liste)
                 (evens (rest liste)))
           (evens (rest liste)))))))

;;; Allgemeine Filterfunktion
;; Bekommt:
;; - Ein Prädikat,(das ist eine Funktion, die ein Element Eigenschaft überprüft)
;; - Liste
;; Zurück: Liste

(: my-filter ((%a -> boolean) (list-of %a) -> (list-of %a)))

(check-expect (my-filter even? (list 1 2 3 4 5 6))
              (list 2 4 6))
(check-expect (my-filter positive? (list 1 -5 -2 3 -5))
              (list 1 3))

(define my-filter
  (lambda (predicate? liste)
    (cond
      ((empty? liste) empty)
      ((cons? liste)
       (if (predicate? (first liste))
           (cons (first liste)
                 (my-filter predicate? (rest liste)))
           (my-filter predicate? (rest liste)))))))


;; evens-2 mit Hilfe von my-filter
(check-expect (evens-2 liste3)
              (list 2))
(check-expect (evens-2 liste5)
              (list 2 4 6 8 10))
(check-expect (evens-2 empty) empty)

(define evens-2
  (lambda (liste)
    (my-filter even? liste)))

(define teilbar-durch-3?
  (lambda (zahl)
    (= (remainder zahl 3)
       0)))


(define teilbar-durch-3
  (lambda (liste)
    (my-filter teilbar-durch-3? liste)))

(define kurzes-wort?
  (lambda (wort)
    (< (string-length wort)
       4)))

(: kurze-worte ((list-of string) -> (list-of string)))
(define kurze-worte
  (lambda (liste)
    (my-filter kurzes-wort? liste)))


;;; ÜBUNGSAUFGABE
;; Schreibe Funktion, die Liste filtert: Behalte alle #t-Werte
;; Implementiere mit filter / my-filter





