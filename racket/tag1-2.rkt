;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname tag1-2) (read-case-sensitive #f) (teachpacks ((lib "image.rkt" "teachpack" "deinprogramm" "sdp"))) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ((lib "image.rkt" "teachpack" "deinprogramm" "sdp")))))
;;;; ZUSAMMENGESETZTE DATEN

;; Eine Uhrzeit besteht aus
;; - Stunde
;; - Minute

;; "besteht aus", "hat folgendes / folgende Eigenschaften"
;; --> Zusammengesetzte Daten
;; In Racket: "Record"

(define-record-functions time
  make-time                  ; Konstruktor
  (time-hour natural)        ; Stunden-Selektor
  (time-minute natural))     ; Minuten-Selektor

(define time1
  (make-time 12 15))

(define time2
  (make-time 20 30))

(: make-time   (natural natural -> time))
(: time-hour   (time -> natural))
(: time-minute (time -> natural))

; Vergleich Java
;class Time {
;            private integer minute;
;
;                    public getMinute()
;                       { return minute}
;                    }
;Getter-Funktion
;(define time-minute
;  (lambda (time)
;    (get-second-element time)))

;; ÜBUNGSAUFGABE
;; Schreibe ein Programm, das zu einer gegebenen Uhrzeit
;; die verstrichenen Minuten seit Mitternacht berechnet!

;;Berechne Minuten seit Mitternacht
;; minutes-since-midnight: msm


(: msm (time -> natural))
(check-expect (msm (make-time 03 15))  ;; Uhrzeit 01:00
              195)

(define msm
  (lambda (time)
    (define hour (time-hour time))
    (define minute (time-minute time))
    (+  
     (* 60 hour)
     minute)))

;; neue schablone!
;; Funktionen, die zusammengesetzte Daten konsumieren

#;(define msm
  (lambda (time)
    ...
    (time-hour time)
    ...
    (time-minute time)
    ...))


;; Berechne Zeit aus gegeben Minuten seit Mitternacht
;; Rein: Zahl, natural
;; Raus: Zeit, time

(: msm->time (natural -> time))
(check-expect (msm->time 195)
              (make-time 3 15))

;; weitere schablone!
;; Funktionen, die zusammengesetzte Daten zurückgeben

#;(define msm->time
  (lambda (...)
    ...
    (make-time ... ...)
    ...))

(define msm->time
  (lambda (minutenanzahl)
    (define hour (quotient minutenanzahl 60))
    (define minute (remainder minutenanzahl 60))
    (make-time hour minute)))


;; Ein Gürteltier hat folgende Eigenschaften
;; - lebendig oder tot
;; - Gewicht in g
;; "hat folgende Eigenschaften" -> zusammengesetzte Daten!

(define-record-functions dillo
  make-dillo
  (dillo-alive? boolean)
  (dillo-weight natural))

(define dillo1 (make-dillo #t 20000)) ; Gürteltier, lebendig, 20 kg
(define dillo2 (make-dillo #f 15000)) ; Gürteltier, tot, 15 kg

;; Überfahre ein Gürteltier!
;; Rein: Gürteltier, dillo
;; Raus: Gürteltier, dillo

(: run-over-dillo (dillo -> dillo))
(check-expect (run-over-dillo dillo1)
              (make-dillo #f 20000))
(check-expect (run-over-dillo dillo2)
              (make-dillo #f 15000))
(check-expect (run-over-dillo dillo2)
              dillo2)                 ; selber Test wie der drüber

(define run-over-dillo
  (lambda (dillo)
    (if (dillo-alive? dillo)
        (make-dillo #f (dillo-weight dillo))
        dillo)))













