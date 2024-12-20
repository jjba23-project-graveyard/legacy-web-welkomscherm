;;; web-welkomscherm

;; Copyright (C) 2024 Josep Jesus Bigorra Algaba

;; web-welkomscherm is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; web-welkomscherm is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with web-welkomscherm. If not, see <https://www.gnu.org/licenses/>.

(use-modules (sxml simple))

(define* (web-welkomscherm-html-template #:key title body)
  `(html (head (title ,title)
               (link (@ (rel "preconnect")
                        (href "https://fonts.googleapis.com")))
               (link (@ (rel "preconnect")
                        (href "https://fonts.gstatic.com")
                        (crossorigin "")))
               (link (@ (rel "stylesheet")
                        (href "https://fonts.cdnfonts.com/css/liberation-sans")))
               (link (@ (rel "stylesheet")
                        (href "css/fonts.css")))
               (link (@ (rel "stylesheet")
                        (href
                         "https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css")))
               (meta (@ (name "viewport")
                        (content "width=device-width, initial-scale=1.0")))
               (meta (@ (charset "UTF-8")))
               (script (@ (src "https://cdn.tailwindcss.com")) "")
               (script (@ (src "js/tailwind.config.js")) ()))
         (body (@ (class "break-words bg-stone-900"))
               (div (@ (class "container mx-auto my-4"))
                    ,@body))))

(define-public web-welkomscherm-bookmarks
  `(("DuckDuckGo" . "https://duckduckgo.com/")
    ("jointhefreeworld.org" . (("Home" . "https://jointhefreeworld.org/")
                               ("Byggsteg" . "https://byggsteg.jointhefreeworld.org/")))
    ("Guix Packages" . "https://packages.guix.gnu.org")
    ("Reddit" . "https://reddit.com")
    ("BoxIcons" . "https://github.com/atisawd/boxicons")
    ("GNU G-Golf ref" . "https://www.gnu.org/software/g-golf/manual/g-golf.html")
    ("Google" . (("Gmail" . "https://mail.google.com/")
                 ("Photos" . "https://photos.google.com/")))
    ))

(define (rec-make-bookmark l)
  (cond
   ((string? (cdr l))
    `(div (@(class "bg-stone-700/75 p-2 h-min rounded-xl"))
          (a (@ (class "text-stone-200")
                (href ,(cdr l)))
             ,(car l)))
    )   
   ((null? (cdr l)) `())
   (else
    `(div (@(class "flex flex-col gap-2 justify-center p-2 bg-stone-800/75 rounded-xl"))
          (span (@(class "text-xs font-bold text-stone-400")) ,(car l))
          (div (@(class "flex flex-row flex-wrap gap-4 justify-center"))
               ,(map (lambda(ll) (rec-make-bookmark ll)) (cdr l))
               )))
   )
  )

(define (web-welkomscherm-main-body)
  `((div (@ (class "flex flex-row flex-wrap gap-6 justify-center align-center items-center"))
         ,(map (lambda (l) (rec-make-bookmark l)) web-welkomscherm-bookmarks))))

(define (web-welkomscherm-page)
  (with-output-to-string (lambda ()
                           (sxml->xml (web-welkomscherm-html-template #:title
                                                                      "*welkomscherm*"
                                                                      #:body (web-welkomscherm-main-body))))))

(define (main args)
  (display args)

  (with-output-to-file "dist/index.html"
    (lambda ()
      (display (web-welkomscherm-page)))))

;; call main with command line arguments
;;
(main (command-line))
