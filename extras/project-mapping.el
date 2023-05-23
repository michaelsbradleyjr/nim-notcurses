;;; project-mapping.el --- lsp-mode project mapping for nim-notcurses

;; Copyright (c) 2023 Michael Bradley
;;
;; Author: Michael Bradley
;; URL: https://github.com/michaelsbradleyjr/nim-notcurses
;;
;; This file is not part of GNU Emacs

;;; License:

;; This file is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 3, or (at your option) any later
;; version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
;; more details.
;;
;; For a full copy of the GNU General Public License see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; After starting Emacs to navigate the nim-notcurses repository, evaluate the
;; code below so that nim-notcurses' various entrypoints, examples, and tests
;; will be evaluated correctly by lsp-mode and nimlangserver

;;; Code:

(customize-set-variable
  'lsp-nim-project-mapping
  [(:projectFile "extras/lsp.nim" :fileRegex ".*\\.nim")])

;;; project-mapping.el ends here
