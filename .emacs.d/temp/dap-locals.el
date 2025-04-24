(defun my/dap-ui-locals-refresh ()
  "keep drop down from going up"
  (dap-ui-locals--refresh)
  (dap-ui-locals))

(advice-add 'dap-ui-locals--refresh :around #'my/dap-ui-locals-refresh)
