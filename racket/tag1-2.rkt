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

; Vergleich mit Java
;class Time {
;            private integer minute;
;
;                    public getMinute()
;                       { return minute}
;                    }
; Getter-Funktion
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
  dillo?                    ;; Prädikat
  (dillo-alive? boolean)
  (dillo-weight natural))


;; Neu: Prädikat!
(: dillo? (any -> boolean))

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

;;; Vereinfachung
#;(define run-over-dillo
  (lambda (dillo)
    (make-dillo #f (dillo-weight dillo))))


;;; ÜBUNG
;; Weiteres Tier:
;; - 2 Eigenschaften: Gewicht und "freie Wahl"
;; - Funktion, die das Tier überfährt


;; Ein Papagei hat folgende Eigenschaften:
;; - Gewicht in Gramm
;; - Satz, den er sagt

(define-record-functions parrot
  make-parrot
  parrot?
  (parrot-weight natural)
  (parrot-sentence string))

(define parrot1 (make-parrot 1000 "Mein Schatz!!!")) ; Piratenpapagei, 1 kg
(define parrot2 (make-parrot 4000 "Ich grüße Sie")) ; höflicher Papagei, 4 kg


(: run-over-parrot (parrot -> parrot))
(check-expect (run-over-parrot parrot1)
              (make-parrot 1000 ""))

(define run-over-parrot
  (lambda (parrot)
    (make-parrot (parrot-weight parrot) "")))

;; UNGETESTET!
(define parrot-alive?
  (lambda (parrot)
    (not (string=? "" (parrot-sentence parrot)))))
    


;;;; GEMISCHTE DATEN
;; Ein Tier (animal) ist eines der folgenden
;; - Gürteltier
;; - Papagei
;; ("ist eines der folgenden" -> gemischte Daten)

(define animal
  (signature (mixed dillo parrot)))



;; Wir wollen Tiere überfahren
;; run-over-animal
(: run-over-animal (animal -> animal))
(check-expect (run-over-animal dillo1)
              (make-dillo #f 20000))
(check-expect (run-over-animal parrot1)
              (make-parrot 1000 ""))

(define run-over-animal
  (lambda (animal)
    (cond
      ((parrot? animal) (run-over-parrot animal))
      ((dillo? animal) (run-over-dillo animal)))))

;;; ÜBUNG

;; Ist das gegebene Tier lebendig?
(: animal-alive? (animal -> boolean))

(check-expect (animal-alive? dillo1)
              #t)
(check-expect (animal-alive? dillo2)
              #f)
(check-expect (animal-alive? parrot1)
              #t)
(check-expect (animal-alive? (make-parrot 2000 ""))
              #f)


(define animal-alive?
  (lambda (animal)
    (cond
      ((dillo? animal) (dillo-alive? animal))
      ((parrot? animal) (parrot-alive? animal)))))


;;;;; Daten mit Selbstbezug


;; Ein Bach hat folgende Eigenschaften
;; - Ursprungsort
;; -> zusammengesetzte Daten

(define-record-functions bach
  make-bach
  bach?
  (bach-ursprung string))

;; Ein Zusammentreffen zweier Flüsse besteht aus
;; - Ort
;; - Hauptfluss
;; - Nebenfluss

(define-record-functions zusammentreffen
  make-zusammentreffen
  zusammentreffen?
  (zusammentreffen-ort string)
  (zusammentreffen-haupt fluss)
  (zusammentreffen-neben fluss))


;;; Ein Fluss ist eins der folgenden:
;; - Bach
;; - Zusammentreffen zweier Flüsse
;; -> Gemischte Daten

(define fluss
  (signature (mixed zusammentreffen bach)))

(define eschach (make-bach "Heimliswald"))
(define prim (make-bach "Dreifaltigkeitsberg"))
(define schlichem (make-bach "Tieringen"))

(define neckar (make-zusammentreffen "Rottweil"
                                     prim
                                     eschach))

(define neckar2 (make-zusammentreffen "Epfendorf"
                                      neckar
                                      schlichem))

;;; Fließt der Fluss durch den angegebenen Ort?
(: fließt-durch? (fluss string -> boolean))

(check-expect (fließt-durch? eschach "Heimliswald")
              #t)
(check-expect (fließt-durch? eschach "Rottweil")
              #f)
(check-expect (fließt-durch? neckar "Rottweil")
              #t)
(check-expect (fließt-durch? neckar "Heimliswald")
              #t)
(check-expect (fließt-durch? neckar "Tieringen")
              #f)
(check-expect (fließt-durch? neckar2 "Epfendorf")
              #t)

;;; Schablone
#;(define fließt-durch?
  (lambda (fluss ort)
    (cond
      ((bach? fluss) ...)
      ((zusammentreffen? fluss) ...))))
                                      
(define fließt-durch?
  (lambda (fluss ort)
    (cond
      ((bach? fluss) (string=? ort (bach-ursprung fluss)))
      ((zusammentreffen? fluss)
       (or
        (string=? ort (zusammentreffen-ort fluss))
        (fließt-durch? (zusammentreffen-haupt fluss)
                       ort)
        (fließt-durch? (zusammentreffen-neben fluss)
                       ort))))))
  
                                     
;;; TAG 2

;; Wiederholung Records / zusammengesetzte Daten
(define-record-functions auto
  make-auto
  auto?
  (auto-farbe string)
  (auto-v natural))


;;;ÜBUNG
;; - Stelle den Datentyp "Bruch" dar
;; - Schreibe eine Funktion, die zwei Brüche miteinander multipliziert


(define-record-functions bruch
  make-bruch
  bruch?
  (bruch-zähler integer)
  (bruch-nenner natural))




