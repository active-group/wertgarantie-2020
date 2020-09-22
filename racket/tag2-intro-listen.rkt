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
(define liste3 (cons 5 (cons 7 (cons 2 empty))))
(define liste4 (cons 3 liste3))

;; Addiere alle Zahlen einer Liste
;; Rein: Eine Liste
;; Raus: Eine Zahl
(: list-sum (list-of-integer -> integer))

(check-expect (list-sum liste1) 5)
(check-expect (list-sum liste2) 3)
(check-expect (list-sum liste3) 14)
(check-expect (list-sum empty) 0)


(define list-sum
  (lambda (liste)
    (cond
      ((empty? liste) 0)
      ((cons? liste)
       (+ (first liste)
          (list-sum (rest liste)))))))


;; Auswertungsschritte einer rekursiven Funktion
;(list-sum (5 7 2))
;
;cond -> cons?
;
;(+ (first (5 7 2))
;   (list-sum (rest (5 7 2))))
;
;-->>
;
;(+ 5
;   (list-sum (7 2)))
;
;--> nicht leer!
;(+ 5
;   (+ (first (7 2))
;      (list-sum (rest (7 2)))))
;  
;-->
;(+ 5
;   (+ 7
;      (list-sum (2))))
;
;--> (2) nicht leer!
;
;(+ 5
;   (+ 7
;      (+ (first (2))
;         (list-sum (rest (2))))))
;
;(+ 5
;   (+ 7
;      (+ 2
;         (list-sum empty))))
;
;--> () leere Liste!
;      
;(+ 5
;   (+ 7
;      (+ 2
;         0)))
;
;---> 14

