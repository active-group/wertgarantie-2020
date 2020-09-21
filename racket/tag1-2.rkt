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